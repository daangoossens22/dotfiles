local M = {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
}

M.opts = {
    -- bigfile = { enabled = true },
    indent = {
        -- enabled = true,
        animate = { enabled = false },
        scope = { enabled = false },
        chunk = { enabled = false },
    },
    input = { enabled = true },
    notifier = { enabled = true },
    -- quickfile = { enabled = true },
    -- scroll = { enabled = true },
    -- statuscolumn = { enabled = true },
    -- words = { enabled = true },
    terminal = { enabled = true },
    picker = {
        enabled = true,
        -- layout = { preset = "ivy" },
    },
}

M.init = function()
    MAP("n", "<leader><leader>t", function() require("snacks").terminal() end)

    MAP("n", "<leader>fp", function() require("snacks").picker() end, "[PIC] find pickers")
    MAP("n", "<leader>,", function() require("snacks").picker.buffers() end, "[PIC] Buffers")
    -- MAP("n", "<leader>/", function() require("snacks").picker.grep() end, "[PIC] Grep")
    MAP("n", "<leader>/", function()
        local workspaces = vim.lsp.buf.list_workspace_folders()
        table.insert(workspaces, vim.fn.expand "%:p:h") -- directory the current focused buffer is in
        table.insert(workspaces, vim.fn.getcwd())
        workspaces = REM_DUP(workspaces)

        if #workspaces == 1 then
            require("snacks").picker.grep { dirs = { workspaces[1] } }
        else
            vim.ui.select(
                workspaces,
                { prompt = "select workspace to search in" },
                function(choice) require("snacks").picker.grep { dirs = { choice } } end
            )
        end
    end, "[PIC] Grep")
    MAP("n", "<leader>:", function() require("snacks").picker.command_history() end, "[PIC] Command History")
    -- MAP("n", "<leader><space>", function() require("snacks").picker.files() end, "[PIC] Find Files")
    -- find
    MAP("n", "<leader>fb", function() require("snacks").picker.buffers() end, "[PIC] Buffers")
    MAP(
        "n",
        "<leader>fc",
        -- function() require("snacks").picker.files { cwd = vim.fn.stdpath "config" } end,
        function()
            require("snacks").picker.files { cwd = vim.fn.stdpath "config" }
            vim.cmd "sleep 50m"
            vim.api.nvim_feedkeys("!scratch lua$ | scm$ ", "n", false)
        end,
        "[PIC] Find Config File"
    )
    MAP(
        "n",
        "<leader>fd",
        function()
            require("snacks").picker.files {
                hidden = true,
                exclude = { "nvim/.config/nvim/" },
                cwd = "~/Documents/dotfiles",
            }
        end,
        "[PIC] Find Dotfiles"
    )
    MAP("n", "<leader>ff", function() require("snacks").picker.files() end, "[PIC] Find Files")
    MAP("n", "<leader>fg", function() require("snacks").picker.git_files() end, "[PIC] Find Git Files")
    MAP("n", "<leader>fr", function() require("snacks").picker.recent() end, "[PIC] Recent")
    -- git
    MAP("n", "<leader>gc", function() require("snacks").picker.git_log() end, "[PIC] Git Log")
    MAP("n", "<leader>gs", function() require("snacks").picker.git_status() end, "[PIC] Git Status")
    -- Grep
    MAP("n", "<leader>sb", function() require("snacks").picker.lines() end, "[PIC] Buffer Lines")
    MAP("n", "<leader>sB", function() require("snacks").picker.grep_buffers() end, "[PIC] Grep Open Buffers")
    MAP("n", "<leader>sg", function() require("snacks").picker.grep() end, "[PIC] Grep")
    MAP(
        { "n", "x" },
        "<leader>sw",
        function() require("snacks").picker.grep_word() end,
        "[PIC] Visual selection or word"
    )
    -- search
    MAP("n", '<leader>s"', function() require("snacks").picker.registers() end, "[PIC] Registers")
    MAP("n", "<leader>sa", function() require("snacks").picker.autocmds() end, "[PIC] Autocmds")
    MAP("n", "<leader>sc", function() require("snacks").picker.command_history() end, "[PIC] Command History")
    MAP("n", "<leader>sC", function() require("snacks").picker.commands() end, "[PIC] Commands")
    MAP("n", "<leader>sd", function() require("snacks").picker.diagnostics() end, "[PIC] Diagnostics")
    MAP("n", "<leader>sh", function() require("snacks").picker.help() end, "[PIC] Help Pages")
    MAP("n", "<leader>sH", function() require("snacks").picker.highlights() end, "[PIC] Highlights")
    MAP("n", "<leader>sj", function() require("snacks").picker.jumps() end, "[PIC] Jumps")
    MAP(
        "n",
        "<leader>sk",
        function() require("snacks").picker.keymaps { preview = "none", layout = { preview = false } } end,
        "[PIC] Keymaps"
    )
    MAP("n", "<leader>sl", function() require("snacks").picker.loclist() end, "[PIC] Location List")
    MAP("n", "<leader>sM", function() require("snacks").picker.man() end, "[PIC] Man Pages")
    MAP("n", "<leader>sm", function() require("snacks").picker.marks() end, "[PIC] Marks")
    MAP("n", "<leader>sR", function() require("snacks").picker.resume() end, "[PIC] Resume")
    MAP("n", "<leader>sq", function() require("snacks").picker.qflist() end, "[PIC] Quickfix List")
    MAP("n", "<leader>uC", function() require("snacks").picker.colorschemes() end, "[PIC] Colorschemes")
    MAP("n", "<leader>qp", function() require("snacks").picker.projects() end, "[PIC] Projects")
    -- -- LSP
    -- MAP("n", "gd", function() require("snacks").picker.lsp_definitions() end, "[PIC] Goto Definition")
    -- MAP(
    --     "n",
    --     "gr",
    --     function() require("snacks").picker.lsp_references() end,
    --     { nowait = true, desc = "[PIC] References" }
    -- )
    -- MAP("n", "gI", function() require("snacks").picker.lsp_implementations() end, "[PIC] Goto Implementation")
    -- MAP(
    --     "n",
    --     "gy",
    --     function() require("snacks").picker.lsp_type_definitions() end,
    --     "[PIC] Goto T[y]pe Definition"
    -- )
    -- MAP("n", "<leader>ss", function() require("snacks").picker.lsp_symbols() end, "[PIC] LSP Symbols")
end

return M
