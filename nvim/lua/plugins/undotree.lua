return {
    'mbbill/undotree',
    config = function()
        -- Keybinding to toggle the UndoTree
        vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle, { desc = 'Toggle UndoTree' })

        -- Optional: Customize UndoTree behavior
        vim.g.undotree_SetFocusWhenToggle = 1 -- Focus on the undo tree when toggled
        vim.g.undotree_SplitWidth = 30       -- Set the width of the UndoTree window
        vim.g.undotree_DiffpanelHeight = 10  -- Set the height of the diff panel
        vim.g.undotree_WindowLayout = 2      -- Alternative layout (tree on the left, diff on the right)
    end,
}

