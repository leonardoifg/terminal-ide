# terminal-ide
Configurações para IDE completa de desenvolvimento usando tmux e neovim.

## Instalação 

Para instalar este _setup_ na sua máquina Linux/Mac basta clonar este repositório a partir do diretório de configuração da sua pasta pessoal (`~/.config/`) e em seguida executar o script `install.sh` (terá que dar permissão de execução a este arquivo).

Outra possibilidade é de [baixar apenas o `install.sh`](https://raw.githubusercontent.com/leonardoifg/terminal-ide/blob/main/install.sh), dar a permissão de execução a ele, e então executá-lo, pois o mesmo já cria o diretório de configuração e baixa clona este repositório lá, além de instalar todas as dependências e deixar o _setup_ pronto.

> Esta configuração funciona apenas com Neovim 0.11 ou mais recente.

## 🧠 Vim/NeoVim (Comandos Essenciais)

O Neovim mantém os comandos clássicos do Vim. Aqui estão os mais importantes para navegação e edição.

---

### 🔁 Modos

| Modo    | Como entrar        | Descrição            |
| ------- | ------------------ | -------------------- |
| Normal  | `Esc`              | Navegação e comandos |
| Insert  | `i`, `a`, `o`, `O` | Inserir texto        |
| Visual  | `v`, `V`, `Ctrl+v` | Seleção de texto     |
| Command | `:`                | Executar comandos    |

---

### 🧭 Navegação básica

| Atalho | Ação              |
| ------ | ----------------- |
| `h`    | Esquerda          |
| `j`    | Baixo             |
| `k`    | Cima              |
| `l`    | Direita           |
| `w`    | Próxima palavra   |
| `b`    | Palavra anterior  |
| `0`    | Início da linha   |
| `$`    | Fim da linha      |
| `gg`   | Início do arquivo |
| `G`    | Fim do arquivo    |

---

### ✏️ Edição

| Atalho | Ação                     |
| ------ | ------------------------ |
| `i`    | Inserir antes do cursor  |
| `a`    | Inserir depois do cursor |
| `o`    | Nova linha abaixo        |
| `O`    | Nova linha acima         |
| `x`    | Deletar caractere        |
| `dd`   | Deletar linha            |
| `yy`   | Copiar linha             |
| `p`    | Colar depois             |
| `P`    | Colar antes              |

---

### ✂️ Seleção (Visual Mode)

| Atalho | Ação                  |
| ------ | --------------------- |
| `v`    | Seleção por caractere |
| `V`    | Seleção por linha     |
| `y`    | Copiar seleção        |
| `d`    | Deletar seleção       |

---

### 🔍 Busca

| Atalho   | Ação                |
| -------- | ------------------- |
| `/texto` | Buscar para frente  |
| `?texto` | Buscar para trás    |
| `n`      | Próxima ocorrência  |
| `N`      | Ocorrência anterior |

---

### 🔄 Undo / Redo

| Atalho     | Ação     |
| ---------- | -------- |
| `u`        | Desfazer |
| `Ctrl + r` | Refazer  |

---

### 💾 Comandos úteis

| Comando | Ação            |
| ------- | --------------- |
| `:w`    | Salvar          |
| `:q`    | Sair            |
| `:wq`   | Salvar e sair   |
| `:q!`   | Sair sem salvar |

---

### ⚡ Dicas rápidas

* Combine comandos:

  * `d + w` → deleta palavra (`dw`)
  * `c + w` → troca palavra (`cw`)
* Números funcionam como multiplicador:

  * `5j` → desce 5 linhas
  * `3dd` → deleta 3 linhas

---


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

| Atalho       | Ação                                   |
| ------------ | -------------------------------------- |
| `J` (visual) | Mover seleção para baixo               |
| `K` (visual) | Mover seleção para cima                |
| `<`          | Remover indentação (mantendo seleção)  |
| `>`          | Inserir indentação (mantendo seleção)  |
| `<leader> p` | Colar sem sobrescrever clipboard       |

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

| Atalho            | Ação                     |
| ----------------- | ------------------------ |
| `<leader> tt`     | Abrir terminal integrado |
| `i` (terminal)    | Entrar no modo terminal  |
| `Esc` (normal)    | Sair do modo terminal    |
| `exit` (terminal) | Fechar o terminal        |

---

### 💡 Observações

* Os atalhos foram pensados para uso intensivo com teclado (sem mouse)
* Navegação entre splits evita o uso de `Ctrl + w`
* Buffers são usados no lugar de tabs para fluxo mais rápido

---

