return {
  -- Mason: instala e gerencia os servidores de linguagem
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },

  -- Mason-lspconfig: ponte entre Mason e nvim-lspconfig
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        -- Servidores que serão instalados automaticamente
        ensure_installed = {
          "rust_analyzer",  -- Rust
          "clangd",         -- C e C++
          "html",           -- HTML
          "cssls",          -- CSS
          "ts_ls",          -- JavaScript e TypeScript
          "pyright",        -- Python
        },
        automatic_installation = true,
      })
    end,
  },

  -- nvim-lspconfig: configura cada servidor
  {
    "neovim/nvim-lspconfig",
    dependencies = { "williamboman/mason-lspconfig.nvim" },
    config = function()
      local map = vim.keymap.set
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- local lspconfig = require("lspconfig")

      -- Atalhos que ficam disponíveis em qualquer arquivo com LSP ativo
      local on_attach = function(_, bufnr)
        local opts = { buffer = bufnr, silent = true }
        map("n", "gd",          vim.lsp.buf.definition,     opts) -- ir para definição
        map("n", "gD",          vim.lsp.buf.declaration,    opts) -- ir para declaração
        map("n", "gr",          vim.lsp.buf.references,     opts) -- listar referências
        map("n", "gi",          vim.lsp.buf.implementation, opts) -- ir para implementação
        map("n", "K",           vim.lsp.buf.hover,          opts) -- documentação inline
        map("n", "<leader>rn",  vim.lsp.buf.rename,         opts) -- renomear símbolo
        map("n", "<leader>ca",  vim.lsp.buf.code_action,    opts) -- correções automáticas
        map("n", "<leader>f",   vim.lsp.buf.format,         opts) -- formatar arquivo
        map("n", "[d", vim.diagnostic.goto_prev, opts) -- erro anterior
        map("n", "]d", vim.diagnostic.goto_next, opts) -- próximo erro
        map("n", "<leader>e", vim.diagnostic.open_float, opts) -- detalhes do erro
      end

      -- Aplica a mesma configuração a todos os servidores (exceto Rust, que usa rustaceanvim)
      local servers = { "clangd", "html", "cssls", "ts_ls", "pyright" }
      for _, server in ipairs(servers) do
      	-- Neovim > 0.10
        vim.lsp.config(server, {
	  on_attach = on_attach,
	  capabilities = capabilities,
	})
        vim.lsp.enable(server)
      end
    end,
  },
}

