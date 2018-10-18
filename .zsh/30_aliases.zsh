# common aliases
alias sudo='sudo '
if is_macos; then
    alias sudo="${ZSH_VERSION:+nocorrect} sudo "
fi

# For mac, aliases
if is_macos; then
    has "qlmanage" && alias ql='qlmanage -p "$@" >&/dev/null'
    alias gvim="open -a MacVim"
fi

if has 'git'; then
    alias gst='git status'
	alias gac='git add -A && git_commit_automatically'
fi

if has 'richpager'; then
    alias cl='richpager'
fi

if (( $+commands[gls] )); then
    alias ls='gls -F --color --group-directories-first'
elif (( $+commands[ls] )); then
    if is_macos; then
        alias ls='ls -GF'
    else
    alias ls='ls -F --color'
    fi
fi

# Common aliases
alias ..='cd ..'
alias ld='ls -ld'          # Show info about the directory
alias lla='ls -lAF'        # Show hidden all files
alias ll='ls -lF'          # Show long file information
alias la='ls -AF'          # Show hidden files
alias lx='ls -lXB'         # Sort by extension
alias lk='ls -lSr'         # Sort by size, biggest last
alias lc='ls -ltcr'        # Sort by and show change time, most recent last
alias lu='ls -ltur'        # Sort by and show access time, most recent last
alias lt='ls -ltr'         # Sort by date, most recent last
alias lr='ls -lR'          # Recursive ls

alias cp="${ZSH_VERSION:+nocorrect} cp -i"
alias mv="${ZSH_VERSION:+nocorrect} mv -i"
alias rm="${ZSH_VERSION:+nocorrect} rm -i" 
alias mkdir="${ZSH_VERSION:+nocorrect} mkdir"
 
alias grep='grep --color'
alias sgrep='grep -R -n -H -C 5 --exclude-dir={.git,.svn,CVS} '

alias t='tail -f'

# Command line head / tail shortcuts
alias -g H='| head'
alias -g T='| tail'
alias -g G='| grep'
alias -g L="| less"
alias -g M="| more"
alias -g LL="2>&1 | less"
alias -g CA="2>&1 | cat -A"
alias -g NE="2> /dev/null"
alias -g NUL="> /dev/null 2>&1"

alias dud='du -d 1 -h'
alias duf='du -sh *'
alias fd='find . -type d -name'
alias ff='find . -type f -name'

alias h='history'
alias hgrep="fc -El 0 | grep"
alias help='man'
alias p='ps -f'
alias sortnr='sort -n -r'
alias unexport='unset'

# open current directory in Finder
alias f='open .' 

# vim
alias vi='vim'
