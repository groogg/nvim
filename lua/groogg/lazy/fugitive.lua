return {
    "tpope/vim-fugitive",
    config = function()
        vim.keymap.set("n", "<leader>gs", function()
            vim.cmd("Git")
        end, { desc = "Git status" })

        -- Add shortcut for "git add ."
        vim.keymap.set("n", "<leader>ga", function()
            vim.cmd("Git add .")
            print("All changes staged")
        end, { desc = "Git add all" })

        -- Add shortcut for "git commit"
        vim.keymap.set("n", "<leader>gc", function()
            vim.cmd("Git commit")
        end, { desc = "Git commit" })

        -- Add shortcut for "git add . && git commit"
        vim.keymap.set("n", "<leader>gA", function()
            vim.cmd("Git add .")
            vim.cmd("Git commit")
        end, { desc = "Git add all and commit" })

        local GrooggFugitive = vim.api.nvim_create_augroup("GrooggFugitive", {})

        vim.api.nvim_create_autocmd("BufWinEnter", {
            group = GrooggFugitive,
            pattern = "*",
            callback = function()
                if vim.bo.ft ~= "fugitive" then
                    return
                end

                local bufnr = vim.api.nvim_get_current_buf()
                local opts = { buffer = bufnr, remap = false }

                vim.keymap.set("n", "<leader>p", function()
                    vim.cmd("Git push")
                end, opts)

                vim.keymap.set("n", "<leader>P", function()
                    vim.cmd("Git pull --rebase")
                end, opts)

                vim.keymap.set("n", "<leader>t", ":Git push -u origin ", opts)
            end,
        })

        vim.keymap.set("n", "gu", "<cmd>diffget //2<CR>", { desc = "Get diff from left (target)" })
        vim.keymap.set("n", "gh", "<cmd>diffget //3<CR>", { desc = "Get diff from right (merge)" })
    end
}
