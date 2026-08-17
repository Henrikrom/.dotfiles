return {
    "sainnhe/gruvbox-material",
    version = false,
    lazy = false,
    config = function()
        vim.g.gruvbox_material_background = "hard" -- or "soft", or "medium"
        vim.g.gruvbox_material_better_performance = 1
        vim.g.gruvbox_material_enable_italic = true
        vim.opt.background = "dark" -- or "light" if you prefer light mode

        vim.cmd("colorscheme gruvbox-material")

        vim.api.nvim_set_hl(0, "LineNr", { fg = "#bdae93" })       -- muted beige
        vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#ebdbb2", bold = true })
    end,
}

