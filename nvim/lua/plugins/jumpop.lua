return {
    "Henrikrom/jumpop.nvim",
    -- dir = "/home/hbr/code/jumpop.nvim",
    name = "jumpop.nvim",
    config = function()
        require("jumpop").setup({
            max_offset = 15,
            direction = "both"
        })
    end,
}
