return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",          -- sugestões do LSP
      "hrsh7th/cmp-buffer",            -- sugestões do texto aberto
      "hrsh7th/cmp-path",              -- sugestões de caminhos de arquivo
      "L3MON4D3/LuaSnip",             -- engine de snippets
      "saadparwaiz1/cmp_luasnip",      -- integra LuaSnip ao cmp
      "rafamadriz/friendly-snippets",  -- snippets prontos para várias linguagens
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      -- Carrega os snippets prontos
      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup({
        snippet = {
          expand = function(args) luasnip.lsp_expand(args.body) end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<Tab>"]     = cmp.mapping.select_next_item(),   -- próxima sugestão
          ["<S-Tab>"]   = cmp.mapping.select_prev_item(),   -- sugestão anterior
          ["<CR>"]      = cmp.mapping.confirm({ select = true }), -- aceita sugestão
          ["<C-Space>"] = cmp.mapping.complete(),           -- abre o menu manualmente
          ["<C-e>"]     = cmp.mapping.abort(),              -- fecha o menu
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },  -- prioridade mais alta: LSP
          { name = "luasnip" },   -- depois: snippets
          { name = "buffer" },    -- depois: texto do arquivo
          { name = "path" },      -- depois: caminhos
        }),
      })
    end,
  },
}
