vim.filetype.add {
    extension = {
        vert = "glsl",
        tesc = "glsl",
        tese = "glsl",
        geom = "glsl",
        frag = "glsl",
        comp = "glsl",
        mesh = "glsl",
        task = "glsl",
        rgen = "glsl",
        rint = "glsl",
        rahit = "glsl",
        rchit = "glsl",
        rmiss = "glsl",
        rcall = "glsl",

        -- rasi = 'css',
        rasi = "rasi",
    },
    filename = {
        [".clang-format"] = "yaml",
    },
    -- pattern = {}, -- NOTE: most of the time a modeline would suffice for this case
}
