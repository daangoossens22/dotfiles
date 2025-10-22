vim.g.NERDDefaultAlign = "left"
-- add space after comment
vim.g.NERDSpaceDelims = 1
-- for some reason the default python comments have '# ' as the comment string
-- combining that with the previous option results in '#  ' (2 spaces instead of 1)
vim.g.NERDCustomDelimiters = {
    python = {
        left = "#",
        right = "",
    },
}
-- remove unused remaps
vim.g.NERDCreateDefaultMappings = 0
MAP("", "<Leader>cc", "<Plug>NERDCommenterComment", "comment out current/selected line(s)")
MAP(
    "",
    "<Leader>ci",
    "<Plug>NERDCommenterInvert",
    "toggle the state of the current/selected line(s) individually"
)
