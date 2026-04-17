# Aliases úteis
alias ll="ls -lh"
alias la="ls -lah"
if [[ "$OSTYPE" == "darwin"* ]]; then
  alias ls="ls -G"
else
  alias ls="ls --color=auto"
fi
