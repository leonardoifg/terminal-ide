return {
  -- Gitsigns: mostra alterações no código em tempo real
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns
          local map = vim.keymap.set
          local opts = { buffer = bufnr }

          map("n", "]c",          gs.next_hunk,    opts) -- próximo bloco alterado
          map("n", "[c",          gs.prev_hunk,    opts) -- bloco anterior
          map("n", "<leader>hs",  gs.stage_hunk,   opts) -- faz stage do bloco
          map("n", "<leader>hr",  gs.reset_hunk,   opts) -- reverte o bloco
          map("n", "<leader>hp",  gs.preview_hunk, opts) -- preview do diff
          map("n", "<leader>hb",  gs.blame_line,   opts) -- blame da linha
          map("n", "<leader>hd",  gs.diffthis,     opts) -- diff completo do arquivo
        end,
      })
    end,
  },

  -- Fugitive: executa comandos Git dentro do Neovim
  { "tpope/vim-fugitive" },
  -- Use :G para abrir o painel, :G push, :G log, :G diff etc.
}
