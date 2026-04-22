# Tutorial Git via Linha de Comando

O Git é um sistema de controle de versão distribuído que rastreia mudanças no código-fonte durante o desenvolvimento de software. Este tutorial usa os comandos modernos introduzidos no Git 2.23+.

---

## 1. Configuração Inicial (Uma única vez por máquina)

Antes de começar, configure seu nome de usuário e e-mail. Essas informações serão anexadas aos seus commits.

```bash
git config --global user.name "Seu Nome Completo"
git config --global user.email "seu.email@example.com"
```

- `--global`: Aplica a configuração a todos os seus repositórios no sistema.

Para verificar todas as configurações ativas:

```bash
git config --list
```

---

## 2. Iniciar um Repositório Git

### a) Iniciar um Novo Repositório

Dentro de uma pasta de projeto existente que você deseja versionar:

```bash
cd /caminho/para/seu/projeto
git init
```

- `git init`: Cria um repositório Git vazio na pasta atual, com uma pasta oculta `.git/` que armazena todo o histórico.

### b) Clonar um Repositório Existente

Para baixar uma cópia de um repositório já existente (GitHub, GitLab, Bitbucket etc.):

```bash
git clone https://github.com/usuario/meu-projeto.git
```

Isso cria uma nova pasta com o nome do repositório e copia todo o histórico. Você já estará na branch principal (geralmente `main` ou `master`).

---

## 3. Fluxo de Trabalho Básico: Adicionar, Commitar, Enviar

O fluxo padrão envolve três estágios: **Working Directory** → **Staging Area** → **Repositório Local**.

### a) Verificar o status

```bash
git status
```

Mostra quais arquivos foram modificados, quais estão na área de staging e quais não estão sendo rastreados.

### b) Adicionar arquivos para staging

```bash
git add nome_do_arquivo   # adiciona um arquivo específico
git add .                  # adiciona todas as mudanças no diretório atual
git add -p                 # modo interativo: revisa cada trecho antes de adicionar
```

### c) Criar um commit

```bash
git commit -m "mensagem descritiva do commit"
```

> **Boa prática:** Use o imperativo na mensagem — "adiciona validação de formulário", não "adicionei" ou "adicionando".

**Atalho para arquivos já rastreados:**

```bash
git commit -am "mensagem do commit"
```

- `-a`: Faz o stage automático de todos os arquivos já rastreados. **Não inclui arquivos novos** — use `git add .` para isso.

---

## 4. Sincronizar com Repositório Remoto

### a) Enviar mudanças (Push)

```bash
git push origin main
```

### b) Baixar e integrar mudanças (Pull)

```bash
git pull origin main
```

`git pull` é um `git fetch` + `git merge`. Para evitar commits de merge desnecessários, prefira:

```bash
git pull --rebase origin main
```

---

## 5. Gerenciamento de Branches

A partir do Git 2.23, `git switch` substitui `git checkout` para navegar entre branches, com comportamento mais claro e seguro.

### a) Listar branches

```bash
git branch        # lista branches locais
git branch -a     # lista branches locais e remotas
```

### b) Criar uma nova branch

```bash
git branch nome-da-nova-branch
```

### c) Trocar de branch

```bash
git switch nome-da-branch
```

> Substitui o antigo `git checkout nome-da-branch`. O `checkout` ainda funciona, mas `switch` é mais explícito.

### d) Criar e trocar para uma nova branch (atalho)

```bash
git switch -c nome-da-nova-branch
```

> Substitui o antigo `git checkout -b nome-da-nova-branch`.

### e) Mesclar uma branch (Merge)

1. Mude para a branch que vai **receber** as mudanças:
   ```bash
   git switch main
   ```
2. Mescle a outra branch na atual:
   ```bash
   git merge minha-nova-feature
   ```

Pode ser necessário resolver conflitos se houver mudanças em linhas idênticas.

### f) Apagar uma branch

```bash
git branch -d nome-da-branch    # só apaga se já foi mesclada
git branch -D nome-da-branch    # força a exclusão (cuidado: pode perder trabalho)

git push origin --delete nome-da-branch   # apaga a branch no repositório remoto
```

---

## 6. Visualizando o Histórico

```bash
git log                              # histórico completo (ver hash do commit)
git log --oneline                    # uma linha por commit
git log --graph --oneline --decorate # histórico com gráfico de branches
git show hash_do_commit              # Mostra o que mudou no commit em questão
git cherry-pick -n hash_do_commit    # Merge do commit 
```
1. O `git cherry-pick` é útil para fazer um merge de um commit específico, muito útil para casos de branchs diferentes que fazem uma correção e deseja replicar a correção em versões futuras com um merge apenas dos arquivos que foram corrigidos (é importante que os arquivos não tenham sido edidados no branch que receberá o merge, senão tudo que foi feito será perdido porque traz exatamente o arquivo do referido commit).

---

## 7. Desfazendo Mudanças

### a) Descartar mudanças no working directory (antes de `git add`)

```bash
git restore nome_do_arquivo   # reverte um arquivo para o último commit
git restore .                  # descarta todas as mudanças não staged
```

> Substitui o antigo `git checkout -- arquivo`. **Atenção: operação irreversível.**

### b) Remover arquivo da área de staging (após `git add`, antes de `git commit`)

```bash
git restore --staged nome_do_arquivo   # remove do staging, mantém as mudanças
git restore --staged .                  # remove todos os arquivos do staging
```

> Substitui o antigo `git reset nome_do_arquivo`.

### c) Desfazer o último commit (mantendo as mudanças)

```bash
git reset HEAD~1
```

Move o `HEAD` um commit para trás. As mudanças do commit desfeito ficam no working directory.

### d) Reverter um commit (sem reescrever o histórico)

```bash
git revert hash_do_commit
```

Cria um novo commit que desfaz as mudanças do commit indicado. Ideal para desfazer commits já enviados ao repositório remoto.

---

## 8. Ignorar Arquivos

Crie um arquivo `.gitignore` na raiz do repositório. Exemplo para projetos Django:

```
# bytecode Python
*.pyc
__pycache__/

# variáveis de ambiente
.env

# banco de dados SQLite
db.sqlite3

# arquivos estáticos coletados
/media/
/static_root/

# ambientes virtuais
/venv/
/env/

# configurações de IDE
.vscode/
.idea/

# logs
*.log
```

> **Dica:** Use [gitignore.io](https://gitignore.io) para gerar um `.gitignore` personalizado por linguagem, framework e IDE.
