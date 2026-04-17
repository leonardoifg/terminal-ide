# terminal-ide
Configurações para IDE completa de desenvolvimento usando tmux e neovim.

## Instalação 

Para instalar este meu setup na sua máquina Linux/Mac basta clonar este repositório a partir do diretório de configuração da sua pasta pessoal (`~/.config/`) e em seguida executar o script `install.sh`.


## ⌨️ Keymaps (Usage no neovim)

Este setup de Neovim define atalhos focados em produtividade para navegação, edição e gerenciamento de buffers.

> Leader key: `<Space>`

---

### 🧭 Navegação entre splits

| Atalho     | Ação                     |
| ---------- | ------------------------ |
| `Ctrl + h` | Ir para split à esquerda |
| `Ctrl + j` | Ir para split abaixo     |
| `Ctrl + k` | Ir para split acima      |
| `Ctrl + l` | Ir para split à direita  |

---

### 🔀 Navegação entre buffers

| Atalho       | Ação                |
| ------------ | ------------------- |
| `Shift + h`  | Buffer anterior     |
| `Shift + l`  | Próximo buffer      |
| `<leader> x` | Fechar buffer atual |

---

### 🔍 Busca e rolagem

| Atalho       | Ação                              |
| ------------ | --------------------------------- |
| `Ctrl + d`   | Scroll down (centraliza cursor)   |
| `Ctrl + u`   | Scroll up (centraliza cursor)     |
| `n`          | Próximo resultado (centralizado)  |
| `N`          | Resultado anterior (centralizado) |
| `<leader> h` | Limpar highlight da busca         |

---

### ✏️ Edição

| Atalho       | Ação                             |
| ------------ | -------------------------------- |
| `J` (visual) | Mover seleção para baixo         |
| `K` (visual) | Mover seleção para cima          |
| `<` / `>`    | Indentar mantendo seleção        |
| `<leader> p` | Colar sem sobrescrever clipboard |

---

### 📋 Clipboard

| Atalho       | Ação                             |
| ------------ | -------------------------------- |
| `<leader> y` | Copiar para clipboard do sistema |

---

### ⚙️ Utilidades

| Atalho       | Ação                            |
| ------------ | ------------------------------- |
| `<leader> i` | Mostrar diagnóstico (LSP)       |
| `<leader> n` | Alternar line numbers relativos |

---

### 💾 Arquivos

| Atalho       | Ação           |
| ------------ | -------------- |
| `<leader> w` | Salvar arquivo |
| `<leader> q` | Sair           |

---

### 🖥️ Terminal

| Atalho           | Ação                     |
| ---------------- | ------------------------ |
| `<leader> tt`    | Abrir terminal integrado |
| `Esc` (terminal) | Sair do modo terminal    |

---

### 💡 Observações

* Os atalhos foram pensados para uso intensivo com teclado (sem mouse)
* Navegação entre splits evita o uso de `Ctrl + w`
* Buffers são usados no lugar de tabs para fluxo mais rápido

---

