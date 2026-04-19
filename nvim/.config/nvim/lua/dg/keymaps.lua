-- readline insert mappings (https://en.wikipedia.org/wiki/GNU_Readline)
vim.keymap.set({ "c", "i" }, "<C-b>", "<left>", { desc = "move cursor left in the command line" })
vim.keymap.set({ "c", "i" }, "<C-f>", "<right>", { desc = "move cursor right in the command line" })
vim.keymap.set({ "c", "i" }, "<C-a>", "<Home>", { desc = "move cursor to the start in the command line" })
vim.keymap.set({ "c", "i" }, "<C-e>", "<End>", { desc = "move cursor to the start in the command line" })
vim.keymap.set({ "c", "i" }, "<C-d>", "<Del>", { desc = "delete succeeding character" })
vim.keymap.set({ "c", "i" }, "<M-b>", "<S-left>", { desc = "move cursor one word left in the command line" })
vim.keymap.set({ "c", "i" }, "<M-f>", "<S-right>", { desc = "move cursor one word left in the command line" })
vim.keymap.set("c", "<M-d>", " <S-right><C-w><BS>", { desc = "delete to end of word" })
vim.keymap.set("i", "<M-d>", "<C-\\><C-o>dw", { desc = "delete to end of word" })
vim.keymap.set("c", "<C-k>", "<C-\\>egetcmdline()[:getcmdpos()-2]<CR>", { desc = "cut text to the end of line" })
vim.keymap.set("i", "<C-k>", "<C-\\><C-o>D", { desc = "cut text to the end of line" })

-- keep things selected in visual mode
vim.keymap.set("x", "<", "<gv", { desc = "< but keep block selected" })
vim.keymap.set("x", ">", ">gv", { desc = "> but keep block selected" })
vim.keymap.set("x", "=", "=gv", { desc = "= but keep block selected" })
vim.keymap.set("x", "J", ":m '>+1<cr>gv=gv", { desc = "move selected lines down" })
vim.keymap.set("x", "K", ":m '<-2<cr>gv=gv", { desc = "move selected lines up" })

-- copy paste stuff
vim.keymap.set("n", "<leader>y", '"+y', { desc = "yank into the system clipboard" })
vim.keymap.set("n", "<leader>d", '"_d', { desc = "delete operant doesn't overwrite any register" })
vim.keymap.set(
    "n",
    "<leader>p",
    '"0p',
    { desc = "paste yank contents when the default register is overwritten by delete" }
)

-- center on certain actions
vim.keymap.set("n", "gi", "gi<esc>zza", { desc = "gi but center the location" })
vim.keymap.set("n", "gv", "gvzz", { desc = "gv but center the location" })
vim.keymap.set("n", "n", "nzz", { desc = "n but center the location" })
vim.keymap.set("n", "N", "Nzz", { desc = "N but center the location" })
vim.keymap.set("n", "}", "}zz", { desc = "} but center the location" })
vim.keymap.set("n", "{", "{zz", { desc = "{ but center the location" })

-- miscellaneous stuff
vim.keymap.set("n", "<leader>tn", "<cmd>tabnew<cr>", { desc = "open a new tab" })
vim.keymap.set("n", "<leader>tc", "<cmd>tabclose<cr>", { desc = "close the current tab" })
vim.keymap.set("n", "<leader>tq", function()
    for _, win in pairs(vim.fn.getwininfo()) do
        if win["quickfix"] == 1 then
            vim.cmd.cclose()
            return
        end
    end
    if vim.tbl_isempty(vim.fn.getqflist()) then
        vim.notify("quickfix list is empty", vim.log.levels.ERROR)
    else
        vim.cmd.copen()
    end
end, { desc = "toggle quickfixlist" })
vim.keymap.set("n", "<leader>ts", function() vim.o.spell = not vim.o.spell end, { desc = "toggle spellchecking" })
vim.keymap.set("n", "<leader>it", vim.cmd.InspectTree, { desc = "inspect the treesitter nodes of the current buffer" })
vim.keymap.set("n", "gK", vim.cmd.Man, { desc = "open the manpage of the word under the cursor" })
vim.keymap.set("x", ".", ":norm .<CR>")
vim.keymap.set("n", "<esc>", vim.cmd.nohlsearch, { desc = "disable search highlighting" })
vim.keymap.set("n", "J", "mzJ`z", { desc = "J but don't change cursor position" })
vim.keymap.set("c", "%%", "<C-R>=fnameescape(expand('%:h')).'/'<cr>", { desc = "expand foldername current file is in" })

-- execute lua code in the buffer
vim.keymap.set("n", "<leader>x", ":.lua<CR>", { desc = "execute current lua line" })
vim.keymap.set("x", "<leader>x", ":lua<CR>", { desc = "execute selected lua block" })
vim.keymap.set("n", "<leader><leader>x", "<cmd>source %<CR>", { desc = "source/execute focused buffer" })
