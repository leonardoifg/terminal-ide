-- Path atualizado
-- vim.env.PATH = "/Users/leo/.cargo/bin:/opt/homebrew/bin:" .. vim.env.PATH
vim.env.PATH = "/opt/homebrew/bin:" .. vim.env.PATH
-- Leader key: deve ser a primeira linha — antes de qualquer plugin ou require
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Carrega as configurações gerais do editor
require("core.options")

-- Carrega seus atalhos de teclado
require("core.keymaps")

-- Instala o gerenciador de plugins (lazy.nvim) automaticamente
-- vim.uv é a API moderna (Neovim 0.10+); vim.loop é o fallback para versões anteriores
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Proteção para a primeira abertura: se o lazy ainda não foi instalado,
-- avisa e aguarda em vez de travar com erro
local ok, lazy = pcall(require, "lazy")
if not ok then
  print("Lazy.nvim ainda está sendo instalado. Feche e reabra o Neovim.")
  return
end

-- Lembrar onde parou a edição
vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      vim.api.nvim_win_set_cursor(0, mark)
    end
  end,
})
-- Carrega todos os arquivos dentro de lua/plugins/ automaticamente
lazy.setup("plugins")
