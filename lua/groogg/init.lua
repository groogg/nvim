vim.g.mapleader = " "

require("groogg.lazy_init")
require("groogg.remap")
require("groogg.set")


autocmd('TextYankPost', {
    group = yank_group,
    pattern = '*',
    callback = function()
        vim.highlight.on_yank({
            higroup = 'IncSearch',
            timeout = 40,
        })
    end,
})