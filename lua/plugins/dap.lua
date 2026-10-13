-- Debugger (DAP): codelldb (C/C++/Rust/ASM) and the native GDB DAP (gdb >= 14).
-- A project can also have .vscode/launch.json – nvim-dap loads it automatically.
local function pick_program()
  return coroutine.create(function(co)
    local cwd = vim.fn.getcwd()
    -- offer executables from build directories
    Snacks.picker.files({
      title = "Pick a binary to debug",
      cmd = "fd",
      args = { "--type", "x", "--no-ignore", "--hidden", "--exclude", ".git", "--exclude", "*.so" },
      cwd = cwd,
      confirm = function(picker, item)
        picker:close()
        coroutine.resume(co, item and (cwd .. "/" .. item.file) or require("dap").ABORT)
      end,
    })
  end)
end

local function input_program() return vim.fn.input("Binary: ", vim.fn.getcwd() .. "/", "file") end

local function args()
  local a = vim.fn.input("Arguments: ")
  return vim.split(a, " ", { trimempty = true })
end

return {
  {
    "mfussenegger/nvim-dap",
    enabled = require("config.langs").has("c", "asm", "rust"),
    dependencies = {
      { "rcarriga/nvim-dap-ui", dependencies = { "nvim-neotest/nvim-nio" } },
      { "theHamsta/nvim-dap-virtual-text", opts = { virt_text_pos = "eol" } },
    },
    keys = {
      { "<F5>", function() require("dap").continue() end, desc = "Debug: Continue/Start" },
      { "<F10>", function() require("dap").step_over() end, desc = "Debug: Step over" },
      { "<F11>", function() require("dap").step_into() end, desc = "Debug: Step into" },
      { "<F12>", function() require("dap").step_out() end, desc = "Debug: Step out" },
      { "<F9>", function() require("dap").toggle_breakpoint() end, desc = "Debug: Breakpoint" },
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Breakpoint" },
      {
        "<leader>dB",
        function() require("dap").set_breakpoint(vim.fn.input("Condition: ")) end,
        desc = "Conditional breakpoint",
      },
      {
        "<leader>dL",
        function() require("dap").set_breakpoint(nil, nil, vim.fn.input("Log: ")) end,
        desc = "Logpoint",
      },
      { "<leader>dc", function() require("dap").continue() end, desc = "Continue/Start" },
      { "<leader>dC", function() require("dap").run_to_cursor() end, desc = "Run to cursor" },
      { "<leader>di", function() require("dap").step_into() end, desc = "Step into" },
      { "<leader>do", function() require("dap").step_over() end, desc = "Step over" },
      { "<leader>dO", function() require("dap").step_out() end, desc = "Step out" },
      { "<leader>dj", function() require("dap").down() end, desc = "Frame down" },
      { "<leader>dk", function() require("dap").up() end, desc = "Frame up" },
      { "<leader>dl", function() require("dap").run_last() end, desc = "Run last" },
      { "<leader>dp", function() require("dap").pause() end, desc = "Pause" },
      { "<leader>dr", function() require("dap").repl.toggle() end, desc = "REPL" },
      { "<leader>dt", function() require("dap").terminate() end, desc = "Terminate" },
      { "<leader>du", function() require("dapui").toggle() end, desc = "Debug UI" },
      { "<leader>de", function() require("dapui").eval() end, desc = "Eval", mode = { "n", "x" } },
      {
        "<leader>dw",
        function() require("dapui").elements.watches.add(vim.fn.expand("<cword>")) end,
        desc = "Add watch",
      },
      { "<leader>dx", function() require("dap").clear_breakpoints() end, desc = "Clear breakpoints" },
      { "<leader>dd", function() require("dap").disassemble() end, desc = "Disassembly (if supported)" },
    },
    config = function()
      local dap, dapui = require("dap"), require("dapui")

      -- Icons
      vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })
      local signs = {
        DapBreakpoint = { "\u{f111}", "DiagnosticError" },
        DapBreakpointCondition = { "\u{f059}", "DiagnosticWarn" },
        DapLogPoint = { "\u{f075}", "DiagnosticInfo" },
        DapStopped = { "󰁕", "DiagnosticOk", "DapStoppedLine" },
        DapBreakpointRejected = { "\u{f06a}", "DiagnosticError" },
      }
      for name, s in pairs(signs) do
        vim.fn.sign_define(name, { text = s[1], texthl = s[2], linehl = s[3], numhl = s[3] })
      end

      -- Adapters
      dap.adapters.codelldb = { type = "executable", command = "codelldb" }
      dap.adapters.gdb = {
        type = "executable",
        command = "gdb",
        args = { "--interpreter=dap", "--eval-command", "set print pretty on" },
      }

      local c_cfg = {
        {
          name = "codelldb: pick binary",
          type = "codelldb",
          request = "launch",
          program = vim.fn.executable("fd") == 1 and pick_program or input_program,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
        },
        {
          name = "codelldb: binary + arguments",
          type = "codelldb",
          request = "launch",
          program = input_program,
          args = args,
          cwd = "${workspaceFolder}",
        },
        {
          name = "gdb: launch",
          type = "gdb",
          request = "launch",
          program = input_program,
          args = args,
          cwd = "${workspaceFolder}",
          stopAtBeginningOfMainSubprogram = false,
        },
        {
          name = "gdb: attach to process",
          type = "gdb",
          request = "attach",
          pid = function() return require("dap.utils").pick_process() end,
        },
        {
          -- e.g. openocd / qemu -s -S (embedded, custom OS)
          name = "gdb: remote target (localhost:3333)",
          type = "gdb",
          request = "attach",
          program = input_program,
          target = function() return vim.fn.input("Target: ", "localhost:3333") end,
          cwd = "${workspaceFolder}",
        },
      }
      dap.configurations.c = c_cfg
      dap.configurations.cpp = c_cfg
      dap.configurations.asm = c_cfg
      dap.configurations.nasm = c_cfg

      -- UI
      dapui.setup({
        floating = { border = "rounded" },
        layouts = {
          {
            elements = {
              { id = "scopes", size = 0.40 },
              { id = "watches", size = 0.20 },
              { id = "stacks", size = 0.25 },
              { id = "breakpoints", size = 0.15 },
            },
            position = "left",
            size = 45,
          },
          {
            elements = { { id = "repl", size = 0.5 }, { id = "console", size = 0.5 } },
            position = "bottom",
            size = 12,
          },
        },
      })
      dap.listeners.after.event_initialized.dapui = function() dapui.open() end
      dap.listeners.before.event_terminated.dapui = function() dapui.close() end
      dap.listeners.before.event_exited.dapui = function() dapui.close() end
    end,
  },
}
