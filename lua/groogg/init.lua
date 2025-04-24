vim.g.mapleader = " "

require("groogg.lazy_init")
require("groogg.remap")
require("groogg.set")

local augroup = vim.api.nvim_create_augroup
local GrooggGroup = augroup('groogg', {})
local autocmd = vim.api.nvim_create_autocmd

autocmd('TextYankPost', {
    group = augroup('HighlightYank', {}),
    pattern = '*',
    callback = function()
        vim.highlight.on_yank({
            higroup = 'IncSearch',
            timeout = 40,
        })
    end,
})

autocmd('LspAttach', {
    group = GrooggGroup,
    callback = function(e)
        vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, { buffer = e.buf, desc = "Go to definition" })
        vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, { buffer = e.buf, desc = "Show hover information" })
        vim.keymap.set("n", "<leader>ln", function() vim.lsp.buf.rename() end, { buffer = e.buf, desc = "Rename symbol" })
        vim.keymap.set("n", "<leader>lw", function() vim.lsp.buf.workspace_symbol() end, { buffer = e.buf, desc = "Search workspace symbols" })
        vim.keymap.set("n", "<leader>ld", function() vim.diagnostic.open_float() end, { buffer = e.buf, desc = "Show diagnostics in float" })
        vim.keymap.set("n", "<leader>la", function() vim.lsp.buf.code_action() end, { buffer = e.buf, desc = "Show code actions" })
        vim.keymap.set("n", "<leader>lr", function() vim.lsp.buf.references() end, { buffer = e.buf, desc = "Find references" })
        vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, { buffer = e.buf, desc = "Show signature help" })
        vim.keymap.set("n", "g [", function() vim.diagnostic.goto_next() end, { buffer = e.buf, desc = "Go to next diagnostic" })
        vim.keymap.set("n", "g ]", function() vim.diagnostic.goto_prev() end, { buffer = e.buf, desc = "Go to previous diagnostic" })
        
    end
})