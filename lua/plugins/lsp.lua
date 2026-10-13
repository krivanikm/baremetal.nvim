-- LSP: Mason installs the servers, nvim-lspconfig provides default configs,
-- we only tweak them with vim.lsp.config() (nvim 0.11+ API).

-- Everything Mason should install (LSP servers by lspconfig name + tools),
-- only for the languages selected in lua/custom/languages.lua
local langs = require("config.langs")

local lsp_servers = langs.pick({
  core = { "lua_ls", "jsonls", "yamlls", "taplo", "marksman" },
  c = { "clangd", "neocmake" },
  asm = { "asm_lsp" },
  systemverilog = { "verible" },
  vhdl = { "vhdl_ls" },
  python = { "basedpyright", "ruff" },
  go = { "gopls" },
  bash = { "bashls" },
})

local ensure_installed = vim.list_extend(
  vim.deepcopy(lsp_servers),
  langs.pick({
    core = { "stylua", "tree-sitter-cli", "prettierd" },
    c = { "clang-format" },
    bash = { "shfmt", "shellcheck" },
  })
)
if langs.has("c", "asm", "rust") then
  table.insert(ensure_installed, "codelldb")
end

-- Per-server tweaks
local servers = {
  clangd = {
    cmd = {
      "clangd",
      "--background-index",
      "--clang-tidy",
      "--header-insertion=iwyu",
      "--completion-style=detailed",
      "--function-arg-placeholders=true",
      "--fallback-style=llvm",
      "--query-driver=/usr/bin/*gcc*,/usr/bin/*g++*,/usr/bin/clang*,/usr/local/bin/*gcc*,/usr/local/bin/*g++*,/opt/homebrew/bin/*gcc*,/opt/homebrew/bin/*g++*", -- also cross compilers (arm-none-eabi-gcc, riscv64-...)
    },
    init_options = { usePlaceholders = true, completeUnimported = true, clangdFileStatus = true },
  },
  asm_lsp = {
    filetypes = { "asm", "nasm", "vmasm" },
    -- Without .asm-lsp.toml asm-lsp parses everything as GAS → false errors in NASM / custom ISAs.
    -- So diagnostics are shown only if the project has .asm-lsp.toml (completion/hover always work).
    handlers = {
      ["textDocument/publishDiagnostics"] = function(err, res, ctx)
        local client = vim.lsp.get_client_by_id(ctx.client_id)
        if client and client.root_dir and vim.uv.fs_stat(client.root_dir .. "/.asm-lsp.toml") then
          vim.lsp.diagnostic.on_publish_diagnostics(err, res, ctx)
        end
      end,
    },
  },
  verible = {
    cmd = { "verible-verilog-ls", "--rules_config_search" },
    root_markers = { ".rules.verible_lint", "verible.filelist", ".git" },
    -- verible sends diagnostics both by push and pull → without this each one shows up twice
    on_init = function(client) client.server_capabilities.diagnosticProvider = nil end,
  },
  -- For full project analysis add vhdl_ls.toml (list of libraries/files)
  vhdl_ls = {
    root_markers = { "vhdl_ls.toml", ".vhdl_ls.toml", ".git" },
    workspace_required = false,
  },
  lua_ls = {
    settings = {
      Lua = {
        workspace = { checkThirdParty = false },
        completion = { callSnippet = "Replace" },
        hint = { enable = true, arrayIndex = "Disable" },
        diagnostics = { globals = { "vim", "Snacks" } },
      },
    },
  },
  basedpyright = {
    settings = { basedpyright = { analysis = { typeCheckingMode = "standard" } } },
  },
  jsonls = {
    before_init = function(_, cfg) cfg.settings.json.schemas = require("schemastore").json.schemas() end,
    settings = { json = { validate = { enable = true } } },
  },
  yamlls = {
    before_init = function(_, cfg) cfg.settings.yaml.schemas = require("schemastore").yaml.schemas() end,
    settings = { yaml = { schemaStore = { enable = false, url = "" }, keyOrdering = false } },
  },
  gopls = {
    settings = { gopls = { hints = { parameterNames = true, assignVariableTypes = true }, staticcheck = true } },
  },
}

local function on_attach(client, buf)
  local function map(lhs, rhs, desc, mode) vim.keymap.set(mode or "n", lhs, rhs, { buffer = buf, desc = desc }) end
  -- Navigation (through the Snacks picker → preview when there are several results)
  map("gd", function() Snacks.picker.lsp_definitions() end, "Definition")
  map("gD", function() Snacks.picker.lsp_declarations() end, "Declaration")
  map("gr", function() Snacks.picker.lsp_references() end, "References")
  map("gI", function() Snacks.picker.lsp_implementations() end, "Implementation")
  map("gy", function() Snacks.picker.lsp_type_definitions() end, "Type definition")
  map("<leader>ci", function() Snacks.picker.lsp_incoming_calls() end, "Incoming calls")
  map("<leader>cI", function() Snacks.picker.lsp_outgoing_calls() end, "Outgoing calls")
  map("K", function() vim.lsp.buf.hover() end, "Hover docs")
  map("gK", vim.lsp.buf.signature_help, "Signature help")
  -- Actions
  map("<leader>ca", vim.lsp.buf.code_action, "Code action", { "n", "x" })
  map("<leader>cr", vim.lsp.buf.rename, "Rename symbol")
  map("<leader>cc", vim.lsp.codelens.run, "Codelens", { "n", "x" })
  map("<leader>cL", "<cmd>checkhealth vim.lsp<cr>", "LSP info")
  map(
    "<leader>cF",
    function() vim.lsp.buf.code_action({ apply = true, context = { only = { "source.fixAll" }, diagnostics = {} } }) end,
    "Fix all"
  )

  -- Inlay hints on by default (<leader>uh toggles)
  if client:supports_method("textDocument/inlayHint") then
    vim.lsp.inlay_hint.enable(true, { bufnr = buf })
  end
  -- Codelens ("▶ Run", reference counts) – <leader>cc runs the lens on the current line
  if client:supports_method("textDocument/codeLens") then
    if vim.lsp.codelens.enable then
      vim.lsp.codelens.enable(true, { bufnr = buf })
    else
      vim.lsp.codelens.refresh({ bufnr = buf })
      vim.api.nvim_create_autocmd({ "BufEnter", "InsertLeave", "BufWritePost" }, {
        group = vim.api.nvim_create_augroup("ide_codelens_" .. buf, { clear = true }),
        buffer = buf,
        callback = function() vim.lsp.codelens.refresh({ bufnr = buf }) end,
      })
    end
  end
  -- LSP folding if the server supports it (better than treesitter for #ifdef blocks in C)
  if client:supports_method("textDocument/foldingRange") then
    local win = vim.api.nvim_get_current_win()
    vim.wo[win][0].foldexpr = "v:lua.vim.lsp.foldexpr()"
  end
  -- Clangd: switch between header and source
  if client.name == "clangd" then
    map("<leader>ch", "<cmd>LspClangdSwitchSourceHeader<cr>", "Header ↔ source")
  end
end

return {
  -- Lua dev for the nvim config (vim.* API completion)
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        { path = "snacks.nvim", words = { "Snacks" } },
      },
    },
  },

  { "b0o/SchemaStore.nvim", lazy = true },

  {
    "mason-org/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonUpdate" },
    lazy = false,
    opts = {
      ui = {
        border = "rounded",
        icons = { package_installed = "✓", package_pending = "➜", package_uninstalled = "✗" },
      },
    },
  },

  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "mason-org/mason.nvim" },
    lazy = false,
    opts = { ensure_installed = ensure_installed, run_on_start = true, start_delay = 1000 },
  },

  {
    "neovim/nvim-lspconfig",
    lazy = false,
    dependencies = {
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
      "saghen/blink.cmp",
    },
    config = function()
      -- Diagnostics
      vim.diagnostic.config({
        severity_sort = true,
        underline = true,
        update_in_insert = false,
        virtual_text = { spacing = 2, source = "if_many", prefix = "●" },
        float = { border = "rounded", source = true },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "\u{f057} ",
            [vim.diagnostic.severity.WARN] = "\u{f071} ",
            [vim.diagnostic.severity.INFO] = "\u{f05a} ",
            [vim.diagnostic.severity.HINT] = "󰌵 ",
          },
        },
      })

      -- Shared by all servers: capabilities from blink.cmp
      vim.lsp.config("*", {
        capabilities = require("blink.cmp").get_lsp_capabilities(),
      })
      for name, cfg in pairs(servers) do
        vim.lsp.config(name, cfg)
      end

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("ide_lsp_attach", { clear = true }),
        callback = function(ev)
          local client = vim.lsp.get_client_by_id(ev.data.client_id)
          if client then
            on_attach(client, ev.buf)
          end
        end,
      })

      -- mason-lspconfig calls vim.lsp.enable() only for servers of the selected languages.
      -- rust_analyzer is handled by rustaceanvim (plugins/lang.lua), the system one from rustup.
      require("mason-lspconfig").setup({
        automatic_enable = lsp_servers,
      })
    end,
  },
}
