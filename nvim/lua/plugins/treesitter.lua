return {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    lazy = false,
    build = ':TSUpdate',
    dependencies = {
        { 'nvim-treesitter/nvim-treesitter-textobjects', branch = 'main' },
    },
    config = function()
        local treesitter = require('nvim-treesitter')
        treesitter.setup({ install_dir = vim.fn.stdpath('data') .. '/site' })

        local languages = {
            'javascript', 'typescript', 'tsx', 'python', 'c',
            'lua', 'vim', 'vimdoc', 'query', 'markdown', 'markdown_inline',
            'html', 'css', 'svelte',
        }
        treesitter.install(languages)

        local available = treesitter.get_available()
        vim.api.nvim_create_autocmd('FileType', {
            callback = function(args)
                local lang = vim.treesitter.language.get_lang(args.match) or args.match
                if not vim.list_contains(available, lang) then
                    return
                end

                if not vim.list_contains(treesitter.get_installed('parsers'), lang) then
                    treesitter.install(lang)
                end

                if pcall(vim.treesitter.start, args.buf) and args.match ~= 'javascript' and args.match ~= 'typescript' and args.match ~= 'typescriptreact' then
                    vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                end
            end,
        })
    end,
}
