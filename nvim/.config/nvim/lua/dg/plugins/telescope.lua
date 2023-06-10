local M = {
    "nvim-telescope/telescope.nvim",
    cmd = { "Telescope" },
    dependencies = {
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        "nvim-telescope/telescope-ui-select.nvim",
        "nvim-telescope/telescope-file-browser.nvim",
    },
}

function M.init()
    -- other builtin/extension stuff
    MAP(
        "n",
        "<leader>ft",
        function() require("telescope.builtin").builtin { include_extensions = true } end,
        "[TEL] find telescope pickers"
    )
    MAP(
        "n",
        "<leader>fr",
        function() require("telescope.builtin").resume { initial_mode = "normal" } end,
        "[TEL] resume last picker"
    )
    MAP(
        "n",
        "<leader>ff",
        function() require("telescope.builtin").find_files { no_ignore = false, hidden = true } end,
        "[TEL] find files in current working directory"
    )
    MAP("n", "<leader>fg", function()
        local workspaces = vim.lsp.buf.list_workspace_folders() -- TODO: workspaces can also contain duplicates -> remove them
        local other_workspaces = { require("telescope.utils").buffer_dir(), vim.fn.getcwd() }
        for _, dir in ipairs(other_workspaces) do
            if not vim.tbl_contains(workspaces, dir) then table.insert(workspaces, dir) end
        end

        if #workspaces == 1 then
            require("telescope.builtin").live_grep { cwd = workspaces[1] }
        else
            vim.ui.select(
                workspaces,
                { prompt = "select workspace to search in" },
                function(choice) require("telescope.builtin").live_grep { cwd = choice } end
            )
        end
    end, "[TEL] ripgrep in current working directory")
    MAP(
        "n",
        "<leader>fc",
        function() require("telescope.builtin").commands() end,
        "[TEL] find Ex mode commands"
    )
    MAP(
        "n",
        "<leader>fa",
        function() require("telescope.builtin").autocommands { layout_strategy = "vertical" } end,
        "[TEL] find autocommands"
    )
    MAP(
        "n",
        "<leader>fb",
        function() require("telescope.builtin").current_buffer_fuzzy_find() end,
        "[TEL] find in current buffer"
    )
    -- TODO: add keybind <M-d> to :bd selected entries
    MAP("n", "<leader>fo", function() require("telescope.builtin").buffers() end, "[TEL] find open buffers")
    MAP("n", "<leader>fh", function()
        for _, plugin in ipairs(require("lazy").plugins()) do
            if plugin._.loaded == nil then vim.cmd([[Lazy load ]] .. plugin.name) end
        end
        require("telescope.builtin").help_tags()
    end, "[TEL] find help documentation")
    MAP(
        "n",
        "<leader>fm",
        function() require("telescope.builtin").man_pages { sections = { "ALL" } } end,
        "[TEL] find man pages"
    )
    MAP(
        "n",
        "<leader>fk",
        function() require("telescope.builtin").keymaps { show_plug = false } end,
        "[TEL] find keymaps"
    )

    -- builtin git stuff
    MAP(
        "n",
        "<leader>gb",
        function() require("telescope.builtin").git_branches { initial_mode = "normal" } end,
        "[TEL] list git branches"
    )
    MAP(
        "n",
        "<leader>gs",
        function() require("telescope.builtin").git_status { initial_mode = "normal" } end,
        "[TEL] list git status"
    )
    MAP(
        "n",
        "<leader>gh",
        function() require("telescope.builtin").git_stash { initial_mode = "normal" } end,
        "[TEL] list git stash"
    )
    MAP(
        "n",
        "<leader>gc",
        function() require("telescope.builtin").git_commits { initial_mode = "normal" } end,
        "[TEL] list commits directory"
    )
    MAP(
        "n",
        "<leader>gm",
        function() require("telescope.builtin").git_bcommits { initial_mode = "normal" } end,
        "[TEL] list commits buffer"
    )
    MAP(
        "n",
        "<leader>gf",
        function() require("telescope.builtin").git_files() end,
        "[TEL] list tracked git files"
    )

    -- extensions
    MAP("n", "<leader>fe", function()
        require("telescope").extensions.file_browser.file_browser {
            cwd = require("telescope.utils").buffer_dir(), -- function so this is evaluated when opening the file explorer
            previewer = true,
            -- initial_mode = "normal",
            hidden = true,
            depth = 1,
            respect_gitignore = false,
        }
    end, "[TEL] file explorer")
    MAP(
        "n",
        "<leader>fn",
        function() require("telescope").extensions.notify.notify() end,
        "[TEL] list notifications"
    )
    -- NMAP("<leader>fp", require("telescope").extensions.project.project, "[TEL] add and open a project")

    -- custom functions
    local dotfiles_opt = {
        hidden = true,
        -- follow = true,
        find_command = { "fd", "--type", "f", "--exclude", "nvim/.config/nvim", "--exclude", ".git/*" },
        prompt_title = "Dotfiles",
        cwd = "~/Documents/dotfiles",
    }
    MAP(
        "n",
        "<leader>fd",
        function() require("telescope.builtin").find_files(dotfiles_opt) end,
        "[TEL] find file in dotfiles folder"
    )

    local nvim_config_opt = {
        hidden = true,
        prompt_title = "Nvim Config",
        cwd = "~/.config/nvim",
    }
    MAP("n", "<leader>cv", function()
        require("telescope.builtin").find_files(nvim_config_opt)
        vim.api.nvim_feedkeys("!scratch 'lua ", "n", false)
    end, { desc = "[TEL] find nvim config file" })
end

function M.config()
    -- add syntax highlighting in telescope for glsl and rofi config (until they are added to the default filetypes)
    local ok_p, plenary_ft = pcall(require, "plenary.filetype")
    if ok_p then plenary_ft.add_file "missing_filetypes" end

    local actions = require "telescope.actions"

    require("telescope").setup {
        defaults = {
            mappings = {
                i = {
                    ["<C-c>"] = false, -- just <esc><esc> to close

                    -- change horizontal split shortcut
                    ["<C-x>"] = false,
                    ["<C-s>"] = actions.select_horizontal,
                },
            },

            layout_strategy = "flex",
            layout_config = {
                flex = {
                    flip_columns = 200,
                },
            },
        },
        pickers = {},
        extensions = {
            ["fzf"] = {
                fuzzy = true,
                override_generic_sorter = true,
                override_file_sorter = true,
                case_mode = "smart_case", -- options: "(ignore|respect|smart)_case"
            },
            ["ui-select"] = {
                require("telescope.themes").get_dropdown {},
            },
            ["file_browser"] = {
                hijack_netrw = true,
            },
        },
    }

    -- require("telescope").load_extension("fzy_native")
    require("telescope").load_extension "fzf"
    require("telescope").load_extension "ui-select"
    -- require"telescope".load_extension("frecency")
    require("telescope").load_extension "file_browser"
    require("telescope").load_extension "notify"
end

return M
