return {
    "vim-test/vim-test",
    dependencies = {
        "preservim/vimux"
    },
    vim.keymap.set('n', '<leader>bf', ':TestNearest<CR>'),
    vim.keymap.set('n', '<leader>B', ':TestFile<CR>'),
    vim.keymap.set('n', '<leader>bs', ':testSuite<CR>'),
    vim.keymap.set('n', '<leader>bl', ':TestLast<CR>'),
    vim.keymap.set('n', '<leader>bv', ':TestVisit<CR>'),
    vim.cmd("let test#strategy = 'vimux'")
}
