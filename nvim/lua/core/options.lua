local opt = vim.opt

opt.number = true            -- mostra número das linhas
opt.relativenumber = true    -- números relativos (facilita comandos como d5j, y3k)
opt.tabstop = 4              -- tab equivale a 4 espaços
opt.shiftwidth = 4           -- indentação com 4 espaços
opt.expandtab = true         -- usa espaços em vez de tabs
opt.smartindent = true       -- indenta automaticamente
opt.wrap = false             -- sem quebra de linha automática
opt.termguicolors = true     -- cores completas no terminal
opt.scrolloff = 8            -- mantém 8 linhas visíveis ao rolar
opt.signcolumn = "yes"       -- coluna fixa para ícones de LSP e Git (evita o layout "pular")
opt.updatetime = 250         -- atualiza hover e diagnósticos mais rápido (ms)
opt.undofile = true          -- desfazer persiste entre sessões (mesmo após fechar o Neovim)
opt.ignorecase = true        -- busca sem diferenciar maiúsculas
opt.smartcase = true         -- mas respeita maiúsculas se você digitá-las
opt.splitbelow = true        -- split horizontal abre abaixo
opt.splitright = true        -- split vertical abre à direita
opt.clipboard = "unnamedplus" -- compartilha clipboard com o sistema operacional

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.py",
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})
