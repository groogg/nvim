vim.g.mapleader = " "

vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")

vim.keymap.set('x', '<leader>p', [["_dP]])

vim.keymap.set({ 'n', 'v' }, '<leader>y', [["+y]])
vim.keymap.set('n', '<leader>Y', [["+Y]])

vim.keymap.set({ 'n', 'v' }, '<leader>d', '"_d')

vim.keymap.set('n', '<leader>sr', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- Conform
vim.keymap.set("n", "<leader>=", function()
    require("conform").format()
end, { desc = "Format current buffer" })
