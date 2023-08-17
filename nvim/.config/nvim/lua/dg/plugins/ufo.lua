local M = {
    "kevinhwang91/nvim-ufo",
    dependencies = "kevinhwang91/promise-async",
    event = "BufRead",
}

function M.config()
    MAP("n", "zR", require("ufo").openAllFolds)
    MAP("n", "zM", require("ufo").closeAllFolds)
    MAP("n", "zr", require("ufo").openFoldsExceptKinds)
    MAP("n", "zm", require("ufo").closeFoldsWith) -- closeAllFolds == closeFoldsWith(0)
    MAP("n", "K", function() require("ufo").peekFoldedLinesUnderCursor() end)
    MAP("n", "zk", function()
        require("ufo").goPreviousStartFold()
        vim.cmd [[norm 0]] -- so its consistent with builtin zj keymap
    end)
    MAP("n", "<Space>tm", function()
        local filetype = vim.bo.filetype

        local function toggle_fold(query, names)
            local bufnr = vim.api.nvim_get_current_buf()
            local parser = vim.treesitter.get_parser(bufnr, filetype, {})
            local tree = parser:parse()[1]
            local root = tree:root()
            local cursor_start = vim.api.nvim_win_get_cursor(0)
            for id, node, metadata in query:iter_captures(root, bufnr, 0, -1) do
                local name = query.captures[id]
                local row1, col1, row2, col2 = node:range()
                if vim.tbl_contains(names, name) and row1 ~= row2 then -- test if it is a fold and a MAP() function call
                    vim.api.nvim_win_set_cursor(0, { row1 + 1, 0 })
                    vim.cmd(vim.b.foldopen_now and [[foldopen]] or [[foldclose]])
                end
            end
            vim.api.nvim_win_set_cursor(0, cursor_start)
            vim.b.foldopen_now = not vim.b.foldopen_now
        end

        if filetype == "lua" then
            local query = vim.treesitter.query.parse(
                filetype,
                [[(function_call name: (identifier) @func_name (#eq? @func_name "MAP")) @map_func]]
            )
            toggle_fold(query, { "map_func" })
        else
            local query = vim.treesitter.query.get(filetype, "textobjects")
            if query then toggle_fold(query, { "function.outer", "method.outer" }) end
        end
    end)

    local ft_map = {
        vim = "indent",
        python = "indent",
        git = "",
    }
    require("ufo").setup {
        -- open_fold_hl_timeout = 400,
        provider_selector = function(bufnr, filetype, buftype)
            -- NOTE: lsp -> treesitter -> indent to provide folds
            -- NOTE: need to enable aditional capabilities in the lsp config to get lsp folding to work
            -- local function handleFallbackException(bufnr, err, providerName)
            --     if type(err) == "string" and err:match "UfoFallbackException" then
            --         return require("ufo").getFolds(bufnr, providerName)
            --     else
            --         return require("promise").reject(err)
            --     end
            -- end
            --
            -- return (filetype == "" or buftype == "nofile") and "indent" -- only use indent until a file is opened
            --     or function(bufnr)
            --         return require("ufo")
            --             .getFolds(bufnr, "lsp")
            --             :catch(function(err) return handleFallbackException(bufnr, err, "treesitter") end)
            --             :catch(function(err) return handleFallbackException(bufnr, err, "indent") end)
            --     end
            return ft_map[filetype] or { "treesitter", "indent" }
        end,
        -- close_fold_kinds = {},
        -- NOTE: truncated folded line + number of lines folded + last line of fold
        enable_get_fold_virt_text = true,
        fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate, ctx)
            local function remove_leading_whitespace(virt_line)
                while #virt_line ~= 0 do
                    local removed = table.remove(virt_line, 1)
                    if removed[2] ~= "UfoFoldedFg" then
                        table.insert(virt_line, 1, removed)
                        break
                    end
                end
                return virt_line
            end
            local end_text = remove_leading_whitespace(ctx.get_fold_virt_text(endLnum))
            local virtText2 = remove_leading_whitespace(vim.deepcopy(virtText))
            if #virtText2 == 2 and virtText2[1][1] == "MAP" then
                for cur_lnum = lnum + 1, lnum + 2 do
                    for _, v in ipairs(remove_leading_whitespace(ctx.get_fold_virt_text(cur_lnum))) do
                        table.insert(virtText, v)
                    end
                end
                if endLnum - lnum > 4 then
                    for _, v in ipairs(remove_leading_whitespace(ctx.get_fold_virt_text(endLnum - 1))) do
                        table.insert(end_text, 1, v)
                    end
                end
            end
            local newVirtText = {}
            local suffix = (" 🡯 %d "):format(endLnum - lnum)
            local sufWidth = vim.fn.strdisplaywidth(suffix)
            local targetWidth = width - sufWidth
            local curWidth = 0
            for _, chunk in ipairs(virtText) do
                local chunkText = chunk[1]
                local chunkWidth = vim.fn.strdisplaywidth(chunkText)
                if targetWidth > curWidth + chunkWidth then
                    table.insert(newVirtText, chunk)
                else
                    chunkText = truncate(chunkText, targetWidth - curWidth)
                    local hlGroup = chunk[2]
                    table.insert(newVirtText, { chunkText, hlGroup })
                    chunkWidth = vim.fn.strdisplaywidth(chunkText)
                    -- str width returned from truncate() may less than 2nd argument, need padding
                    if curWidth + chunkWidth < targetWidth then
                        suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
                    end
                    break
                end
                curWidth = curWidth + chunkWidth
            end
            table.insert(newVirtText, { suffix, "MoreMsg" })
            -- for _, v in ipairs(end_text) do
            --     table.insert(newVirtText, v)
            -- end
            return newVirtText
        end,
        preview = {
            -- win_config = {
            --     border = "rounded",
            --     winblend = 12,
            --     winhighlight = "Normal:Normal",
            --     maxheight = 20,
            -- },
            mappings = {
                scrollB = "<C-b>",
                scrollF = "<C-f>",
                scrollU = "<C-u>",
                scrollD = "<C-d>",
                -- scrollE = "<C-E>",
                -- scrollY = "<C-Y>",
                -- close = "q",
                switch = "K",
                -- trace = "<CR>",
            },
        },
    }
end

return M
