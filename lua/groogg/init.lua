vim.g.mapleader = " "

require("groogg.lazy_init")
require("groogg.set")
require("groogg.remap")

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
        vim.keymap.set("n", "<leader>lw", function() vim.lsp.buf.workspace_symbol() end,
            { buffer = e.buf, desc = "Search workspace symbols" })
        vim.keymap.set("n", "<leader>ld", function() vim.diagnostic.open_float() end,
            { buffer = e.buf, desc = "Show diagnostics in float" })
        vim.keymap.set("n", "<leader>la", function() vim.lsp.buf.code_action() end,
            { buffer = e.buf, desc = "Show code actions" })
        vim.keymap.set("n", "<leader>lr", function() vim.lsp.buf.references() end,
            { buffer = e.buf, desc = "Find references" })
        vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end,
            { buffer = e.buf, desc = "Show signature help" })
        vim.keymap.set("n", "g [", function() vim.diagnostic.goto_next() end,
            { buffer = e.buf, desc = "Go to next diagnostic" })
        vim.keymap.set("n", "g ]", function() vim.diagnostic.goto_prev() end,
            { buffer = e.buf, desc = "Go to previous diagnostic" })
    end
})

-- Defer things from Ruff to the LSP
vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup('lsp_attach_disable_ruff_hover', { clear = true }),
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client == nil then
            return
        end
        if client.name == 'ruff' then
            -- Disable hover in favor of Pyright
            client.server_capabilities.hoverProvider = false
        end
    end,
    desc = 'LSP: Disable hover capability from Ruff',
})

-- Dotenv custom script
local dotenv = require("groogg.dotenv")

-- Load .env from the current working directory when Neovim starts
vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        local cwd = vim.fn.getcwd()
        local env_file = cwd .. "/.env"
        dotenv.eval(env_file, false) -- false means don't overwrite existing env vars
    end,
    desc = "Load .env file from current working directory",
})

vim.api.nvim_create_user_command("ReloadEnv", function()
    local cwd = vim.fn.getcwd()
    local env_file = cwd .. "/.env"
    dotenv.eval(env_file, true) -- true means overwrite existing env vars
    print("Reloaded environment variables from " .. env_file)
end, { desc = "Reload environment variables from .env file" })
