return {
    {
        "folke/tokyonight.nvim",
        config = function()
            require("tokyonight").setup({})
        end
    },
    {
        "rose-pine/neovim",
        name = "rose-pine",
        config = function()
            require('rose-pine').setup({
                disable_background = true,
                styles = {
                    italic = false,
                },
            })
        end
    }
}
