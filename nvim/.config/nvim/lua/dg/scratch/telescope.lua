-- TODO: clean up
local function search_nvim_dotfiles()
    require("telescope.builtin").find_files {
        prompt_title = "Nvim Config",
        cwd = "~/.config/nvim",

        -- mappings to reload config files
        attach_mappings = function(prompt_bufnr, map)
            local function reload_file(name)
                local module_name = name:gsub("^%./", "", 1)
                if module_name == "init.lua" then
                    -- source vimrc
                    vim.cmd "luafile $MYVIMRC"
                elseif module_name:sub(1, 4) == "lua/" then
                    -- resource lua module (in the lua/ directory)
                    module_name = module_name:gsub("^lua/", "", 1)
                    module_name = module_name:gsub("%.lua$", "", 1)
                    module_name = module_name:gsub("/", ".")
                    R(module_name)
                end
                vim.cmd [[ nohlsearch ]]
            end

            local function reload_whole_config()
                local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
                local manager = picker.manager

                actions.close(prompt_bufnr) -- so it doesn't apply in the telescope buffer

                for entry in manager:iter() do
                    reload_file(entry.value)
                end
                return true
            end

            local function reload_cur_config()
                local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
                local manager = picker.manager

                actions.close(prompt_bufnr) -- so it doesn't apply in the telescope buffer

                -- resolve symlinks in the $MYVIMRC path (linux dependant code)
                local vimrc_loc = vim.fn.expand "$MYVIMRC"
                local vim_init_loc, init_lua = vimrc_loc:gsub("/init.lua$", "", 1)
                if init_lua == 0 then vim_init_loc = vim_init_loc:gsub("/init.vim$", "", 1) end
                local command = "cd " .. vim_init_loc .. " && pwd -P"
                local handle_test = io.popen(command)
                vim_init_loc = handle_test:read "*l"
                handle_test:close()
                if init_lua == 1 then
                    vim_init_loc = vim_init_loc .. "/init.lua"
                else
                    vim_init_loc = vim_init_loc .. "/init.vim"
                end

                local cur_buf_name = vim.api.nvim_buf_get_name(0)

                if cur_buf_name == vim_init_loc then
                    local name = "init.lua"
                    reload_file(name)
                    vim.notify("resourced $MYVIMRC", vim.log.levels.INFO, { title = "module: telescope" })
                else
                    for entry in manager:iter() do
                        local name = entry.value:gsub("^%./", "", 1)
                        if name ~= "init.lua" then
                            local suffix = cur_buf_name:sub(-name:len())
                            if name == suffix then
                                reload_file(name)
                                vim.notify(
                                    "reloaded: " .. name,
                                    vim.log.levels.INFO,
                                    { title = "module: telescope" }
                                )
                            end
                        end
                    end
                end

                return true
            end

            local function reload_selected_config()
                local entry = require("telescope.actions.state").get_selected_entry()

                actions.close(prompt_bufnr) -- so it doesn't apply in the telescope buffer

                reload_file(entry.value)
                return true
            end

            -- searching for my config does not care about capitalization so the shift remaps are fine
            map("i", "<S-r>", reload_cur_config)
            map("n", "<S-r>", reload_cur_config)
            map("i", "<C-r>", reload_whole_config)
            map("n", "<C-r>", reload_whole_config)
            map("i", "<M-r>", reload_selected_config)
            map("n", "<M-r>", reload_selected_config)

            return true
        end,
    }
end
