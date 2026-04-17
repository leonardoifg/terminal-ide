# Dicas Essenciais para Produtividade com Tmux

O Tmux é um multiplexador de terminal poderoso, permitindo que você gerencie múltiplas sessões, janelas e painéis em um único terminal. Ele é indispensável para desenvolvedores, oferecendo persistência de sessão e um ambiente de trabalho organizado.

---

## I. Fundamentos do Tmux

O Tmux opera com uma hierarquia: **Sessões** > **Janelas** > **Painéis**.

* **Sessão:** Um ambiente de trabalho persistente. Você pode "desanexar" (detach) uma sessão e voltar a ela mais tarde, mesmo após fechar seu terminal ou perder a conexão SSH.
* **Janela:** Abas dentro de uma sessão, úteis para diferentes tarefas (ex: uma para o editor, outra para o servidor, outra para o shell).
* **Painel:** Divisões de uma janela, permitindo ver várias coisas ao mesmo tempo (ex: editor de código em um painel, logs do servidor em outro).

### Comandos Básicos (Dentro do Terminal)

* `tmux new -s [nome_da_sessao]`: Inicia uma nova sessão com um nome.
* `tmux attach -t [nome_da_sessao]`: Volta para uma sessão existente.
* `tmux ls`: Lista todas as sessões ativas.
* `tmux kill-session -t [nome_da_sessao]`: Mata uma sessão específica.
* `tmux kill-server`: Mata todas as sessões e o servidor tmux (use com cautela).

---

## II. O Prefixo do Tmux

Todos os comandos de controle dentro de uma sessão tmux são acionados com uma combinação de teclas chamada **prefixo**.

* **Padrão:** `Ctrl+b`
* **Alternativa Comum:** `Ctrl+a` (muitos usuários preferem por ser mais fácil de alcançar).

    *Para mudar o prefixo para `Ctrl+a`, adicione ao seu `~/.tmux.conf` (e recarregue):*
    ```tmux
    # Mudar o prefixo padrão de Ctrl+b para Ctrl+a
    unbind C-b
    set-option -g prefix C-a
    bind-key C-a send-prefix
    ```

---

## III. Comandos Essenciais (Prefixo + Tecla)

Após pressionar o prefixo (`Ctrl+b` ou `Ctrl+a`), use as seguintes teclas:

### Gerenciamento de Janelas

* `c`: Criar uma nova janela.
* `p`: Ir para a janela anterior.
* `n`: Ir para a próxima janela.
* `[número]`: Ir para a janela pelo número (ex: `prefixo + 0` vai para a primeira janela).
* `,`: Renomear a janela atual.
* `w`: Listar todas as janelas (e selecionar com as setas).

### Gerenciamento de Painéis

* `%`: Dividir o painel verticalmente.
* `"`: Dividir o painel horizontalmente.
* `setas do teclado`: Mover-se entre os painéis.
* `z`: Alternar zoom do painel atual (ocupa a janela inteira). Pressione `z` novamente para retornar.
* `q`: Mostrar os números dos painéis.
* `x`: Fechar o painel atual (requer confirmação).
* `{`: Mover o painel atual para a esquerda.
* `}`: Mover o painel atual para a direita.
* `espaço`: Alternar entre layouts de painel predefinidos.

### Gerenciamento de Sessões

* `d`: Desanexar (detach) a sessão atual. Você pode voltar a ela com `tmux attach`.
* `$`: Renomear a sessão atual.
* `s`: Listar as sessões (e selecionar com as setas).

---

## IV. Habilitando e Usando o Scroll (Modo de Cópia)

O Tmux tem seu próprio modo de cópia para navegar no histórico do terminal.

### Como Usar

1.  **Entrar no Modo de Cópia:** Pressione `[prefixo] + [` (colchete esquerdo).
    * O cursor se moverá para o histórico e você poderá navegar.
2.  **Navegar (dentro do Modo de Cópia):**
    * **Setas do teclado:** Movem o cursor linha por linha.
    * **`Page Up` / `Page Down`:** Rolam a tela.
    * `?`: Buscar para cima.
    * `/`: Buscar para baixo.
3.  **Sair do Modo de Cópia:** Pressione `q` ou `Esc`.

### Configurações Essenciais para `~/.tmux.conf` (Scroll e Mouse)

Adicione estas linhas ao seu arquivo `~/.tmux.conf` para uma experiência de scroll mais fluida:

```tmux
# --- Habilitar suporte ao mouse ---
# Permite scroll com a roda do mouse, redimensionar painéis,
# e alternar janelas/painéis clicando.
set -g mouse on

# --- Configurar keybindings do modo de cópia (opcional, mas recomendado) ---
# Define os keybindings do modo de cópia para o estilo Vim (muito comum)
set-window-option -g mode-keys vi

# --- Copiar para a Área de Transferência do Sistema (System Clipboard) ---
# Para que o texto copiado no tmux vá para a área de transferência do seu SO.
# Instale 'xclip' no Linux (sudo apt install xclip) ou use 'pbcopy' no macOS.

# Para Linux (com xclip)
bind-key -T copy-mode-vi 'y' send-keys -X copy-pipe-and-cancel "xclip -in -selection clipboard"
bind-key -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel "xclip -in -selection clipboard"

# Para macOS (descomente e use se estiver no macOS)
# bind-key -T copy-mode-vi 'y' send-keys -X copy-pipe-and-cancel "pbcopy"
# bind-key -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel "pbcopy"
```

Como Aplicar as Mudanças no `~/.tmux.conf`:

1. Salve o arquivo ~/.tmux.conf.
1. Recarregue a configuração do tmux:
- Se você já está dentro de uma sessão tmux: Pressione seu prefixo (ex: Ctrl+b), digite `:source-file ~/.tmux.conf` e pressione Enter.
- Ou, saia de todas as sessões (tmux kill-server) e inicie uma nova.

