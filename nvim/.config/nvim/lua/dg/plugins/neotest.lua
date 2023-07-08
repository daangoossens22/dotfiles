local M = {
    "nvim-neotest/neotest",
    dependencies = {
        "nvim-neotest/neotest-python",
        "nvim-neotest/neotest-plenary",
        { "nvim-neotest/neotest-vim-test", dependencies = "vim-test/vim-test" },
        -- "andythigpen/nvim-coverage"
    },
}

function M.init()
    MAP("n", "<leader>tt", function() require("neotest").run.run() end, "[TEST] run the nearest test")
    MAP(
        "n",
        "<leader>tf",
        function() require("neotest").run.run(vim.fn.expand "%") end,
        "[TEST] run the tests in the current file"
    )
    -- MAP(
    --     "n",
    --     "<leader>td",
    --     WRAP(require("neotest").run.run, { strategy = "dap" }),
    --     "[TEST][DAP] debug the nearest test using dap"
    -- )
    MAP(
        "n",
        "<leader>tl",
        function() require("neotest").summary.toggle() end,
        "[TEST] toggle the test suite structure pane"
    )
    MAP("n", "<leader>ts", function() require("neotest").run.stop() end, "[TEST] stop the nearest test")
    MAP(
        "n",
        "<leader>ta",
        function() require("neotest").run.attach() end,
        "[TEST] show output of the nearest test in a seperate pane"
    )
end

function M.config()
    require("neotest").setup {
        adapters = {
            require "neotest-python",
            require "neotest-plenary",
            require "neotest-vim-test" { ignore_filetypes = { "python", "vim", "lua" } },
        },
    }
end

return M
