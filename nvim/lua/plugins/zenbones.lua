return {
    "zenbones-theme/zenbones.nvim",
    dependencies = "rktjmp/lush.nvim",
    lazy = false,
    priority = 1000,
    config = function()
        vim.o.background = "dark"
        vim.g.zenbones = {
            darkness = "stark",        -- options: 'warm', 'stark', 'dim', 'bright', 'default'
        }

        -- vim.cmd("colorscheme zenbones")
        -- vim.cmd.colorscheme("zenbones")
    end,
}
