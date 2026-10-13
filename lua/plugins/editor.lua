return {
  -- File explorer (tree)
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    cmd = "Neotree",
    dependencies = { "nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim", "echasnovski/mini.icons" },
    keys = {
      { "<leader>e", "<cmd>Neotree toggle reveal<cr>", desc = "Explorer" },
      { "<leader>E", "<cmd>Neotree toggle float reveal<cr>", desc = "Explorer (float)" },
      { "<leader>ge", "<cmd>Neotree float git_status<cr>", desc = "Git explorer" },
    },
    opts = {
      close_if_last_window = true,
      popup_border_style = "rounded",
      sources = { "filesystem", "buffers", "git_status" },
      filesystem = {
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
        filtered_items = { hide_dotfiles = false, hide_gitignored = false, hide_by_name = { ".git" } },
      },
      window = {
        width = 32,
        mappings = {
          ["l"] = "open",
          ["h"] = "close_node",
          ["<space>"] = "none",
          ["Y"] = {
            function(state) vim.fn.setreg("+", state.tree:get_node():get_id()) end,
            desc = "Copy path",
          },
        },
      },
      default_component_configs = {
        indent = { with_expanders = true },
        git_status = {
          symbols = { unstaged = "󰄱", staged = "󰱒" },
        },
      },
    },
  },

  -- Oil: edit a directory as a buffer (rename/delete files as text)
  {
    "stevearc/oil.nvim",
    cmd = "Oil",
    keys = { { "-", "<cmd>Oil<cr>", desc = "Oil (parent directory)" } },
    opts = { view_options = { show_hidden = true }, float = { padding = 4 } },
  },

  -- Flash: jump around the screen (s + 2 characters)
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = { modes = { char = { jump_labels = true } } },
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter search" },
    },
  },

  -- Auto-pair brackets
  { "echasnovski/mini.pairs", event = "InsertEnter", opts = { modes = { insert = true, command = false } } },

  -- Surround: gsa (add), gsd (delete), gsr (replace)
  {
    "echasnovski/mini.surround",
    event = "VeryLazy",
    opts = {
      mappings = {
        add = "gsa",
        delete = "gsd",
        find = "gsf",
        find_left = "gsF",
        highlight = "gsh",
        replace = "gsr",
        update_n_lines = "gsn",
      },
    },
  },

  -- Detect indentation from file contents
  { "NMAC427/guess-indent.nvim", event = "BufReadPre", opts = {} },

  -- TODO/FIXME/HACK/NOTE highlighting
  {
    "folke/todo-comments.nvim",
    event = "BufReadPost",
    opts = {},
    keys = {
      { "]t", function() require("todo-comments").jump_next() end, desc = "Next TODO" },
      { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous TODO" },
      { "<leader>xt", "<cmd>Trouble todo toggle<cr>", desc = "TODO (Trouble)" },
    },
  },

  -- Trouble: a nice list of diagnostics, references, symbols
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    opts = { focus = true },
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (project)" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Diagnostics (buffer)" },
      { "<leader>cs", "<cmd>Trouble symbols toggle focus=false win.position=right<cr>", desc = "Symbols (Trouble)" },
      { "<leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "LSP def/ref (Trouble)" },
      { "<leader>xq", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix (Trouble)" },
      { "<leader>xl", "<cmd>Trouble loclist toggle<cr>", desc = "Location list (Trouble)" },
    },
  },

  -- Outline / file structure (functions, structs, modules)
  {
    "stevearc/aerial.nvim",
    event = "LspAttach",
    opts = {
      backends = { "lsp", "treesitter", "markdown", "man" },
      layout = { default_direction = "right", min_width = 30 },
      show_guides = true,
      filter_kind = false,
    },
    keys = {
      { "<leader>co", "<cmd>AerialToggle<cr>", desc = "Outline" },
      { "<leader>sa", "<cmd>AerialNavToggle<cr>", desc = "Outline navigation" },
    },
  },

  -- Search & replace across the whole project
  {
    "MagicDuck/grug-far.nvim",
    cmd = "GrugFar",
    opts = { headerMaxWidth = 80 },
    keys = {
      {
        "<leader>sR",
        function()
          local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
          require("grug-far").open({
            transient = true,
            prefills = { filesFilter = ext and ext ~= "" and "*." .. ext or nil },
          })
        end,
        mode = { "n", "v" },
        desc = "Search & replace (project)",
      },
    },
  },

  -- Sessions: automatically saves open files per directory
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {},
    keys = {
      { "<leader>qs", function() require("persistence").load() end, desc = "Restore session" },
      { "<leader>qS", function() require("persistence").select() end, desc = "Select session" },
      { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Last session" },
      { "<leader>qd", function() require("persistence").stop() end, desc = "Stop saving session" },
    },
  },

  -- Undo tree
  {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
    keys = { { "<leader>U", "<cmd>UndotreeToggle<cr>", desc = "Undotree" } },
  },

  -- Harpoon: quick switching between the 4-5 main files of a project
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = { settings = { save_on_toggle = true } },
    keys = function()
      local keys = {
        { "<leader>H", function() require("harpoon"):list():add() end, desc = "Harpoon add file" },
        {
          "<leader>h",
          function()
            local h = require("harpoon")
            h.ui:toggle_quick_menu(h:list())
          end,
          desc = "Harpoon menu",
        },
      }
      for i = 1, 5 do
        keys[#keys + 1] = {
          "<leader>" .. i,
          function() require("harpoon"):list():select(i) end,
          desc = "which_key_ignore",
        }
      end
      return keys
    end,
  },
}
