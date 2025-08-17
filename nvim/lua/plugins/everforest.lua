return {
    "neanias/everforest-nvim",
    version = false,
    lazy = false,
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
        -- -- vim.cmd("colorscheme everforest")
        -- vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
        -- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
        -- vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
        -- vim.api.nvim_set_hl(0, "Visual", { bg = "#5c6370" })
        -- require("everforest").setup({
        --     background = "hard",
        -- })
    end,
  }
