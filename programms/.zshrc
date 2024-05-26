ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "${ZINIT_HOME}/zinit.zsh"

zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit ice depth=1; zinit light jeffreytse/zsh-vi-mode
zinit light Aloxaf/fzf-tab
zinit wait lucid for MichaelAquilina/zsh-autoswitch-virtualenv

zinit snippet OMZP::colorize
zinit snippet OMZP::colored-man-pages
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::oc
zinit snippet OMZP::gnu-utils
zinit snippet OMZP::command-not-found

# ZSH VI MODE
export KEYTIMEOUT=1
ZVM_INIT_MODE=sourcing
ZVM_READKEY_ENGINE=$ZVM_READKEY_ENGINE_NEX
ZVM_VI_INSERT_ESCAPE_BINDKEY=jj
ZVM_VI_HIGHLIGHT_FOREGROUND=#BAC2DE
ZVM_VI_HIGHLIGHT_BACKGROUND=#2F2E3E

if [[ -f "$HOME/.zcompdump" ]]; then
  rm -f "$HOME/.zcompdump"
  echo "Old zcompdump removed. New zcompdump put on $HOME/.cache/zcompdump-${ZSH_VERSION}"
fi

autoload -Uz compinit && compinit -d "$HOME/.cache/zcompdump-${ZSH_VERSION}"

bindkey "^;" autocomplete
bindkey "^[OA" history-beginning-search-backward
bindkey "^[OB" history-beginning-search-forward
bindkey -M vicmd "k" history-beginning-search-backward
bindkey -M vicmd "j" history-beginning-search-forward
bindkey -M vicmd "k" history-beginning-search-backward
bindkey -M vicmd "j" history-beginning-search-forward
bindkey -M vicmd '?' history-incremental-search-backward
bindkey -M vicmd '/' history-incremental-search-forward

zinit cdreplay -q

HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'lsd --color=always $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'lsd --color=always $realpath'

if [[ -z $DISPLAY && $(tty) == /dev/tty1 ]]; then
  exec bash /home/restranger/.config/hypr/scripts/nvidia_fix
fi

if [[ -d "$HOME/.local/bin/platform-tools/" ]] ; then
    PATH="$HOME/.local/bin/platform-tools/:$PATH"
fi

function yy() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# REPLASES
alias vi="nvim"
alias lg="lazygit"
alias ls="lsd --color=auto"
alias la="lsd --color=auto -a"
alias lt="lsd --color=auto --tree"
alias cat="bat --style=grid"
alias tmux="tmux -u"
alias uwufetch="uwufetch -i"
alias mkvenv="python -m venv .venv"

alias :q="exit"
alias Жй="exit"
alias :Q="exit"
alias ЖЙ="exit"

# USFULL COMMANDS
alias find.trash="sudo find / | grep -vE '/home/restranger/.cache|/home/restranger/.icons|/root/.cache|/root/.icons|/var/log|/tmp' | grep"
alias ssh.open="sudo systemctl start zerotier-one.service && sudo systemctl start sshd.service"

# SCRIPTS
alias gentoo-chroot="~/.config/scripts/GentooChroot"
if [ $TERM = "xterm-kitty" ]; then 
  alias neofetch="~/.config/neofetch/random_img.sh"
fi
alias shell-color-scripts="~/.config/scripts/shell-color-scripts/random_script.sh"
alias rezsh_remove_folders="sudo rm -rf $HOME/.local/share/zinit/ && echo \"\nZSH folders removed\n\""
alias rezsh_reload_config="source ~/.zshrc"
alias zcr="source ~/.zshrc"

export PATH=$PATH:/home/restranger/.spicetify

eval "$(fzf --zsh)"
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"