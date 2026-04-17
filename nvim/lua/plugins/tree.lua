return {
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({
        view = { width = 30 },
        renderer = { group_empty = true },  -- agrupa pastas vazias
        filters = { dotfiles = false },     -- mostra arquivos ocultos (.env etc.)
      })

      local map = vim.keymap.set
      map("n", "<leader>t",  ":NvimTreeToggle<CR>")    -- abre/fecha a árvore
      map("n", "<leader>tf", ":NvimTreeFindFile<CR>")  -- revela o arquivo atual na árvore
    end,
  },
}
