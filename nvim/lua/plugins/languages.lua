return {
  -- RUST: integração superior ao LSP padrão
  {
    "mrcjkb/rustaceanvim",
    version = "^4",
    ft = { "rust" },  -- carrega só ao abrir um arquivo .rs
    config = function()
      vim.g.rustaceanvim = {
        server = {
          on_attach = function(_, bufnr)
            local map = vim.keymap.set
            local opts = { buffer = bufnr }
            map("n", "<leader>rr", ":RustLsp runnables<CR>",    opts) -- lista targets executáveis
            map("n", "<leader>rt", ":RustLsp testables<CR>",    opts) -- lista e roda testes
            map("n", "<leader>re", ":RustLsp expandMacro<CR>",  opts) -- expande macros
            map("n", "<leader>rc", ":RustLsp openCargo<CR>",    opts) -- abre Cargo.toml
          end,
          settings = {
            ["rust-analyzer"] = {
              checkOnSave = { command = "clippy" }, -- usa clippy no lugar de check
            },
          },
        },
      }
    end,
  },

  -- RUST: autocomplete de versões no Cargo.toml
  {
    "saecki/crates.nvim",
    ft = "toml",
    config = true,
  },

  -- HTML/JSX: fecha tags automaticamente
  {
    "windwp/nvim-ts-autotag",
    ft = { "html", "javascript", "typescript", "jsx", "tsx" },
    config = true,
  },

  -- CSS/HTML: mostra a cor inline no código (#ff0000 aparece vermelho)
  {
    "NvChad/nvim-colorizer.lua",
    config = true,
  },

  -- HTML/CSS: Emmet (expansão de abreviações)
  {
    "mattn/emmet-vim",
    ft = { "html", "css" },
    -- Uso: escreva "div.container>ul>li*3" e pressione Ctrl+y,
  },
}
