return {
  -- Tema (carrega primeiro, alta prioridade)
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    config = function()
      vim.cmd("colorscheme tokyonight-night")
    end,
  },

  -- Statusline (barra inferior com modo, arquivo, branch etc.)
  {
    "nvim-lualine/lualine.nvim",
    config = function()
      require("lualine").setup({ options = { theme = "tokyonight" } })
    end,
  },

  -- Fecha parênteses, colchetes e aspas automaticamente
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true,
  },

  -- Comentar código com gcc (linha) ou gc+movimento (bloco)
  {
    "numToStr/Comment.nvim",
    config = true,
  },

  -- Linhas verticais de indentação
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    config = true,
  },

  -- Mostra os atalhos disponíveis ao pressionar <leader> e esperar
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = true,
  },

  -- Painel de erros e warnings do projeto inteiro
  {
    "folke/trouble.nvim",
    config = true,
    -- :Trouble para abrir
  },

  -- Salto rápido: s + 2 letras pula para qualquer lugar visível
  {
    -- "ggandor/leap.nvim",
    url = "https://codeberg.org/andyg/leap.nvim",
    config = function()
      require("leap").add_default_mappings()
    end,
  },

  -- Editar delimitadores: ysiw" envolve palavra em aspas
  --                        cs"'  troca aspas duplas por simples
  --                        ds"   remove as aspas
  {
    "kylechui/nvim-surround",
    config = true,
  },
}
