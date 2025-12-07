# .bashrc

set -o vi

export EDITOR=nvim
export VISUAL=nvim

alias vpnup='sudo wg-quick up ~/Documents/config_files/RSCI-NS-HP-Debi.conf'
alias vpndown='sudo wg-quick down ~/Documents/config_files/RSCI-NS-HP-Debi.conf'

alias vim='nvim'
alias ls='ls --color=auto'
alias xi='sudo xbps-install'
alias xu='sudo xbps-update'
alias laydvo='sudo loadkeys dvorak'
alias layus='sudo loadkeys us'
alias dv='setxkbmap -layout us -variant dvorak'
alias qw='setxkbmap -layout us -variant qwerty'
alias dwm='cd ~/.config/dwm-btw'

#alias tmuxvim='tmux new-session -d "vim" \; attach'
alias bashdoc='cd /usr/share/doc/bash && ls'
#alias pbcopy='xsel --clipboard --input'

alias dwmrc='cd ~/.config/dwm-btw ; vim config.h '

alias bashrc='vim ~/.bashrc && source ~/.bashrc'

alias crun='~/.config/dotfiles/jrun-bash-script/runc.sh'
alias jrun='~/.config/dotfiles/jrun-bash-script/runjava.sh'
alias prun='python3'

alias rc='ranger_cd'

alias beepoff="bind 'set bell-style none'"
alias beepon="bind 'set bell-style audible'"

alias tmuxks="tmux kill-server"

alias sound="alsamixer"

bind 'TAB:menu-complete'

pbcopy() {
  if [ "$1" = "-c" ]; then
    xsel --clipboard --clear
    xsel --primary --clear
    xsel --secondary --clear
  elif [ -z "$1" ]; then 
    xsel -i --clipboard 
  else 
    echo "wrong command: you meant pbcopy or pbcopy -c"
  fi
}

PS1='\[\033[1;36m\]\u\[\033[1;31m\]@\[\033[1;32m\]\h:\[\033[1;35m\]\w\[\033[1;31m\]\$\[\033[0m\] '


ranger_cd() {
    # Temporary file to store the directory path
    local tempfile="$(mktemp)"
    
    # Launch ranger with --choosedir option
    ranger --choosedir="$tempfile" "$@"
    
    # If a directory is selected, change to that directory
    if [ -f "$tempfile" ] && [ -n "$(cat "$tempfile")" ]; then
        cd "$(cat "$tempfile")"
    fi
    
    # Clean up
    rm -f "$tempfile"
}
