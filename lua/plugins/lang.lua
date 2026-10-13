-- Language-specific plugins: Rust, C/C++ (clangd extras, CMake), tasks
local langs = require("config.langs")

return {
  -- ── Rust ────────────────────────────────────────────────────────────
  -- rustaceanvim manages rust-analyzer (from rustup) + codelldb debugging + runnables
  {
    "mrcjkb/rustaceanvim",
    enabled = langs.has("rust"),
    lazy = false, -- the plugin lazy-loads itself on ft=rust
    init = function()
      vim.g.rustaceanvim = {
        server = {
          on_attach = function(_, buf)
            local function map(lhs, rhs, desc) vim.keymap.set("n", lhs, rhs, { buffer = buf, desc = desc }) end
            map("<leader>ca", function() vim.cmd.RustLsp("codeAction") end, "Code action (Rust)")
            map("K", function() vim.cmd.RustLsp({ "hover", "actions" }) end, "Hover actions")
            map("<leader>rR", function() vim.cmd.RustLsp("runnables") end, "Cargo runnables")
            map("<leader>rt", function() vim.cmd.RustLsp("testables") end, "Cargo tests")
            map("<leader>dR", function() vim.cmd.RustLsp("debuggables") end, "Rust debuggables")
            map("<leader>ce", function() vim.cmd.RustLsp("explainError") end, "Explain error")
            map("<leader>cE", function() vim.cmd.RustLsp("renderDiagnostic") end, "Render diagnostic")
            map("<leader>cM", function() vim.cmd.RustLsp("expandMacro") end, "Expand macro")
            map("<leader>cp", function() vim.cmd.RustLsp("parentModule") end, "Parent module")
            map("<leader>cJ", function() vim.cmd.RustLsp("joinLines") end, "Join lines")
            map("<leader>cC", function() vim.cmd.RustLsp("openCargo") end, "Open Cargo.toml")
          end,
          default_settings = {
            ["rust-analyzer"] = {
              cargo = { allFeatures = true, loadOutDirsFromCheck = true, buildScripts = { enable = true } },
              check = { command = "clippy" },
              procMacro = { enable = true },
              inlayHints = { lifetimeElisionHints = { enable = "skip_trivial" } },
            },
          },
        },
      }
    end,
  },

  -- Cargo.toml: crate versions, completion, updates
  {
    "saecki/crates.nvim",
    enabled = langs.has("rust"),
    event = { "BufRead Cargo.toml" },
    opts = {
      completion = { crates = { enabled = true } },
      lsp = { enabled = true, actions = true, completion = true, hover = true },
    },
  },

  -- ── C / C++ ─────────────────────────────────────────────────────────
  -- AST view, struct memory layout, type hierarchy
  {
    "p00f/clangd_extensions.nvim",
    enabled = langs.has("c"),
    ft = { "c", "cpp", "cuda", "objc", "objcpp" },
    opts = {},
    keys = {
      { "<leader>cA", "<cmd>ClangdAST<cr>", desc = "Clangd AST", ft = { "c", "cpp" } },
      { "<leader>cH", "<cmd>ClangdTypeHierarchy<cr>", desc = "Type hierarchy", ft = { "c", "cpp" } },
      { "<leader>cS", "<cmd>ClangdMemoryUsage<cr>", desc = "Clangd memory", ft = { "c", "cpp" } },
      { "<leader>cy", "<cmd>ClangdSymbolInfo<cr>", desc = "Symbol info", ft = { "c", "cpp" } },
    },
  },

  -- CMake projects: configure/build/run/debug targets (generates compile_commands.json for clangd)
  {
    "Civitasv/cmake-tools.nvim",
    enabled = langs.has("c"),
    ft = { "c", "cpp", "cmake" },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      cmake_build_directory = "build/${variant:buildType}",
      cmake_soft_link_compile_commands = true, -- symlink compile_commands.json into the project root
      cmake_regenerate_on_save = true,
      cmake_executor = { name = "overseer" },
      cmake_runner = { name = "terminal" },
      cmake_dap_configuration = { name = "cpp", type = "codelldb", request = "launch", stopOnEntry = false },
    },
    keys = {
      { "<leader>mg", "<cmd>CMakeGenerate<cr>", desc = "Generate (configure)" },
      { "<leader>mb", "<cmd>CMakeBuild<cr>", desc = "Build" },
      { "<leader>mr", "<cmd>CMakeRun<cr>", desc = "Run" },
      { "<leader>md", "<cmd>CMakeDebug<cr>", desc = "Debug" },
      { "<leader>mt", "<cmd>CMakeSelectBuildTarget<cr>", desc = "Select build target" },
      { "<leader>ml", "<cmd>CMakeSelectLaunchTarget<cr>", desc = "Select launch target" },
      { "<leader>mv", "<cmd>CMakeSelectBuildType<cr>", desc = "Build type (Debug/Release)" },
      { "<leader>mc", "<cmd>CMakeClean<cr>", desc = "Clean" },
      { "<leader>mT", "<cmd>CMakeRunTest<cr>", desc = "CTest" },
    },
  },

  -- ── Tasks (make, cargo, just, npm, custom shell commands) ──────────
  {
    "stevearc/overseer.nvim",
    cmd = { "OverseerRun", "OverseerToggle", "OverseerShell", "OverseerTaskAction" },
    opts = {},
    keys = {
      { "<leader>oo", "<cmd>OverseerRun<cr>", desc = "Run task" },
      { "<leader>ot", "<cmd>OverseerToggle<cr>", desc = "Task list" },
      { "<leader>os", "<cmd>OverseerShell<cr>", desc = "Shell command as task" },
      { "<leader>oa", "<cmd>OverseerTaskAction<cr>", desc = "Task action" },
    },
  },
}
