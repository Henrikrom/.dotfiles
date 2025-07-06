-- requires kitty or similar terminal emulator that supports image viewing
return {
    "edluffy/hologram.nvim",
    name = "hologram.nvim",
    config = function()
        require("hologram").setup{
            auto_display = true
        }
    end,
}

