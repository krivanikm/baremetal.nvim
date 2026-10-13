-- Treesitter (main branch = nový API pre nvim 0.11+).
-- Parsery sa kompilujú lokálne → potrebuje `tree-sitter` CLI (inštaluje Mason) a gcc.
local parsers = require("config.langs").pick({
  core = {
    "lua", "luadoc", "luap", "vim", "vimdoc", "query", "regex", "printf", "comment", "diff",
    "json", "yaml", "toml", "xml", "markdown", "markdown_inline", "ini", "csv", "dockerfile",
    "make", "zig", "gitcommit", "git_rebase", "gitignore", "git_config", "gitattributes",
  },
  c = { "c", "cpp", "cuda", "cmake", "meson", "ninja", "glsl", "llvm", "linkerscript", "devicetree", "kconfig" },
  asm = { "asm", "nasm", "disassembly", "objdump", "linkerscript" },
  rust = { "rust", "ron" },
  systemverilog = { "systemverilog", "tcl" },
  vhdl = { "vhdl", "tcl" },
  python = { "python" },
  go = { "go", "gomod", "gosum" },
  bash = { "bash" },
  web = { "javascript", "typescript", "html", "css" },
})

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      local ts = require("nvim-treesitter")
      ts.setup({})

      if vim.fn.executable("tree-sitter") == 1 then
        ts.install(parsers) -- async, už nainštalované preskočí
      else
        vim.schedule(function()
          vim.notify("tree-sitter CLI missing: run :MasonInstall tree-sitter-cli and restart", vim.log.levels.WARN)
        end)
      end

      -- Zapni highlight + indent pre každý buffer s dostupným parserom
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("ide_treesitter", { clear = true }),
        callback = function(ev)
          local lang = vim.treesitter.language.get_lang(ev.match)
          if not lang or not pcall(vim.treesitter.start, ev.buf, lang) then
            return
          end
          -- treesitter indent je pre niektoré jazyky horší ako vim-ový
          if not vim.tbl_contains({ "systemverilog", "verilog", "asm", "nasm", "make" }, ev.match) then
            vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },

  -- Textové objekty a pohyb po funkciách/triedach/argumentoch
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    event = "VeryLazy",
    config = function()
      require("nvim-treesitter-textobjects").setup({
        select = { lookahead = true },
        move = { set_jumps = true },
      })
      local sel = require("nvim-treesitter-textobjects.select")
      local mv = require("nvim-treesitter-textobjects.move")
      local swap = require("nvim-treesitter-textobjects.swap")

      -- vaf/vif = funkcia, vac/vic = trieda/struct, vaa/via = argument, vai/vii = podmienka, val/vil = cyklus
      local objs = {
        f = "function", c = "class", a = "parameter", i = "conditional", l = "loop", k = "comment",
      }
      for key, obj in pairs(objs) do
        vim.keymap.set({ "x", "o" }, "a" .. key, function() sel.select_textobject("@" .. obj .. ".outer", "textobjects") end, { desc = obj .. " (outer)" })
        vim.keymap.set({ "x", "o" }, "i" .. key, function() sel.select_textobject("@" .. obj .. ".inner", "textobjects") end, { desc = obj .. " (inner)" })
      end

      -- ]f [f = funkcia, ]c [c = trieda, ]a [a = argument (veľké písmeno = koniec)
      local moves = { f = "@function.outer", c = "@class.outer", a = "@parameter.inner" }
      for key, q in pairs(moves) do
        local m = { "n", "x", "o" }
        vim.keymap.set(m, "]" .. key, function() mv.goto_next_start(q, "textobjects") end, { desc = "Next " .. q })
        vim.keymap.set(m, "[" .. key, function() mv.goto_previous_start(q, "textobjects") end, { desc = "Previous " .. q })
        vim.keymap.set(m, "]" .. key:upper(), function() mv.goto_next_end(q, "textobjects") end, { desc = "End of next " .. q })
        vim.keymap.set(m, "[" .. key:upper(), function() mv.goto_previous_end(q, "textobjects") end, { desc = "End of previous " .. q })
      end

      -- Prehodenie argumentov
      vim.keymap.set("n", "<leader>cx", function() swap.swap_next("@parameter.inner") end, { desc = "Swap argument →" })
      vim.keymap.set("n", "<leader>cX", function() swap.swap_previous("@parameter.inner") end, { desc = "Swap argument ←" })
    end,
  },

  -- Sticky kontext hore (v ktorej funkcii/module som)
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "BufReadPost",
    opts = { max_lines = 3, multiline_threshold = 1 },
    keys = {
      { "[x", function() require("treesitter-context").go_to_context(vim.v.count1) end, desc = "Jump to context" },
      { "<leader>ut", "<cmd>TSContext toggle<cr>", desc = "Treesitter context" },
    },
  },
}
