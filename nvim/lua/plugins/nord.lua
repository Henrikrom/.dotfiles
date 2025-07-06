return {
    "shaunsingh/nord.nvim",
    name = "nord.nvim",
    config = function()
        vim.cmd("colorscheme nord")
        vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
        vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
        vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
        vim.g.nord_contrast = true
        vim.g.nord_cursorline_transparent = true
    end
}
