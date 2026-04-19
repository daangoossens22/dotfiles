local M = {
    "mfussenegger/nvim-dap",
    dependencies = {
        {
            "mfussenegger/nvim-dap-python",
            lazy = true,
            config = function() require("dap-python").setup("/usr/bin/python", nil) end,
        },
        -- "jbyuki/one-small-step-for-vimkind",
        -- {
        --     "rcarriga/nvim-dap-ui",
        --     dependencies = { "nvim-neotest/nvim-nio" },
        --     config = function()
        --         local dap, dapui = require "dap", require "dapui"
        --         dapui.setup {}
        --         dap.listeners.after.event_initialized["dapui_config"] = dapui.open
        --         dap.listeners.before.event_terminated["dapui_config"] = dapui.close
        --         dap.listeners.before.event_exited["dapui_config"] = dapui.close
        --         vim.keymap.set(
        --             "n",
        --             "<leader>dl",
        --             function() require("osv").launch { port = 8088 } end,
        --             { desc = "[DAP] launch the nlua dap server" }
        --         )
        --     end,
        -- },
        { "theHamsta/nvim-dap-virtual-text", lazy = true, opts = {} },
        -- TODO: try out "rcarriga/nvim-dap-ui"
    },
    ---@class DapOpts
    opts = {
        adapters = {
            -- TODO: switch to codelldb (since it seems to be a bit better)
            lldb = {
                type = "executable",
                command = "/usr/bin/lldb-vscode", -- adjust as needed, must be absolute path
                name = "lldb",
            },
            -- nlua = function(callback, _) callback { type = "server", host = "127.0.0.1", port = 8088 } end,
        },
        configurations = {
            c = {
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
                runInTerminal = false,
            },
            cpp = { link = "c" },
            rust = { link = "c" },
            -- lua = {
            --     type = "nlua",
            --     request = "attach",
            --     name = "Attach to running Neovim instance",
            -- },
        },
    },
    keys = {
        { "<leader>bt", function() require("dap").toggle_breakpoint() end, desc = "[DAP] toggle breakpoint" },
        {
            "<leader>bc",
            function() require("dap").set_breakpoint(vim.fn.input "Breakpoint condition: ") end,
            desc = "[DAP] conditional breakpoint",
        },
        { "<F1>", function() require("dap").continue() end, desc = "[DAP] continue" },
        { "<F2>", function() require("dap").step_into() end, desc = "[DAP] step into" },
        { "<F3>", function() require("dap").step_over() end, desc = "[DAP] step over" },
        { "<F4>", function() require("dap").step_out() end, desc = "[DAP] step out" },
        { "<F5>", function() require("dap").step_back() end, desc = "[DAP] step back" },
        { "<F9>", function() require("dap").run_to_cursor() end, desc = "[DAP] continue till cursor" },
        { "<F12>", function() require("dap").terminate() end, desc = "[DAP] terminate session" },
        { "<leader>rt", function() require("dap").repl.toggle() end, desc = "[DAP] toggle repl pane" },
        { "<leader>rl", function() require("dap").run_last() end, desc = "[DAP] run last" },
        {
            "<leader>?",
            function() require("dapui").eval(nil, { enter = true }) end,
            desc = "[DAP] show value under cursor in float window",
        },
        { "<leader>dt", function() require("dap").toggle() end, desc = "[DAP] toggle dapui panes" },
    },
}

---@param opts DapOpts
function M.config(_, opts)
    -- repl autocomplete popup automatically without pressing CTRL-X CTRL-O all the time
    vim.api.nvim_create_autocmd("FileType", {
        pattern = "dap-repl",
        callback = function() require("dap.ext.autocompl").attach() end,
        group = AUGROUP "dap_autocomplete",
    })

    -- -- configure a small subset of debug adapters in visual studio code (see `:help dap-launch.json`)
    -- require("dap.ext.vscode").load_launchjs()

    -- configure signs
    vim.fn.sign_define("DapBreakpoint", { text = "B", texthl = "DapSigns" })
    vim.fn.sign_define("DapBreakpointCondition", { text = "C", texthl = "DapSigns" })
    vim.fn.sign_define("DapLogPoint", { text = "L", texthl = "DapSigns" })
    vim.fn.sign_define("DapStopped", { text = "→", texthl = "DapSigns" })
    vim.fn.sign_define("DapBreakpointRejected", { text = "R", texthl = "DapSigns" })

    for name, conf in pairs(opts.adapters) do
        require("dap").adapters[name] = conf
    end
    for lang, conf in pairs(opts.configurations) do
        if conf.link ~= nil then
            require("dap").configurations[lang] = { opts.configurations[conf.link] }
        else
            require("dap").configurations[lang] = { conf }
        end
    end
end

return M
