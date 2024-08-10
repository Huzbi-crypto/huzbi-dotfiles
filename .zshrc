eval "$(starship init zsh)"

HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups
unsetopt beep
# The following lines were added by compinstall
zstyle :compinstall filename '/home/xhuzbi/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# Load completions
autoload -Uz compinit && compinit

zinit cdreplay -q

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# ---- FZF -----

# Set up fzf key bindings and fuzzy completion
eval "$(fzf --zsh)"

# -- Use fd instead of fzf --

export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

# Use fd (https://github.com/sharkdp/fd) for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --exclude .git . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type=d --hidden --exclude .git . "$1"
}

show_file_or_dir_preview="if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi"

export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

# Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of the command.
# - You should make sure to pass the rest of the arguments to fzf.
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
    export|unset) fzf --preview "eval 'echo ${}'"         "$@" ;;
    ssh)          fzf --preview 'dig {}'                   "$@" ;;
    *)            fzf --preview "$show_file_or_dir_preview" "$@" ;;
  esac
}


# ----- Bat (better cat) -----

export BAT_THEME=ansi
alias cat="bat"


# ----- Eza (Better ls) -----
alias ls="eza --color=always --long --group-directories-first --all --git --no-filesize --icons=always --no-time --no-user --no-permissions"
alias ll="eza --color=always --long --all --group-directories-first --git --no-filesize --icons=always --no-time --no-user --tree --level=2"
alias l="eza --color=always --long --all --group-directories-first --git --icons=always"


# ---- Zoxide (better cd) ----
eval "$(zoxide init zsh)"
alias cd="z"


# ----- Atuin (Better history) -----
eval "$(atuin init zsh)"

# ---------- Keybindings ----------
bindkey -e

# ---------- Aliases set by me :) ----------
alias nvsh="nvim ~/.zshrc"
alias src="source ~/.zshrc"
#alias mad="sudo mount /dev/sda1 /mnt/adata"
alias upref="sudo reflector --verbose --latest 10 --protocol https --sort rate --save /etc/pacmand.d/mirrorlist"
alias upg="yay -Syu"
alias pacin="sudo pacman -S"
alias yain="yay -S"
alias pacr="sudo pacman -Rns"
alias yar="yay -Rns"
alias cpac="sudo pacman -Scc"
alias cyay="yay -Sc" 
alias cls="clear"
alias q="exit"
alias top="btop" 
alias upfonts="fc-cache -fv"
