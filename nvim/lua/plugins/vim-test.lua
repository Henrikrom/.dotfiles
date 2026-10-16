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


    -- Match Foo.component_test.js to jest.component_test.config.js when present.
    vim.cmd([[
      function! FilenameJestConfig(cmd) abort
        let jest_end = matchend(a:cmd, '\(^\|\s\)\(\S*/\)\?jest\ze\(\s\|$\)')
        if jest_end < 0 || a:cmd =~# '\(^\|\s\)--config\(\s\|=\)'
          return a:cmd
        endif

        let file = get(get(g:, 'test#last_position', {}), 'file', expand('%'))
        let suffix = matchstr(fnamemodify(file, ':t:r'), '\.\zs[^.]\+$')
        if empty(suffix) || suffix ==# 'test' || suffix ==# 'spec'
          return a:cmd
        endif

        let config = 'jest.' . suffix . '.config.js'
        if !filereadable(config)
          return a:cmd
        endif

        return strpart(a:cmd, 0, jest_end) . ' --config ' . shellescape(config) . strpart(a:cmd, jest_end)
      endfunction

      let g:test#custom_transformations['filename_jest_config'] = function('FilenameJestConfig')
      let g:test#transformation = 'filename_jest_config'
    ]])
  end
}
