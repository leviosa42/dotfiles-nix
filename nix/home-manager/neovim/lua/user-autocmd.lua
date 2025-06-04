vim.cmd([[
  augroup autocmds
    autocmd!
    " Open terminal-mode in insert mode
    autocmd TermOpen * startinsert
  augroup END
]])

-- indent
vim.cmd([[
  augroup indent
    autocmd!
    autocmd FileType go setl noet ts=4 sw=0 sts=-1
    autocmd FileType make setl noet ts=4 sw=0 sts=-1
    autocmd FileType javascript setl noet ts=4 sw=0 sts=-1
    autocmd FileType lua setl et ts=2 sw=0 sts=-1
    autocmd FileType nix setl et ts=2 sw=0 sts=-1
  augroup END
]])

-- commentstring
vim.cmd([[
  augroup commentstring
    autocmd!
    autocmd FileType ggnuplot setl cms=#\ %s
  augroup END
]])
-- highlight yank
vim.cmd([[
  augroup highlight_yank
  autocmd!
  au TextYankPost * silent! lua vim.highlight.on_yank({higroup="IncSearch", timeout=500})
  augroup END
]])
