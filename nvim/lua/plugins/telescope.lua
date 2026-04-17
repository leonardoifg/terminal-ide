return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" }, -- busca mais rápida
    },
    config = function()
      local telescope = require("telescope")
      local builtin = require("telescope.builtin")

      telescope.setup({
        defaults = {
          -- Ignora pastas irrelevantes na busca
          file_ignore_patterns = { "node_modules", ".git/", "target/" },
        },
      })
      telescope.load_extension("fzf")

      -- Atalhos
      local map = vim.keymap.set
      map("n", "<leader>ff", builtin.find_files)       -- busca por nome de arquivo
      map("n", "<leader>fg", builtin.live_grep)        -- busca por texto em todos os arquivos
      map("n", "<leader>fb", builtin.buffers)          -- lista arquivos abertos
      map("n", "<leader>fd", builtin.diagnostics)      -- lista todos os erros do projeto
      map("n", "<leader>fr", builtin.lsp_references)   -- referências do símbolo atual
      map("n", "<leader>fs", builtin.lsp_document_symbols) -- símbolos do arquivo
    end,
  },
}
