# https://tmux-language-server.readthedocs.io/en/latest/resources/configure.html#neo-vim

-- vim.api.nvim_create_autocmd({ "BufEnter" }, {
--   pattern = { "tmux.conf", ".tmux.conf" },
--   callback = function()
--     vim.lsp.start({
--       name = "tmux",
--       cmd = { "tmux-language-server" }
--     })
--   end,
-- })
