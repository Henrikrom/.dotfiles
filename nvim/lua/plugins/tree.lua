return {
  "nvim-tree/nvim-tree.lua",
  dependencies = {
    "nvim-tree/nvim-web-devicons", -- optional, for file icons
  },
  config = function()
    require("nvim-tree").setup({
      -- Nvim-Tree options
      view = {
          width = 30, -- Width of the Nvim-Tree window
          side = "left", -- Side of the screen to display Nvim-Tree
          relativenumber = true, -- Use relative line numbers in Nvim-Tree
          adaptive_size = true, -- Optional: Adjust the size of the tree based on content
      },

      actions = {
          open_file = {
              quit_on_open = false, -- Closes nvim-tree when opening a file
          },
      },

      update_focused_file = {
          enable = true,      -- Update the tree when switching buffers
          update_cwd = false, -- Optional: Change the working directory to the file's location
      },

      filters = {
          dotfiles = false, -- Set to false to show hidden files
      },

      --renderer = {
      --  highlight_git = true, -- Highlight git changes in the tree
      --  icons = {
      --    show = {
      --      git = true,
      --      folder = true,
      --      file = true,
      --    },
      --  },
      --},
      --git = {
      --  enable = true, -- Enable git integration
      --},
      --diagnostics = {
      --  enable = true, -- Show diagnostics in the tree
      --  icons = {
      --    hint = "",
      --    info = "",
      --    warning = "",
      --    error = "",
      --  },
      --},
    })
  end,
}

