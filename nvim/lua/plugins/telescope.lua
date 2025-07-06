return {
    'nvim-telescope/telescope.nvim', tag = '0.1.8',
    -- or                              , branch = '0.1.x',
    dependencies = { 'nvim-lua/plenary.nvim' },

    config = function()
        local builtin = require('telescope.builtin')

        vim.keymap.set('n', '<leader>o', function()
            builtin.find_files({ hidden = true })
        end, {})

        --vim.keymap.set('n', '<leader>o', builtin.find_files, {})
        vim.keymap.set('n', '<C-p>', builtin.git_files, {})
        vim.keymap.set('n', '<leader>g', function()
            builtin.grep_string({ search = vim.fn.input("Grep > ") })
        end)

        vim.keymap.set('v', '<leader>g', function()
            vim.cmd('normal! "ay')

            local text = vim.fn.getreg('a')

            builtin.grep_string({ search = vim.fn.input("Grep > ", text) })
        end)
    end,
}
