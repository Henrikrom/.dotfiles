return {
    "ggandor/leap.nvim",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    config = function()
        require("leap").create_default_mappings()

        vim.keymap.set('n', 's', '<Plug>(leap-anywhere)')
        vim.keymap.set('x', 's', '<Plug>(leap)')
        vim.keymap.set('o', 's', '<Plug>(leap-forward)')
        vim.keymap.set('o', 'S', '<Plug>(leap-backward)')
    end
}

