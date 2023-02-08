-- TODO: maybe make own statusline with builtin nvim?
local opt = vim.opt
local fn = vim.fn
local cmd = vim.cmd

local function highlight(group, fg, bg) cmd("highlight " .. group .. " guifg=" .. fg .. " guibg=" .. bg) end

highlight("StatusLeft", "red", "#32344a")
highlight("StatusMid", "green", "#32344a")
highlight("StatusRight", "blue", "#32344a")

local function get_column_number() return fn.col "." end

function Status_line()
    return table.concat {
        "%#StatusLeft#",
        "%t",
        vim.api.nvim_get_mode().mode,
        "%=",
        "%#StatusMid#",
        "%l,",
        get_column_number(),
        "%=",
        "%#StatusRight#",
        "%p%%",
    }
end

opt.statusline = "%!luaeval('Status_line()')"
