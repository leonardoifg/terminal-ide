local map = vim.keymap.set
local opts = { silent = true, noremap = true }

-- Navegar entre splits com Ctrl + direção (sem precisar de Ctrl+w)
map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)

-- Mover linhas selecionadas para cima/baixo no modo Visual
map("v", "J", ":m '>+1<CR>gv=gv", opts)
map("v", "K", ":m '<-2<CR>gv=gv", opts)

-- Manter o cursor centralizado ao rolar a página
map("n", "<C-d>", "<C-d>zz", opts)
map("n", "<C-u>", "<C-u>zz", opts)
map("n", "n", "nzzzv", opts)  -- próxima busca centralizada
map("n", "N", "Nzzzv", opts)  -- busca anterior centralizada

-- Colar sem sobrescrever o clipboard (útil ao substituir uma seleção)
map("x", "<leader>p", '"_dP', opts)

-- Copiar para o clipboard do sistema
map("n", "<leader>y", '"+y', opts)
map("v", "<leader>y", '"+y', opts)

-- Limpar o highlight da busca atual
map("n", "<leader>h", ":nohlsearch<CR>", opts)

-- Mostra janela popup com o erro/warning/info da linha
map("n", "<leader>i", vim.diagnostic.open_float, opts)

-- Comuta linhas relativas com absolutas
map("n", "<leader>n", function()
  vim.opt.relativenumber = not vim.opt.relativenumber:get()
end, opts)

-- Salvar e fechar
map("n", "<leader>w", function() vim.cmd("w") end, opts)
map("n", "<leader>q", function() vim.cmd("q") end, opts)

-- Navegar entre buffers (arquivos abertos)
map("n", "<S-h>", ":bprevious<CR>", opts)
map("n", "<S-l>", ":bnext<CR>", opts)
map("n", "<leader>x", ":bdelete<CR>", opts)

-- Manter a seleção após indentar no modo Visual
map("v", "<", "<gv", opts)
map("v", ">", ">gv", opts)

-- Sair do modo terminal com Esc
map("t", "<Esc>", "<C-\\><C-n>", opts)

-- Abrir terminal integrado
map("n", "<leader>tt", ":terminal<CR>", opts)
