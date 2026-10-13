local langs = require("config.langs")

local formatters_by_ft = { ["_"] = { "trim_whitespace" } }
local formatters_by_lang = {
  core = {
    lua = { "stylua" },
    json = { "prettierd" },
    jsonc = { "prettierd" },
    yaml = { "prettierd" },
    markdown = { "prettierd" },
    toml = { "taplo" },
  },
  c = { c = { "clang_format" }, cpp = { "clang_format" }, cuda = { "clang_format" } },
  rust = { rust = { "rustfmt" } },
  go = { go = { "goimports", "gofmt", stop_after_first = true } },
  python = { python = { "ruff_fix", "ruff_format" } },
  bash = { sh = { "shfmt" }, bash = { "shfmt" } },
  systemverilog = { systemverilog = { "verible" }, verilog = { "verible" } },
  web = {
    html = { "prettierd" },
    css = { "prettierd" },
    javascript = { "prettierd" },
    typescript = { "prettierd" },
  },
}
for lang, fts in pairs(formatters_by_lang) do
  if lang == "core" or langs.has(lang) then
    formatters_by_ft = vim.tbl_extend("force", formatters_by_ft, fts)
  end
end

return {
  -- Formatting (on save, <leader>cf manually, <leader>uf toggles)
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    cmd = "ConformInfo",
    keys = {
      {
        "<leader>cf",
        function() require("conform").format({ async = true }) end,
        mode = { "n", "x" },
        desc = "Format",
      },
    },
    opts = {
      formatters_by_ft = formatters_by_ft,
      default_format_opts = { lsp_format = "fallback" },
      format_on_save = function(buf)
        if not vim.g.autoformat or vim.b[buf].autoformat == false then
          return nil
        end
        return { timeout_ms = 1500 }
      end,
      formatters = {
        -- Verible: 2 spaces, max 100 columns (a .verible-format file overrides this)
        verible = { prepend_args = { "--indentation_spaces=2", "--column_limit=100" } },
        shfmt = { prepend_args = { "-i", "2", "-ci" } },
      },
    },
    init = function() vim.o.formatexpr = "v:lua.require'conform'.formatexpr()" end,
  },

  -- Linters outside of LSP
  {
    "mfussenegger/nvim-lint",
    enabled = langs.has("systemverilog"),
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lint = require("lint")
      lint.linters_by_ft = {
        -- Verilator lint next to the verible LS (catches other things: signal widths, latches, ...)
        systemverilog = { "verilator" },
        verilog = { "verilator" },
        dockerfile = {},
      }
      -- Verilator lints a single file → add -y for every directory with .sv/.v files in the project,
      -- so it finds modules instantiated from other files (rtl/alu, rtl/control-unit, ...).
      local base_args = { "-sv", "-Wall", "-Wno-DECLFILENAME", "--bbox-sys", "--bbox-unsup", "--lint-only" }
      local function verilator_args(buf)
        local file = vim.api.nvim_buf_get_name(buf)
        local root = vim.fs.root(buf, { ".git", "Makefile" }) or vim.fs.dirname(file)
        local args, seen = vim.list_extend({}, base_args), {}
        local hdl = vim.fs.find(
          function(name) return name:match("%.s?v$") or name:match("%.svh?$") end,
          { path = root, type = "file", limit = 500 }
        )
        for _, f in ipairs(hdl) do
          local dir = vim.fs.dirname(f)
          if not seen[dir] and not dir:match("/%.git") then
            seen[dir] = true
            vim.list_extend(args, { "-y", dir })
          end
        end
        return args
      end

      vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "InsertLeave" }, {
        group = vim.api.nvim_create_augroup("ide_lint", { clear = true }),
        callback = function(ev)
          local ft = vim.bo[ev.buf].filetype
          if ft == "systemverilog" or ft == "verilog" then
            lint.linters.verilator.args = verilator_args(ev.buf)
          end
          lint.try_lint()
        end,
      })
    end,
    keys = {
      { "<leader>cv", function() require("lint").try_lint() end, desc = "Run linter" },
    },
  },
}
