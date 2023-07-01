---@param f function
---@param ... any
WRAP = function(f, ...)
    local plenary_tbl = require "plenary.tbl"
    local args = plenary_tbl.pack(...)
    return function() f(plenary_tbl.unpack(args)) end
end

---@param name string
AUGROUP = function(name) return vim.api.nvim_create_augroup("dg_" .. name, { clear = true }) end

---@param mode string|table
---@param lhs string
---@param rhs string|function
---@param opts string|table|nil
MAP = function(mode, lhs, rhs, opts)
    local keymap_opts = type(opts) == "string" and { desc = opts } or opts
    ---@diagnostic disable-next-line: param-type-mismatch
    vim.keymap.set(mode, lhs, rhs, keymap_opts)
end

---@param v any
P = function(v) print(vim.inspect(v)) end

DEB = function(v)
    require("noice").redirect(function() P(v) end)
end

REM_DUP = function(tab)
    local hash = {}
    local res = {}

    for _, x in ipairs(tab) do
        if not hash[x] then
            res[#res + 1] = x
            hash[x] = true
        end
    end

    return res
end

---@param module_name string
RELOAD = function(module_name) return require("plenary.reload").reload_module(module_name) end

---@param name string
R = function(name)
    RELOAD(name)
    return require(name)
end

AUTOFORMAT_LANGUAGES = { lua = true, rust = true }
