source_if_exists () {
    if test -r "$1"; then
        source "$1"
    fi
}

source_if_exists ~/.config/zsh/aliases.zsh
source_if_exists ~/.config/zsh/exports.zsh
source_if_exists ~/.fzf.zsh

source_if_exists $HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source_if_exists $HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source_if_exists $HOMEBREW_PREFIX/share/zsh-history-substring-search/zsh-history-substring-search.zsh

precmd() {
    source ~/.config/zsh/aliases.zsh
    source ~/.config/zsh/exports.zsh
}