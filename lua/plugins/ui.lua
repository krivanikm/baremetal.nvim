return {
  -- Ikony (mini.icons + shim pre pluginy čo chcú nvim-web-devicons)
  {
    "echasnovski/mini.icons",
    lazy = true,
    opts = {},
    init = function()
      package.preload["nvim-web-devicons"] = function()
        require("mini.icons").mock_nvim_web_devicons()
        return package.loaded["nvim-web-devicons"]
      end
    end,
  },

  -- Snacks: dashboard, picker (fuzzy finder), notifikácie, terminál, lazygit, indent čiary, ...
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      bigfile = { enabled = true },
      quickfile = { enabled = true },
      input = { enabled = true },
      indent = { enabled = true, animate = { enabled = false } },
      scope = { enabled = true },
      words = { enabled = true }, -- highlight ostatných výskytov symbolu pod kurzorom
      statuscolumn = { enabled = true },
      notifier = { enabled = true, timeout = 3000, style = "compact" },
      terminal = { win = { style = "terminal" } },
      lazygit = { enabled = true },
      zen = { enabled = true },
      picker = {
        enabled = true,
        ui_select = true, -- vim.ui.select cez picker
        layout = { preset = "telescope" },
        matcher = { frecency = true },
        sources = {
          files = { hidden = true },
          grep = { hidden = true },
        },
      },
      dashboard = {
        enabled = true,
        preset = {
          header = [[
██████╗  █████╗ ██████╗ ███████╗███╗   ███╗███████╗████████╗ █████╗ ██╗     
██╔══██╗██╔══██╗██╔══██╗██╔════╝████╗ ████║██╔════╝╚══██╔══╝██╔══██╗██║     
██████╔╝███████║██████╔╝█████╗  ██╔████╔██║█████╗     ██║   ███████║██║     
██╔══██╗██╔══██║██╔══██╗██╔══╝  ██║╚██╔╝██║██╔══╝     ██║   ██╔══██║██║     
██████╔╝██║  ██║██║  ██║███████╗██║ ╚═╝ ██║███████╗   ██║   ██║  ██║███████╗
╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚═╝     ╚═╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝]],
          keys = {
            { icon = "\u{f002} ", key = "f", desc = "Find file", action = ":lua Snacks.picker.files()" },
            { icon = "\u{f15b} ", key = "n", desc = "New file", action = ":ene | startinsert" },
            { icon = "\u{f0e5} ", key = "g", desc = "Grep", action = ":lua Snacks.picker.grep()" },
            { icon = "\u{f1da} ", key = "r", desc = "Recent", action = ":lua Snacks.picker.recent()" },
            { icon = "\u{f07c} ", key = "p", desc = "Projects", action = ":lua Snacks.picker.projects()" },
            { icon = "\u{f0c7} ", key = "s", desc = "Restore session", section = "session" },
            { icon = "\u{f19d} ", key = "T", desc = "Tutor", action = ":Tutor baremetal" },
            { icon = "\u{f013} ", key = "c", desc = "Config", action = ":lua Snacks.picker.files({ cwd = vim.fn.stdpath('config') })" },
            { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
            { icon = "\u{f0ad} ", key = "m", desc = "Mason", action = ":Mason" },
            { icon = "\u{f426} ", key = "q", desc = "Quit", action = ":qa" },
          },
        },
        sections = {
          { section = "header" },
          { section = "keys", gap = 1, padding = 1 },
          { icon = "\u{f15c} ", title = "Recent files", section = "recent_files", cwd = true, limit = 6, indent = 2, padding = 1 },
          { section = "startup" },
        },
      },
    },
    keys = {
      -- Find
      { "<leader><space>", function() Snacks.picker.smart() end, desc = "Smart find" },
      { "<leader>ff", function() Snacks.picker.files() end, desc = "Files" },
      { "<leader>fg", function() Snacks.picker.git_files() end, desc = "Git files" },
      { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent" },
      { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
      { "<leader>fp", function() Snacks.picker.projects() end, desc = "Projects" },
      { "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Config files" },
      { "<leader>,", function() Snacks.picker.buffers() end, desc = "Buffers" },
      -- Search
      { "<leader>/", function() Snacks.picker.grep() end, desc = "Grep" },
      { "<leader>sg", function() Snacks.picker.grep() end, desc = "Grep" },
      { "<leader>sw", function() Snacks.picker.grep_word() end, desc = "Grep word/selection", mode = { "n", "x" } },
      { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer lines" },
      { "<leader>sh", function() Snacks.picker.help() end, desc = "Help" },
      { "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
      { "<leader>sc", function() Snacks.picker.command_history() end, desc = "Command history" },
      { "<leader>sC", function() Snacks.picker.commands() end, desc = "Commands" },
      { "<leader>sd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
      { "<leader>sD", function() Snacks.picker.diagnostics_buffer() end, desc = "Buffer diagnostics" },
      { "<leader>sm", function() Snacks.picker.marks() end, desc = "Marks" },
      { "<leader>sj", function() Snacks.picker.jumps() end, desc = "Jumplist" },
      { "<leader>sq", function() Snacks.picker.qflist() end, desc = "Quickfix" },
      { "<leader>sr", function() Snacks.picker.resume() end, desc = "Resume last picker" },
      { "<leader>su", function() Snacks.picker.undo() end, desc = "Undo history" },
      { "<leader>sM", function() Snacks.picker.man() end, desc = "Man pages" },
      { '<leader>s"', function() Snacks.picker.registers() end, desc = "Registers" },
      { "<leader>ss", function() Snacks.picker.lsp_symbols() end, desc = "LSP symbols" },
      { "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP workspace symbols" },
      { "<leader>st", function() Snacks.picker.todo_comments() end, desc = "TODO" },
      -- Git
      { "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" },
      { "<leader>gl", function() Snacks.picker.git_log() end, desc = "Git log" },
      { "<leader>gf", function() Snacks.picker.git_log_file() end, desc = "Git log (file)" },
      { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git status" },
      { "<leader>gb", function() Snacks.picker.git_branches() end, desc = "Git branches" },
      { "<leader>gB", function() Snacks.gitbrowse() end, desc = "Open in browser", mode = { "n", "v" } },
      -- UI / misc
      { "<leader>uC", function() Snacks.picker.colorschemes() end, desc = "Colorschemes" },
      { "<leader>n", function() Snacks.picker.notifications() end, desc = "Notifications" },
      { "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss notifications" },
      { "<leader>z", function() Snacks.zen() end, desc = "Zen mode" },
      { "<leader>bd", function() Snacks.bufdelete() end, desc = "Close buffer" },
      { "<leader>bo", function() Snacks.bufdelete.other() end, desc = "Close other buffers" },
      { "<leader>cR", function() Snacks.rename.rename_file() end, desc = "Rename file" },
      { "<c-/>", function() Snacks.terminal() end, desc = "Terminal", mode = { "n", "t" } },
      { "<c-_>", function() Snacks.terminal() end, desc = "which_key_ignore", mode = { "n", "t" } },
      { "]]", function() Snacks.words.jump(vim.v.count1) end, desc = "Next reference", mode = { "n", "t" } },
      { "[[", function() Snacks.words.jump(-vim.v.count1) end, desc = "Previous reference", mode = { "n", "t" } },
    },
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          -- Toggly pod <leader>u
          Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
          Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
          Snacks.toggle.option("relativenumber", { name = "Relative numbers" }):map("<leader>uL")
          Snacks.toggle.line_number():map("<leader>ul")
          Snacks.toggle.diagnostics():map("<leader>ud")
          Snacks.toggle.inlay_hints():map("<leader>uh")
          Snacks.toggle.treesitter():map("<leader>uT")
          Snacks.toggle.indent():map("<leader>ug")
          Snacks.toggle.dim():map("<leader>uD")
          Snacks.toggle({
            name = "Format on save",
            get = function() return vim.g.autoformat end,
            set = function(s) vim.g.autoformat = s end,
          }):map("<leader>uf")
        end,
      })
    end,
  },

  -- Statusline
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function()
      local function lsp_names()
        local names = {}
        for _, c in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
          names[#names + 1] = c.name
        end
        return #names > 0 and ("\u{f085} " .. table.concat(names, ", ")) or ""
      end
      return {
        options = {
          theme = "auto",
          globalstatus = true,
          component_separators = { left = "\u{e0b5}", right = "\u{e0b7}" },
          section_separators = { left = "\u{e0b4}", right = "\u{e0b6}" },
          disabled_filetypes = { statusline = { "snacks_dashboard" } },
        },
        sections = {
          lualine_a = { { "mode", separator = { left = "\u{e0b6}" }, right_padding = 2 } },
          lualine_b = { "branch", "diff" },
          lualine_c = {
            { "diagnostics", symbols = { error = "\u{f057} ", warn = "\u{f071} ", info = "\u{f05a} ", hint = "󰌵 " } },
            { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
            { "filename", path = 1, symbols = { modified = " ●", readonly = " \u{f023}" } },
          },
          lualine_x = {
            {
              function() return require("dap").status() end,
              icon = "\u{f188} ",
              cond = function() return package.loaded["dap"] and require("dap").status() ~= "" end,
            },
            { lsp_names },
            "encoding",
            "fileformat",
          },
          lualine_y = { "progress" },
          lualine_z = { { "location", separator = { right = "\u{e0b4}" }, left_padding = 2 } },
        },
        extensions = { "neo-tree", "lazy", "trouble", "quickfix", "nvim-dap-ui", "mason", "overseer" },
      }
    end,
  },

  -- Taby buffrov hore
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    keys = {
      { "<leader>bp", "<cmd>BufferLineTogglePin<cr>", desc = "Pin buffer" },
      { "<leader>bP", "<cmd>BufferLineGroupClose ungrouped<cr>", desc = "Close unpinned" },
      { "<leader>bl", "<cmd>BufferLineCloseLeft<cr>", desc = "Close to the left" },
      { "<leader>br", "<cmd>BufferLineCloseRight<cr>", desc = "Close to the right" },
      { "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "Previous buffer" },
      { "]b", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer" },
      { "[B", "<cmd>BufferLineMovePrev<cr>", desc = "Move buffer left" },
      { "]B", "<cmd>BufferLineMoveNext<cr>", desc = "Move buffer right" },
    },
    opts = {
      options = {
        close_command = function(n) Snacks.bufdelete(n) end,
        right_mouse_command = function(n) Snacks.bufdelete(n) end,
        diagnostics = "nvim_lsp",
        always_show_bufferline = false,
        separator_style = "thin",
        offsets = {
          { filetype = "neo-tree", text = "Explorer", highlight = "Directory", text_align = "left" },
        },
      },
    },
  },

  -- Which-key: popup so skratkami
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "modern",
      delay = 300,
      spec = {
        { "<leader>b", group = "buffer" },
        { "<leader>c", group = "code" },
        { "<leader>d", group = "debug" },
        { "<leader>f", group = "find" },
        { "<leader>g", group = "git" },
        { "<leader>gh", group = "hunks" },
        { "<leader>m", group = "cmake" },
        { "<leader>o", group = "tasks (overseer)" },
        { "<leader>q", group = "session/quit" },
        { "<leader>r", group = "run" },
        { "<leader>s", group = "search" },
        { "<leader>u", group = "ui toggles" },
        { "<leader>w", group = "windows" },
        { "<leader>x", group = "diagnostics/quickfix" },
        { "[", group = "prev" },
        { "]", group = "next" },
        { "g", group = "goto" },
      },
    },
    keys = {
      { "<leader>?", function() require("which-key").show({ global = false }) end, desc = "Buffer keymaps" },
    },
  },

  -- LSP progress v rohu
  { "j-hui/fidget.nvim", event = "LspAttach", opts = { notification = { window = { winblend = 0 } } } },

  -- Krajšie markdown v editore
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown" },
    opts = { completions = { blink = { enabled = true } } },
  },
}
