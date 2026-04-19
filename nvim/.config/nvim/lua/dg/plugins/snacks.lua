local M = {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
}

M.opts = {
    indent = {
        animate = { enabled = false },
        scope = { enabled = false },
        chunk = { enabled = false },
    },
    input = { enabled = true },
    notifier = { enabled = true },
    terminal = { enabled = true },
    picker = {
        enabled = true,
    },
}

M.keys = {
    { "<leader><leader>t", function() require("snacks").terminal() end },

    -- find
    { "<leader>fp", function() require("snacks").picker() end, desc = "[PIC] find pickers" },
    { "<leader>fP", function() require("snacks").picker.projects() end, desc = "[PIC] Projects" },
    {

        "<leader>fc",
        function()
            local picker = require("snacks").picker.files { cwd = vim.fn.stdpath "config" }
            while not picker:is_focused() do
                vim.cmd "sleep 10m"
            end
            vim.api.nvim_feedkeys("!scratch lua$ | scm$ ", "t", false)
        end,
        desc = "[PIC] Find Config File",
    },
    {

        "<leader>fd",
        function()
            require("snacks").picker.files {
                hidden = true,
                exclude = { "nvim/.config/nvim/" },
                cwd = "~/Documents/dotfiles",
            }
        end,
        desc = "[PIC] Find Dotfiles",
    },
    { "<leader>ff", function() require("snacks").picker.files() end, desc = "[PIC] Find Files" },
    {

        "<leader>fg",
        function() require("snacks").picker.git_files() end,
        desc = "[PIC] Find Git Files",
    },
    -- search
    {
        "<leader>sh",
        function()
            require("snacks").picker.help {
                win = {
                    input = {
                        keys = {
                            ["<CR>"] = { "edit_vsplit", mode = { "n", "i" } },
                        },
                    },
                },
            }
        end,
        desc = "[PIC] Help Pages",
    },
    {

        "<leader>sk",
        function() require("snacks").picker.keymaps { preview = "none", layout = { preview = false } } end,
        desc = "[PIC] Keymaps",
    },
    { "<leader>sm", function() require("snacks").picker.man() end, desc = "[PIC] Man Pages" },
    { "<leader>sr", function() require("snacks").picker.resume() end, desc = "[PIC] Resume" },
    {

        "<leader>:",
        function() require("snacks").picker.command_history() end,
        desc = "[PIC] Command History",
    },
    {
        "<leader>/",
        function()
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
        end,
        desc = "[PIC] Grep",
    },
}

return M
