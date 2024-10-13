-- Custom commands for Python unittest
vim.cmd([[
  command! -nargs=1 MakeDir :set makeprg=python\ -m\ unittest\ discover\ -s\ <args> | make
  command! -nargs=1 MakeFile :set makeprg=python\ -m\ unittest\ <args> | make
]])

-- Custom commands for Cargo tests
vim.cmd([[
  command! -nargs=1 CargoDir :set makeprg=cargo\ test\ --manifest-path\ <args>/Cargo.toml | make
  command! -nargs=1 CargoFile :set makeprg=cargo\ test\ <args> | make
]])

-- Default makeprg and errorformat settings for Python unittest
vim.cmd([[
  set makeprg=python\ -m\ unittest\ discover\ -s\ .
  set errorformat=%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%C\ \ \ \ %*\\\ \ %m,%Z%[%^\ ]%\\@=%m
]])

-- Automatically use default <CR> behavior in quickfix window
vim.api.nvim_command([[
  autocmd FileType qf nnoremap <buffer> <CR> <CR>
]])

-- -- Custom command to run unittest discover in a directory
-- vim.cmd([[
--   command! -nargs=1 MakeDir :set makeprg=python\ -m\ unittest\ discover\ -s\ <args> | make
-- ]])
--
-- -- Custom command to run unittest on a specific file
-- vim.cmd([[
--   command! -nargs=1 MakeFile :set makeprg=python\ -m\ unittest\ <args> | make
-- ]])
--
-- vim.cmd [[
--   command! -nargs=1 CargoDir :set makeprg=cargo\ test\ --manifest-path\ <args>/Cargo.toml | make
--   command! -nargs=1 CargoFile :set makeprg=cargo\ test\ <args> | make
--   command! -nargs=1 MakeDir :set makeprg=python\ -m\ unittest\ discover\ -s\ <args> | make
--   command! -nargs=1 MakeFile :set makeprg=python\ -m\ unittest\ <args> | make
-- ]]
--
-- -- Setting makeprg and errorformat for Python unittest
-- vim.cmd([[
--   set makeprg=python\ -m\ unittest\ discover\ -s\ .
--   set errorformat=%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%C\ \ \ \ %*\\\ \ %m,%Z%[%^\ ]%\\@=%m
-- ]])
--
-- -- Automatically use default behavior for <CR> in quickfix window
-- vim.api.nvim_command([[
--   autocmd FileType qf nnoremap <buffer> <CR> <CR>
-- ]])
