vim.g.mapleader = ' '

vim.keymap.set('i', 'jk', '<Esc>', { noremap = true, silent = true })

vim.keymap.set('n', 'U', '<C-r>', { noremap = true })
vim.keymap.set('n', '<C-r>', 'U', { noremap = true })

vim.keymap.set('n', 'j', 'gj', { noremap = true })
vim.keymap.set('n', 'k', 'gk', { noremap = true })

vim.keymap.set('n', '<Leader>e', '[edit]', { remap = true })
vim.keymap.set('n', '[edit]', '<Nop>', { noremap = true })

vim.keymap.set('n', '<Leader>x', '[terminal]', { remap = true })
vim.keymap.set('n', '[terminal]', '<Nop>', { noremap = true })
-- vim.keymap.set('n', '[terminal]x', '<cmd>new<CR><Cmd>terminal<CR>', { noremap = true })
vim.keymap.set('n', '[terminal]h', '<Cmd>vertical aboveleft new<CR><Cmd>terminal<CR>', { noremap = true })
vim.keymap.set('n', '[terminal]j', '<cmd>rightbelow new<CR><Cmd>terminal<CR>', { noremap = true })
vim.keymap.set('n', '[terminal]k', '<Cmd>aboveleft new<CR><Cmd>terminal<CR>', { noremap = true })
vim.keymap.set('n', '[terminal]l', '<Cmd>vertical rightbelow new<CR><Cmd>terminal<CR>', { noremap = true })
