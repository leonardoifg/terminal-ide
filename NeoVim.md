# Neovim como IDE em VPS: Guia Completo

> **Para quem:** Usuários com base em Vim que querem um ambiente completo para Rust, C, HTML, CSS, JS e Python — diretamente em servidores remotos, sem interface gráfica.

---

## Antes de tudo: a estrutura de arquivos

Todo o Neovim é configurado por arquivos `.lua` dentro de `~/.config/nvim/`. Esta é a estrutura que vamos construir ao longo do tutorial. Cada seção vai dizer exatamente em qual arquivo o código vai.

```
~/.config/nvim/
│
├── init.lua                  ← ARQUIVO PRINCIPAL (ponto de entrada)
│
└── lua/
    ├── core/
    │   ├── options.lua       ← configurações gerais do editor
    │   └── keymaps.lua       ← seus atalhos de teclado
    │
    └── plugins/
        ├── treesitter.lua    ← syntax highlighting
        ├── lsp.lua           ← inteligência por linguagem (LSP)
        ├── cmp.lua           ← autocompletar
        ├── telescope.lua     ← busca de arquivos e texto
        ├── nvim-tree.lua     ← árvore de arquivos
        ├── git.lua           ← integração com Git
        ├── languages.lua     ← configs específicas por linguagem
        └── extras.lua        ← plugins de qualidade de vida
```

Para criar essa estrutura de uma vez:

```bash
mkdir -p ~/.config/nvim/lua/core
mkdir -p ~/.config/nvim/lua/plugins
touch ~/.config/nvim/init.lua
touch ~/.config/nvim/lua/core/options.lua
touch ~/.config/nvim/lua/core/keymaps.lua
```

---

## 1. Por que Neovim em VPS?

Trabalhar diretamente no servidor elimina o ciclo de _"edita local → faz push → faz pull → testa"_. Com o Neovim configurado corretamente, você tem:

- LSP completo (autocomplete, diagnósticos, go-to-definition) sem interface gráfica
- Latência zero entre edição e execução — o código roda onde está sendo editado
- Sessões persistentes com tmux: reconecta sem perder o estado mesmo após queda de conexão
- Consumo mínimo de recursos: menos de 50 MB de RAM para o editor

---

## 2. Instalação

### Neovim (versão ≥ 0.9 obrigatória)

```bash
# Ubuntu/Debian
sudo add-apt-repository ppa:neovim-ppa/stable
sudo apt update && sudo apt install neovim

# Via AppImage (sempre a versão mais recente, funciona em qualquer distro)
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
chmod +x nvim.appimage && sudo mv nvim.appimage /usr/local/bin/nvim

# Arch
sudo pacman -S neovim

# Fedora
sudo dnf install neovim
```

### Dependências

```bash
# Ferramentas base (necessárias para os plugins funcionarem)
sudo apt install git curl unzip ripgrep fd-find nodejs npm python3-pip build-essential

# Rust (necessário para o rust-analyzer)
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source ~/.cargo/env
```

---

## 3. Arquivo principal — `~/.config/nvim/init.lua`

Este é o único arquivo que o Neovim lê ao iniciar. Ele carrega todo o resto.

**Arquivo: `~/.config/nvim/init.lua`**

```lua
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

-- Carrega todos os arquivos dentro de lua/plugins/ automaticamente
lazy.setup("plugins")
```

> Ao abrir o Neovim pela primeira vez após configurar este arquivo, o lazy.nvim será instalado e todos os plugins serão baixados automaticamente.

---

## 4. Opções do editor — `~/.config/nvim/lua/core/options.lua`

**Arquivo: `~/.config/nvim/lua/core/options.lua`**

```lua
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
```

---

## 5. Atalhos de teclado — `~/.config/nvim/lua/core/keymaps.lua`

**Arquivo: `~/.config/nvim/lua/core/keymaps.lua`**

```lua
local map = vim.keymap.set
local opts = { silent = true }

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

-- Salvar e fechar
map("n", "<leader>w", ":w<CR>", opts)
map("n", "<leader>q", ":q<CR>", opts)

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
```

---

## 6. Plugins

A partir daqui, cada arquivo vai dentro de `~/.config/nvim/lua/plugins/`. O lazy.nvim carrega todos eles automaticamente — você não precisa referenciar cada um no `init.lua`.

---

### 5.1 Syntax highlighting — `lua/plugins/treesitter.lua`

O treesitter faz o Neovim entender a estrutura do código, não apenas colorir palavras-chave.

**Arquivo: `~/.config/nvim/lua/plugins/treesitter.lua`**

```lua
return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      vim.treesitter.language.register("markdown", "markdown")
      require("nvim-treesitter").setup({
        ensure_installed = {
          "rust", "c", "html", "css",
          "javascript", "typescript",
          "python", "lua", "bash",
          "toml", "json", "markdown",
        },
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },
}
```

---

### 5.2 LSP (inteligência por linguagem) — `lua/plugins/lsp.lua`

Este é o plugin mais importante. Ele conecta o Neovim aos servidores de linguagem (rust-analyzer, clangd etc.), que são os responsáveis por erros em tempo real, autocomplete, go-to-definition e mais.

**Arquivo: `~/.config/nvim/lua/plugins/lsp.lua`**

```lua
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
      local lspconfig = require("lspconfig")

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

      local map = vim.keymap.set
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Aplica a mesma configuração a todos os servidores (exceto Rust, que usa rustaceanvim)
      local servers = { "clangd", "html", "cssls", "ts_ls", "pyright" }
      for _, server in ipairs(servers) do
        lspconfig[server].setup({
          on_attach = on_attach,
          capabilities = capabilities,
        })
      end
    end,
  },
}
```

**Atalhos do LSP:**

| Atalho | Ação |
|--------|------|
| `gd` | Vai para onde a função/variável foi definida |
| `gD` | Vai para a declaração |
| `gr` | Lista todas as referências no projeto |
| `K` | Mostra documentação e tipo da variável |
| `<leader>rn` | Renomeia o símbolo em todos os arquivos |
| `<leader>ca` | Sugestões de correção automática |
| `<leader>f` | Formata o arquivo |
| `[d` / `]d` | Pula entre erros e warnings |
| `<leader>e` | Abre o detalhe do erro em float |

---

### 5.3 Autocompletar — `lua/plugins/cmp.lua`

**Arquivo: `~/.config/nvim/lua/plugins/cmp.lua`**

```lua
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
```

---

### 5.4 Busca universal — `lua/plugins/telescope.lua`

**Arquivo: `~/.config/nvim/lua/plugins/telescope.lua`**

```lua
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
```

Dentro do Telescope: `Ctrl+j/k` para navegar, `Enter` para abrir, `Ctrl+v` para abrir em split vertical.

---

### 5.5 Árvore de arquivos — `lua/plugins/nvim-tree.lua`

**Arquivo: `~/.config/nvim/lua/plugins/nvim-tree.lua`**

```lua
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
```

Dentro da árvore: `a` cria arquivo, `d` apaga, `r` renomeia, `Enter` abre.

---

### 5.6 Git integrado — `lua/plugins/git.lua`

**Arquivo: `~/.config/nvim/lua/plugins/git.lua`**

```lua
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
```

---

### 5.7 Configurações por linguagem — `lua/plugins/languages.lua`

**Arquivo: `~/.config/nvim/lua/plugins/languages.lua`**

```lua
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
```

**Dica para C:** instale o `bear` para gerar o `compile_commands.json`, que permite ao `clangd` entender os flags do seu projeto:

```bash
sudo apt install bear
bear -- make          # ou: bear -- cmake --build .
```

**Dica para Python:** o `pyright` detecta automaticamente o `.venv` na raiz. Para formatar com Black ao salvar, adicione ao final de `options.lua`:

```lua
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.py",
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})
```

---

### 5.8 Plugins de qualidade de vida — `lua/plugins/extras.lua`

**Arquivo: `~/.config/nvim/lua/plugins/extras.lua`**

```lua
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
    "ggandor/leap.nvim",
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
```

---

## 7. Sobrevivência e produtividade no Vim

### Os quatro modos

| Modo | Como entrar | Para que serve |
|------|-------------|----------------|
| Normal | `Esc` | Navegar, dar comandos. Sempre volte aqui. |
| Inserção | `i`, `a`, `o` | Digitar texto |
| Visual | `v` (caractere), `V` (linha), `Ctrl+v` (bloco) | Selecionar |
| Comando | `:` | Salvar, sair, buscar, substituir |

### Navegação

```
h j k l          ← esquerda, baixo, cima, direita
w / b            ← próxima / palavra anterior
e                ← fim da palavra atual
0 / $            ← início / fim da linha
^                ← primeiro caractere não-espaço da linha
gg / G           ← início / fim do arquivo
Ctrl+d / Ctrl+u  ← meia página abaixo / acima
Ctrl+f / Ctrl+b  ← página inteira abaixo / acima
{ / }            ← parágrafo anterior / próximo
%                ← pula entre ( ), [ ], { } correspondentes
*                ← busca a palavra sob o cursor
50G              ← vai para a linha 50
Ctrl+o / Ctrl+i  ← volta / avança no histórico de saltos
```

### Edição: verbos + movimentos

O Vim funciona como uma linguagem: `[verbo][movimento]`

```
Verbos:   d (apagar)  c (trocar)  y (copiar)  > / < (indentar)

Movimentos: w (palavra)  $ (fim da linha)  j (linha abaixo)  } (parágrafo)

Exemplos:
dw    → apaga palavra
d$    → apaga até o fim da linha
dd    → apaga linha inteira
cw    → troca palavra (apaga e entra em inserção)
ci"   → troca conteúdo entre aspas
ci(   → troca conteúdo entre parênteses
ca{   → troca conteúdo incluindo as chaves
yy    → copia linha
y3j   → copia 3 linhas abaixo
p / P → cola após / antes do cursor
u     → desfaz
Ctrl+r → refaz
```

### Busca e substituição

```
/padrão          ← busca para frente (n = próxima, N = anterior)
?padrão          ← busca para trás
:%s/velho/novo/g ← substitui em todo o arquivo
:10,20s/a/b/g    ← substitui entre linhas 10 e 20
:s/a/b/gc        ← substitui com confirmação a cada ocorrência
```

### Macros (operações repetíveis)

```
qa               ← começa a gravar macro na tecla 'a'
... ações ...
q                ← para de gravar
@a               ← executa a macro 'a'
10@a             ← executa 10 vezes
@@               ← repete a última macro executada
```

### Marcadores

```
ma               ← cria marcador 'a' na posição atual
`a               ← pula para o marcador 'a'
''               ← pula para a última posição antes de um salto
```

### Splits e abas

```
:vs arquivo      ← abre em split vertical
:sp arquivo      ← abre em split horizontal
Ctrl+h/j/k/l     ← navega entre splits (com os atalhos deste tutorial)
Ctrl+w =         ← equaliza o tamanho dos splits
:tabnew          ← nova aba
gt / gT          ← próxima / aba anterior
```

---

## 8. tmux: sessões persistentes na VPS

O tmux mantém seu ambiente vivo mesmo ao desconectar do SSH.

```bash
# Instalar
sudo apt install tmux

# Criar sessão de desenvolvimento
tmux new -s dev

# Reconectar depois de desconectar
tmux attach -t dev

# Listar sessões ativas
tmux ls
```

Layout recomendado (prefixo padrão `Ctrl+b`):

```
┌────────────────────────────┬──────────────────┐
│                            │                  │
│        Neovim              │  cargo watch /   │
│                            │  compilador      │
│                            ├──────────────────┤
│                            │  terminal livre  │
└────────────────────────────┴──────────────────┘
```

```
Ctrl+b %     ← split vertical
Ctrl+b "     ← split horizontal
Ctrl+b seta  ← navega entre painéis
Ctrl+b z     ← maximiza / restaura painel atual
Ctrl+b d     ← desconecta (sessão continua rodando em background)
Ctrl+b [     ← modo scroll (q para sair)
```

Para Rust, rode numa janela paralela:

```bash
cargo watch -x "check --message-format=short"
# ou: cargo install bacon && bacon
```

---

## 9. Diagnóstico e manutenção

```
:checkhealth        ← diagnóstico completo do Neovim e plugins
:LspInfo            ← mostra qual LSP está ativo no buffer atual
:LspLog             ← log de erros do LSP
:Mason              ← gerenciador de servidores de linguagem
:Lazy               ← gerenciador de plugins
:Lazy update        ← atualiza todos os plugins
:TSUpdate           ← atualiza os parsers do treesitter
:TSInstallInfo      ← lista status de todos os parsers instalados
:Trouble            ← painel de erros do projeto inteiro
:messages           ← histórico de mensagens e avisos do Neovim
```

### Problemas comuns

**LSP não aparece:** verifique com `:LspInfo` se o servidor está rodando. O `rust_analyzer` só funciona em projetos com `Cargo.toml`. O `pyright` espera um `pyproject.toml` ou `setup.py`. O `ts_ls` espera um `package.json`.

**Autocompletar não abre:** confirme com `:checkhealth nvim-cmp` que o `cmp_nvim_lsp` está instalado e que o `capabilities` foi passado na configuração do LSP.

**Ícones aparecem como quadradinhos:** instale uma Nerd Font no seu terminal. No servidor remoto sem interface gráfica, defina `renderer = { icons = { enable = false } }` no nvim-tree.

---

## 10. init.lua de referência completo

Para quem quer começar do zero com tudo em um só arquivo antes de separar em módulos:

**Arquivo: `~/.config/nvim/init.lua`**

```lua
-- Leader key: SEMPRE a primeira linha — antes de qualquer require ou plugin
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Opções gerais
local opt = vim.opt
opt.number = true
opt.relativenumber = true       -- números relativos (facilita d5j, y3k etc.)
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true            -- espaços em vez de tabs
opt.smartindent = true
opt.wrap = false
opt.termguicolors = true
opt.scrolloff = 8
opt.signcolumn = "yes"          -- evita o layout "pular" ao aparecer ícones
opt.updatetime = 250
opt.undofile = true             -- desfazer persistente entre sessões
opt.ignorecase = true
opt.smartcase = true
opt.splitbelow = true
opt.splitright = true
opt.clipboard = "unnamedplus"   -- clipboard compartilhado com o sistema

-- Carrega módulos separados (quando você criar os arquivos)
require("core.options")
require("core.keymaps")

-- Instala o lazy.nvim automaticamente
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

-- Proteção para a primeira abertura: avisa em vez de travar com erro
local ok, lazy = pcall(require, "lazy")
if not ok then
  print("Lazy.nvim ainda está sendo instalado. Feche e reabra o Neovim.")
  return
end

-- Carrega todos os arquivos em lua/plugins/ automaticamente
lazy.setup("plugins")
```

> Dica: `:help` seguido de qualquer comando abre a documentação completa do Neovim diretamente no editor.

---

## Referência rápida

| Categoria | Atalho | Ação |
|-----------|--------|------|
| **LSP** | `gd` | Ir para definição |
| | `gr` | Listar referências |
| | `K` | Documentação da variável |
| | `<leader>rn` | Renomear símbolo |
| | `<leader>ca` | Correção automática |
| | `<leader>f` | Formatar arquivo |
| | `[d` / `]d` | Próximo / anterior erro |
| **Busca** | `<leader>ff` | Buscar arquivo por nome |
| | `<leader>fg` | Grep no projeto inteiro |
| | `<leader>fb` | Listar buffers abertos |
| | `<leader>fd` | Listar erros do projeto |
| **Git** | `]c` / `[c` | Próximo / anterior hunk |
| | `<leader>hs` | Stage do hunk |
| | `<leader>hb` | Blame da linha |
| | `:G` | Painel Fugitive |
| **Árvore** | `<leader>t` | Abrir/fechar nvim-tree |
| **Splits** | `Ctrl+h/j/k/l` | Navegar entre splits |
| **Geral** | `<leader>w` | Salvar |
| | `<leader>q` | Fechar |
| | `Shift+h` / `Shift+l` | Buffer anterior / próximo |
