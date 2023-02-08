WRAP = function(f, ...)
    local plenary_tbl = require "plenary.tbl"
    local args = plenary_tbl.pack(...)
    return function() f(plenary_tbl.unpack(args)) end
end

---@param mode string|table
---@param lhs string
---@param rhs string|function
---@param opts string|table|nil
MAP = function(mode, lhs, rhs, opts)
    local keymap_opts = type(opts) == "string" and { desc = opts } or opts
    vim.keymap.set(mode, lhs, rhs, keymap_opts)
end

P = function(v) print(vim.inspect(v)) end

RELOAD = function(...) return require("plenary.reload").reload_module(...) end

R = function(name)
    RELOAD(name)
    return require(name)
end
