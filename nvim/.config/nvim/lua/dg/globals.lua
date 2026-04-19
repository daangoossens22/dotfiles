---@param name string
AUGROUP = function(name) return vim.api.nvim_create_augroup("dg_" .. name, { clear = true }) end

---@param v any
P = function(v) print(vim.inspect(v)) end

---@param table table
---@return table
REM_DUP = function(table)
    local hash = {}
    local res = {}

    for _, x in ipairs(table) do
        if not hash[x] then
            res[#res + 1] = x
            hash[x] = true
        end
    end

    return res
end

AUTOFORMAT_LANGUAGES = { lua = true, rust = true, systemverilog = true, verilog = true }
