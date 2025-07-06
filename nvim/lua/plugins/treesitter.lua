return {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate', -- Automatically update parsers after installation
    dependencies = {
        'nvim-treesitter/nvim-treesitter-textobjects', -- Optional for text objects
    },
    config = function()
        require('nvim-treesitter.configs').setup({
            -- List of parsers to install
            ensure_installed = {
                "javascript", "typescript", "python", "c",
                "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline"
            },

            -- Install parsers synchronously (applies to `ensure_installed`)
            sync_install = false,

            -- Automatically install missing parsers when entering buffer
            -- Recommendation: Set to `false` if you don't have the `tree-sitter` CLI installed locally
            auto_install = true,

            highlight = {
                enable = true, -- Enable syntax highlighting

                -- Run `:h syntax` and Tree-sitter together
                -- Only enable this if you depend on 'syntax' for something specific
                additional_vim_regex_highlighting = false,
            },
        })
    end,
}

