vim.filetype.add {
    extension = {
        mesh = "glsl",
        task = "glsl",
        nml = "xml",

        -- rasi = 'css',
    },
    filename = {
        [".clang-format"] = "yaml",
    },
    -- pattern = {}, -- NOTE: most of the time a modeline would suffice for this case
}
