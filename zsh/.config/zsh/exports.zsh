export EDITOR="nvim"
export TERMINAL="wezterm"
export PATH="$HOME/.local/bin":$PATH
export PATH="$HOME/.docker/bin":$PATH
export PATH="$HOME/fvm/default/bin":$PATH
export PYENV_ROOT="$HOME/.pyenv"

export CHROME_EXECUTABLE="/Applications/Arc.app/Contents/MacOS/Arc"

[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"

eval "$(pyenv init -)"
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"