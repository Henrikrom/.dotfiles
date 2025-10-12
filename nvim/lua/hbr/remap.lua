vim.g.mapleader = " "

vim.keymap.set("n", "<leader>w", function()
    vim.cmd("wa")
end, { noremap = true, silent = true })

vim.keymap.set("n", "<leader>,", "<C-o>")
vim.keymap.set("n", "<leader>.", "<C-i>")

vim.keymap.set("n", "<leader>\\", ":vsplit<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>v", ":split<CR>", { noremap = true, silent = true })

vim.keymap.set("n", "<leader>t", function()
    vim.cmd("split")
    vim.cmd("wincmd j")
    vim.cmd("terminal")
    vim.cmd("resize " .. math.floor(vim.o.lines * 0.2))
end, { noremap = true, silent = true})

vim.keymap.set("t", "<Esc><Esc>", [[<C-\><C-n>]], { noremap = true, silent = true })

vim.keymap.set("n", "<C-Up>", ":resize +2<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-Down>", ":resize -2<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-Right>", ":vertical resize +2<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-Left>", ":vertical resize -2<CR>", { noremap = true, silent = true })

vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>f", ":NvimTreeFocus<CR>", { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<leader>cd', ':cd %:p:h<CR>', { noremap = true, silent = true })

-- vim.keymap.set("n", "<leader>h", "<C-w>h", { noremap = true, silent = true })
-- vim.keymap.set("n", "<leader>j", "<C-w>j", { noremap = true, silent = true })
-- vim.keymap.set("n", "<leader>k", "<C-w>k", { noremap = true, silent = true })
-- vim.keymap.set("n", "<leader>l", "<C-w>l", { noremap = true, silent = true })

vim.keymap.set("n", "<C-h>", ":wincmd h<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-j>", ":wincmd j<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-k>", ":wincmd k<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-l>", ":wincmd l<CR>", { noremap = true, silent = true })

vim.keymap.set('n', '<leader>q', ':q<CR>', { noremap = true, silent = true })

vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("v", "J", ":m '>+1<cr>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<cr>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("n", "n", "nzzzv")

vim.keymap.set("x", "<leader>p", "\"_dP")

vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "\"+Y")

vim.keymap.set("n", "<leader>d", "\"_d")
vim.keymap.set("v", "<leader>d", "\"_d")

vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

vim.keymap.set("n", "<leader>s", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>")
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- Keep cursor at original position when deleting
vim.keymap.set('n', 'di"', 'mzdi"`z', { noremap = true, silent = true })
vim.keymap.set('n', 'di(', 'mzdi(`z', { noremap = true, silent = true })
vim.keymap.set('n', 'di)', 'mzdi)`z', { noremap = true, silent = true })
vim.keymap.set('n', 'di{', 'mzdi{`z', { noremap = true, silent = true })
vim.keymap.set('n', 'di}', 'mzdi}`z', { noremap = true, silent = true })

vim.keymap.set('n', 'da"', 'mzda"`z', { noremap = true, silent = true })
vim.keymap.set('n', 'da(', 'mzda(`z', { noremap = true, silent = true })
vim.keymap.set('n', 'da)', 'mzda)`z', { noremap = true, silent = true })
vim.keymap.set('n', 'da{', 'mzda{`z', { noremap = true, silent = true })
vim.keymap.set('n', 'da}', 'mzda}`z', { noremap = true, silent = true })

vim.keymap.set('n', "'",
  function()
    local char = vim.fn.getcharstr()
    vim.cmd('normal! `' .. char)
  end,
  { desc = "Jump to exact mark (like ` but easier)" }
)

