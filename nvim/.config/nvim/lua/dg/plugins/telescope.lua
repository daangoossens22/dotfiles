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
    MAP("n", "<leader>ff", function()
        local default_fd_command = { "fd", "--type", "f", "--color", "never", "--exclude", ".git" }
        local hidden = true
        local no_ignore = false
        local notification = nil
        local function refresh_find_files(prompt_bufnr)
            notification = vim.notify(
                ((hidden and "" or "no ") .. "hidden\n") .. ((no_ignore and "no " or "") .. "ignore"),
                "info",
                { replace = notification }
            )
            local finders = require "telescope.finders"
            local make_entry = require "telescope.make_entry"
            local action_state = require "telescope.actions.state"

            local opts = {}
            opts.entry_maker = make_entry.gen_from_file(opts)

            local cmd = vim.deepcopy(default_fd_command)
            if hidden then table.insert(cmd, "--hidden") end
            if no_ignore then table.insert(cmd, "--no-ignore") end
            local current_picker = action_state.get_current_picker(prompt_bufnr)

            current_picker:refresh(finders.new_oneshot_job(cmd, opts), { reset_prompt = false })
        end
        local function toggle_hidden(prompt_bufnr)
            hidden = not hidden
            refresh_find_files(prompt_bufnr)
        end
        local function toggle_no_ignore(prompt_bufnr)
            no_ignore = not no_ignore
            refresh_find_files(prompt_bufnr)
        end
        require("telescope.builtin").find_files {
            attach_mappings = function(_, map)
                map({ "i", "n" }, "<c-h>", toggle_hidden)
                map({ "i", "n" }, "<c-i>", toggle_no_ignore)
                return true
            end,
            find_command = vim.deepcopy(default_fd_command),
            no_ignore = no_ignore,
            hidden = hidden,
        }
    end, "[TEL] find files in current working directory")
    MAP("n", "<leader>fg", function()
        local workspaces = vim.lsp.buf.list_workspace_folders()
        table.insert(workspaces, require("telescope.utils").buffer_dir())
        table.insert(workspaces, vim.fn.getcwd())
        workspaces = REM_DUP(workspaces)

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
    MAP("n", "<leader>fo", function()
        require("telescope.builtin").buffers {
            attach_mappings = function(_, map)
                map({ "i", "n" }, "<a-d>", require("telescope.actions").delete_buffer)
                return true
            end,
        }
    end, "[TEL] find open buffers")
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
    MAP(
        "n",
        "<leader>fq",
        function() require("telescope.builtin").quickfixhistory() end,
        "[TEL] browse quickfix history"
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

    local dynamic_split_direction = function(win_width_boundary)
        return function(prompt_bufnr)
            local winnr_prev_win = vim.fn.winnr "#"
            local wininfo = vim.fn.getwininfo()
            local win_info = vim.tbl_filter(function(v) return v.winnr == winnr_prev_win end, wininfo)[1]
            local win_width = win_info.width
            -- local num_win_nonflaoting_curtab = #vim.tbl_filter(
            --     function(v)
            --         return v.tabnr == win_info.tabnr and vim.api.nvim_win_get_config(v.winid).relative == ""
            --     end,
            --     wininfo
            -- )
            if win_width > win_width_boundary then
                actions.select_vertical(prompt_bufnr)
            else
                actions.select_horizontal(prompt_bufnr)
            end
        end
    end

    require("telescope").setup {
        defaults = {
            mappings = {
                i = {
                    ["<C-c>"] = false, -- just <esc><esc> to close

                    -- change horizontal split shortcut
                    ["<C-x>"] = false,
                    ["<C-s>"] = actions.select_horizontal,
                    ["<C-Down>"] = function(...) return require("telescope.actions").cycle_history_next(...) end,
                    ["<C-Up>"] = function(...) return require("telescope.actions").cycle_history_prev(...) end,
                },
                -- n = {
                --     ["q"] = function(...) return require("telescope.actions").close(...) end,
                -- },
            },

            layout_strategy = "flex",
            layout_config = {
                flex = {
                    flip_columns = 200,
                },
            },
        },
        pickers = {
            help_tags = {
                mappings = {
                    i = {
                        ["<cr>"] = dynamic_split_direction(164),
                    },
                },
            },
            man_pages = {
                mappings = {
                    i = {
                        ["<cr>"] = dynamic_split_direction(180),
                    },
                },
            },
        },
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
                mappings = {
                    i = {
                        ["<bs>"] = false,
                    },
                },
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
