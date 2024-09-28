vim.api.nvim_create_autocmd("BufWinEnter", {
  pattern = "*.vert,*.frag",
  command = "set filetype=glsl",
})
