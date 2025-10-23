return {
    "numToStr/Comment.nvim",
    name = "Comment.nvim",
    dependencies = {
        "JoosepAlviste/nvim-ts-context-commentstring",
    },
    config = function()
        require("Comment").setup({
            pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
        })

        vim.api.nvim_create_autocmd("FileType", {
            pattern = "razor",
            callback = function()
                if vim.bo.commentstring == "" or vim.bo.commentstring == nil then
                    vim.bo.commentstring = "<!-- %s -->"
                end
            end,
        })
    end,
}

