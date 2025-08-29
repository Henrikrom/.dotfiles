return {
  "vim-test/vim-test",
  dependencies = {
    "preservim/vimux"
  },
  config = function()
    -- Keymaps
    vim.keymap.set('n', '<leader>bf', ':TestNearest<CR>')
    vim.keymap.set('n', '<leader>B', ':TestFile<CR>')
    vim.keymap.set('n', '<leader>bs', ':TestSuite<CR>')
    vim.keymap.set('n', '<leader>bl', ':TestLast<CR>')
    vim.keymap.set('n', '<leader>bv', ':TestVisit<CR>')

    -- Strategy: run inside vimux
    vim.cmd("let test#strategy = 'vimux'")

    vim.cmd("let g:test#csharp#runner = 'dotnettest'")
  end
}
