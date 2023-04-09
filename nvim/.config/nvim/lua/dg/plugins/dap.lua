local M = {
    "mfussenegger/nvim-dap",
    dependencies = {
        "williamboman/mason.nvim", -- needs to be setup so that the daps are installed
        "mfussenegger/nvim-dap-python",
        "jbyuki/one-small-step-for-vimkind",
        "rcarriga/nvim-dap-ui",
        "theHamsta/nvim-dap-virtual-text",
        {
            "nvim-telescope/telescope-dap.nvim",
            dependencies = "nvim-telescope/telescope.nvim",
            config = function() require("telescope").load_extension "dap" end,
        },
    },
}

function M.init()
    -- TODO: add more keymaps (e.g. to stop debugging) see :h dap-api
    MAP("n", "<leader>bt", function() require("dap").toggle_breakpoint() end, "[DAP] toggle breakpoint")
    MAP(
        "n",
        "<leader>bc",
        function() require("dap").set_breakpoint(vim.fn.input "Breakpoint condition: ") end,
        "[DAP] conditional breakpoint"
    )
    MAP("n", "<F1>", function() require("dap").continue() end, "[DAP] continue")
    MAP("n", "<F2>", function() require("dap").step_into() end, "[DAP] step into")
    MAP("n", "<F3>", function() require("dap").step_over() end, "[DAP] step over")
    MAP("n", "<F4>", function() require("dap").step_out() end, "[DAP] step out")
    MAP("n", "<F9>", function() require("dap").run_to_cursor() end, "[DAP] continue till cursor")
    MAP("n", "<F12>", function() require("dap").terminate() end, "[DAP] terminate session")
    MAP("n", "<leader>rt", function() require("dap").repl.toggle() end, "[DAP] toggle repl pane")
    MAP("n", "<leader>rl", function() require("dap").run_last() end, "[DAP] run last")

    MAP("n", "<leader>dt", function() require("dap").toggle() end, "[DAP] toggle dapui panes")
    -- NOTE: experimental -> likely to change in later versions
    -- MAP("n", "<leader>dsc", function()
    --     local widgets = require "dap.ui.widgets"
    --     widgets.centered_float(widgets.scopes)
    -- end, "[DAP] show current scopes in a floating window")
    -- MAP("n", "<leader>df", function()
    --     local widgets = require "dap.ui.widgets"
    --     widgets.centered_float(widgets.frames)
    -- end, "[DAP] show current frames in a floating window")
    -- MAP(
    --     "n",
    --     "<leader>dho",
    --     require("dap.ui.widgets").hover,
    --     "[DAP] view the value of the expression under the cursor in a floating window"
    -- )
    MAP(
        "n",
        "<leader>dl",
        function() require("osv").launch { port = 8088 } end,
        "[DAP] launch the nlua dap server"
    )
end

function M.config()
    local dap, dapui = require "dap", require "dapui"

    -- repl autocomplete popup automatically without pressing CTRL-X CTRL-O all the time
    vim.api.nvim_create_autocmd("FileType", {
        pattern = "dap-repl",
        callback = function() require("dap.ext.autocompl").attach() end,
    })

    require("nvim-dap-virtual-text").setup {}
    -- -- configure a small subset of debug adapters in visual studio code (see `:help dap-launch.json`)
    -- require("dap.ext.vscode").load_launchjs()

    -- configure signs
    vim.fn.sign_define("DapBreakpoint", { text = "B", texthl = "DapSigns" })
    vim.fn.sign_define("DapBreakpointCondition", { text = "C", texthl = "DapSigns" })
    vim.fn.sign_define("DapLogPoint", { text = "L", texthl = "DapSigns" })
    vim.fn.sign_define("DapStopped", { text = "→", texthl = "DapSigns" })
    vim.fn.sign_define("DapBreakpointRejected", { text = "R", texthl = "DapSigns" })

    dapui.setup {}
    dap.listeners.after.event_initialized["dapui_config"] = dapui.open
    dap.listeners.before.event_terminated["dapui_config"] = dapui.close
    dap.listeners.before.event_exited["dapui_config"] = dapui.close

    -- python setup (debugpy)
    require("dap-python").setup("/usr/bin/python", nil)

    -- TODO: switch to codelldb (since it seems to be a bit better) and can be installed via mason
    dap.adapters.lldb = {
        type = "executable",
        command = "/usr/bin/lldb-vscode", -- adjust as needed, must be absolute path
        name = "lldb",
    }
    dap.configurations.cpp = {
        {
            name = "Launch",
            type = "lldb",
            request = "launch",
            program = function() return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file") end,
            cwd = "${workspaceFolder}",
            stopOnEntry = false,
            args = {},

            -- if you change `runInTerminal` to true, you might need to change the yama/ptrace_scope setting:
            --    echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
            -- Otherwise you might get the following error:
            --    Error on launch: Failed to attach to the target process
            -- But you should be aware of the implications:
            -- https://www.kernel.org/doc/html/latest/admin-guide/LSM/Yama.html
            -- runInTerminal = true,
        },
    }
    dap.configurations.c = dap.configurations.cpp

    -- neovim lua setup (osv)
    dap.configurations.lua = {
        {
            type = "nlua",
            request = "attach",
            name = "Attach to running Neovim instance",
        },
    }
    dap.adapters.nlua = function(callback, _) callback { type = "server", host = "127.0.0.1", port = 8088 } end
end

return M
