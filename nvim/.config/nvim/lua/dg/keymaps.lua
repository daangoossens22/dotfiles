MAP("c", "<C-h>", "<left>", "move cursor left in command line")
MAP("c", "<C-l>", "<right>", "move cursor left in command line")
MAP("v", "<", "<gv", "< but keep block selected")
MAP("v", ">", ">gv", "> but keep block selected")
MAP("v", "=", "=gv", "= but keep block selected")

MAP("n", "<leader>w", "<C-w>", "change window commands leader key")
-- MAP("n", "+", "<c-w>+", "increase the height of the pane")
-- MAP("n", "-", "<c-w>-", "decrease the height of the pane")
-- MAP("n", "<C-m>", "<c-w>>", "increase the width of the pane")
-- MAP("n", "<C-n>", "<c-w><", "decrease the width of the pane")

MAP("v", "J", ":m '>+1<cr>gv=gv", "move selected lines down")
MAP("v", "K", ":m '<-2<cr>gv=gv", "move selected lines up")

-- MAP("n", "<leader>Y", "ggyG<C-o>", "yank whole file")
-- MAP("n", "<leader>\\", "<cmd>nohlsearch<cr>", "disable search highlighting")
MAP("n", "<leader>\\", function()
    vim.cmd.nohlsearch()
    require("notify").dismiss()
end, "disable search highlighting")

MAP("", "<leader>d", '"_d', "delete operant doesn't overwrite any register")
MAP("", "<leader>p", '"0p', "paste yank contents when it when the default register is overwritten by delete")
MAP("v", "p", "P", "paste without yanking the contents of the visual selection")

MAP("n", "J", "mzJ`z", "J but don't change cursor position")
MAP("n", "gi", "gi<esc>zza", "gi but center the location")
MAP("n", "gv", "gvzz", "gv but center the location")
MAP("n", "n", "nzz", "n but center the location")
MAP("n", "N", "Nzz", "N but center the location")
MAP("n", "}", "}zz", "} but center the location")
MAP("n", "{", "{zz", "{ but center the location")

MAP("n", "<leader>tn", "<cmd>tabnew<cr>")
MAP("n", "<leader>tc", "<cmd>tabclose<cr>")

-- MAP("n", "]c", "]czz", "]c but center the location (diff mode)")
-- MAP("n", "[c", "[czz", "[c but center the location (diff mode)")
-- MAP("n", "<leader>dg", "<cmd>.diffg<cr>", "undo the current line (diff mode)")
-- MAP("v", "<leader>dg", "<cmd>diffg<cr>", "undo the whole hunk (diff mode)")

-- MAP("n", "<leader>x", "<cmd>execute getline('.')<cr>", "execute the line under the cursor as an Ex command")
MAP("c", "%%", "<C-R>=fnameescape(expand('%:h')).'/'<cr>", "expand foldername current file is in")

-- -- make tags (is this still needed with lsp)
-- vim.cmd [[command! MakeTags !ctags -R .]]
-- vim.cmd [[command! MakeTagsC !ctags -R --c++-kinds=+p --fields=+iaS --extra=+q --language-force=C++ --exclude=Makefile,.git]]

vim.g.qflistglobal = true
local ToggleQFType = function() vim.g.qflistglobal = not vim.g.qflistglobal end

local ToggleQFList = function()
    local qf_open = false
    for _, win in pairs(vim.fn.getwininfo()) do
        if win["quickfix"] == 1 then qf_open = true end
    end

    local exec_cmd = ""
    exec_cmd = exec_cmd .. (vim.g.qflistglobal and "c" or "l")
    exec_cmd = exec_cmd .. (qf_open and "close" or "open")

    if exec_cmd == "copen" and vim.tbl_isempty(vim.fn.getqflist()) then
        vim.notify("quickfix list is empty", vim.log.levels.ERROR, { title = "module: remaps" })
    elseif exec_cmd == "lopen" and vim.tbl_isempty(vim.fn.getloclist(0)) then
        vim.notify("location list is empty", vim.log.levels.ERROR, { title = "module: remaps" })
    else
        vim.cmd(exec_cmd)
    end
end

local MoveQFList = function(next_item)
    local exec_cmd = ""
    exec_cmd = exec_cmd .. (vim.g.qflistglobal and "c" or "l")
    exec_cmd = exec_cmd .. (next_item and "next" or "prev")

    local ok, result = pcall(vim.cmd, exec_cmd)
    if not ok then
        result = result:gsub(".*%):", "")
        vim.notify(result, vim.log.levels.ERROR, { title = "module: remaps" })
    end
end

-- location/quickfix list mappings (state shown in lualine)
MAP("n", "<leader>lt", ToggleQFType, "toggle between global and local QF list")
MAP("n", "<leader>ls", ToggleQFList, "show all contents of currently selected QF list")
MAP("n", "<C-l>", WRAP(MoveQFList, true), "move to next item in currently selected QF list")
MAP("n", "<C-h>", WRAP(MoveQFList, false), "move to prev item in currently selected QF list")

vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = "*.md",
    callback = function()
        if vim.b.autopdf then
            vim.cmd [[silent !pandoc -f markdown-implicit_figures -s %:p -o %:p:r.pdf --highlight-style=tango &]]
        end
    end,
    group = AUGROUP "markdown_autopdf",
})
MAP(
    "n",
    "<leader>tp",
    function() vim.b.autopdf = not vim.b.autopdf end,
    "autogenerates a pdf on write for the current buffer if it is a markdown file"
)
