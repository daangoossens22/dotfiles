local M = {
    "numToStr/Comment.nvim",
    keys = {
        { "gc", mode = { "n", "v" } },
        { "gb", mode = { "n", "v" } },
    },
}

function M.config()
    require("Comment").setup {
        opleader = {
            line = "gc",
            block = "gb",
        },
        toggler = {
            line = "gcc",
            block = "gbc",
        },
        extra = {
            above = "gcO",
            below = "gco",
            eol = "gcA",
        },
        mappings = {
            -- Includes `gcc`, `gcb`, `gc[count]{motion}` and `gb[count]{motion}`
            basic = true,
            -- Includes `gco`, `gcO`, `gcA`
            extra = true,
        },
        pre_hook = nil, -- called before commenting is done
        post_hook = nil, -- called after commenting is done
        padding = true, -- add space before the comment
        -- NOTE: This only affects NORMAL mode mappings and doesn't work with dot-repeat
        sticky = true, -- cursor stays at position
        -- ignore = "^$", -- ignore empty lines
    }

    require("Comment.ft").set("query", ";%s")
    require("Comment.ft").set("vhdl", "--%s")
end

---Textobject for adjacent commented lines
-- REF: https://github.com/numToStr/Comment.nvim/issues/22
local function commented_lines_textobject()
    local U = require "Comment.utils"
    local cl = vim.api.nvim_win_get_cursor(0)[1] -- current line
    local range = { srow = cl, scol = 0, erow = cl, ecol = 0 }
    local ctx = {
        ctype = U.ctype.linewise,
        range = range,
    }
    local cstr = require("Comment.ft").calculate(ctx) or vim.bo.commentstring
    local ll, rr = U.unwrap_cstr(cstr)
    local padding = true
    local is_commented = U.is_commented(ll, rr, padding)

    local line = vim.api.nvim_buf_get_lines(0, cl - 1, cl, false)
    if next(line) == nil or not is_commented(line[1]) then return end

    local rs, re = cl, cl -- range start and end
    repeat
        rs = rs - 1
        line = vim.api.nvim_buf_get_lines(0, rs - 1, rs, false)
    until next(line) == nil or not is_commented(line[1])
    rs = rs + 1
    repeat
        re = re + 1
        line = vim.api.nvim_buf_get_lines(0, re - 1, re, false)
    until next(line) == nil or not is_commented(line[1])
    re = re - 1

    vim.fn.execute("normal! " .. rs .. "GV" .. re .. "G")
end

---Operator function to invert comments on each line
-- REF: https://github.com/numToStr/Comment.nvim/issues/17
function _G.__flip_flop_comment()
    local U = require "Comment.utils"
    local s = vim.api.nvim_buf_get_mark(0, "[")
    local e = vim.api.nvim_buf_get_mark(0, "]")
    local range = { srow = s[1], scol = s[2], erow = e[1], ecol = e[2] }
    local ctx = {
        ctype = U.ctype.linewise,
        range = range,
    }
    local cstr = require("Comment.ft").calculate(ctx) or vim.bo.commentstring
    local ll, rr = U.unwrap_cstr(cstr)
    local padding = true
    local is_commented = U.is_commented(ll, rr, padding)

    local rcom = {} -- ranges of commented lines
    local cl = s[1] -- current line
    local rs, re = nil, nil -- range start and end
    local lines = U.get_lines(range)
    for _, line in ipairs(lines) do
        if #line == 0 or not is_commented(line) then -- empty or uncommented line
            if rs ~= nil then
                table.insert(rcom, { rs, re })
                rs, re = nil, nil
            end
        else
            rs = rs or cl -- set range start if not set
            re = cl -- update range end
        end
        cl = cl + 1
    end
    if rs ~= nil then table.insert(rcom, { rs, re }) end

    local cursor_position = vim.api.nvim_win_get_cursor(0)
    local vmark_start = vim.api.nvim_buf_get_mark(0, "<")
    local vmark_end = vim.api.nvim_buf_get_mark(0, ">")

    ---Toggle comments on a range of lines
    ---@param sl integer: starting line
    ---@param el integer: ending line
    local toggle_lines = function(sl, el)
        vim.api.nvim_win_set_cursor(0, { sl, 0 }) -- idk why it's needed to prevent one-line ranges from being substituted with line under cursor
        vim.api.nvim_buf_set_mark(0, "[", sl, 0, {})
        vim.api.nvim_buf_set_mark(0, "]", el, 0, {})
        require("Comment.api").locked "toggle.linewise" ""
    end

    toggle_lines(s[1], e[1])
    for _, r in ipairs(rcom) do
        toggle_lines(r[1], r[2]) -- uncomment lines twice to remove previous comment
        toggle_lines(r[1], r[2])
    end

    vim.api.nvim_win_set_cursor(0, cursor_position)
    vim.api.nvim_buf_set_mark(0, "<", vmark_start[1], vmark_start[2], {})
    vim.api.nvim_buf_set_mark(0, ">", vmark_end[1], vmark_end[2], {})
    vim.o.operatorfunc = "v:lua.__flip_flop_comment" -- make it dot-repeatable
end

function M.init()
    vim.keymap.set(
        "o",
        "gc",
        commented_lines_textobject,
        { silent = true, desc = "Textobject for adjacent commented lines" }
    )
    vim.keymap.set(
        "o",
        "u",
        commented_lines_textobject,
        { silent = true, desc = "Textobject for adjacent commented lines" }
    )
    -- Invert (flip flop) comments with gC, in normal and visual mode
    vim.keymap.set(
        { "n", "x" },
        "gC",
        "<cmd>set operatorfunc=v:lua.__flip_flop_comment<cr>g@",
        { silent = true, desc = "Invert comments" }
    )
end

return M
