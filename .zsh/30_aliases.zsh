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
alias -- -='cd -'
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
alias -g L='| less'
alias -g M='| more'
alias -g LL='2>&1 | less'
alias -g CA='2>&1 | cat -A'
alias -g NE='2> /dev/null'
alias -g NUL='> /dev/null 2>&1'

alias dud='du -d 1 -h'
alias duf='du -sh *'
alias fd='find . -type d -name'
alias ff='find . -type f -name'

alias h='history'
alias hgrep='fc -El 0 | grep'
alias help='man'
alias p='ps -f'
alias sortnr='sort -n -r'
alias unexport='unset'

# open current directory in Finder
alias f='open .'

# vim
alias vi='vim'

# mru
mru() {
    local -a f1 f2 f2_backup
    f1=(~/.cache/neomru/file(N))
    f2=($DOTPATH/**/*~$DOTPATH/*\.git/**(.N))
    if [[ $#f1 -eq 0 || $#f2 -eq 0 ]]; then
        echo "There is no available MRU Vim plugins" >&2
        return 1
    fi

    local cmd q k res
    local line ok make_dir i arr
    local get_styles styles style
    while : ${make_dir:=0}; ok=("${ok[@]:-dummy_$RANDOM}"); cmd="$(
        { if (( $#f1 > 0 )); then cat <$f1; fi; echo "${(F)f2}"; } \
            | while read line; do [ -e "$line" ] && echo "$line"; done \
            | while read line; do [ "$make_dir" -eq 1 ] && echo "${line:h}/" || echo "$line"; done \
            | awk '!a[$0]++' \
            | perl -pe 's/^(\/.*\/)(.*)$/\033[34m$1\033[m$2/' \
            | fzf --ansi --multi --query="$@" \
            --no-sort --prompt="[MRU] " \
            --print-query --expect=ctrl-v,ctrl-x,ctrl-l,ctrl-q,ctrl-r,"?",ctrl-z,ctrl-y
            )"; do
        q="$(head -1 <<< "$cmd")"
        k="$(head -2 <<< "$cmd" | tail -1)"
        res="$(sed '1,2d;/^$/d' <<< "$cmd")"
        #[ -z "$res" ] && continue
        case "$k" in
            "?")
                cat <<HELP > /dev/tty
usage: vim_mru_files
    list up most recently files
keybind:
  ctrl-q  output files and quit
  ctrl-l  less files under the cursor
  ctrl-v  vim files under the cursor
  ctrl-r  change view type
  ctrl-x  remove files (two-step)
HELP
                return 1
                ;;
            ctrl-y)
                # Reset ctrl-z
                f1=(~/.cache/neomru/file(N))
                f2=($f2_backup)
                ;;
            ctrl-z)
                # Enter to the directroy (or parent directory of the file) under the cursor
                f2_backup=($f2)
                make_dir=0
                if [[ -d $res ]]; then
                    f1=()
                    f2=(${res}*(N))
                else
                    f1=()
                    f2=(${res:h}/*(N))
                fi
                ;;
            ctrl-r)
                # show up the parent directories
                if [ $make_dir -eq 1 ]; then
                    make_dir=0
                else
                    make_dir=1
                fi
                continue
                ;;
            ctrl-l)
                # less
                export LESS='-R -f -i -P ?f%f:(stdin). ?lb%lb?L/%L.. [?eEOF:?pb%pb\%..]'
                arr=("${(@f)res}")
                if [[ -d ${arr[1]} ]]; then
                    ls -l "${(@f)res}" < /dev/tty | less > /dev/tty
                else
                    if has "pygmentize"; then
                        get_styles="from pygments.styles import get_all_styles
                        styles = list(get_all_styles())
                        print('\n'.join(styles))"
                        styles=( $(sed -e 's/^  *//g' <<<"$get_styles" | python) )
                        style=${${(M)styles:#solarized}:-default}
                        export LESSOPEN="| pygmentize -O style=$style -f console256 -g %s"
                    fi
                    less "${(@f)res}" < /dev/tty > /dev/tty
                fi
                ;;
            ctrl-x)
                # remove (2-steps)
                if [[ ${(j: :)ok} == ${(j: :)${(@f)res}} ]]; then
                    eval '${${${(M)${+commands[gomi]}#1}:+gomi}:-rm} "${(@f)res}" 2>/dev/null'
                    ok=()
                else
                    ok=("${(@f)res}")
                fi
                ;;
            ctrl-v)
                # vim
                vim -p "${(@f)res}" < /dev/tty > /dev/tty
                ;;
            ctrl-q)
                # quit with echo
                echo "$res" < /dev/tty > /dev/tty
                return $status
                ;;
            *)
                echo "${(@f)res}"
                break
                ;;
        esac
    done
}
alias -g FILE='$(mru)'

destination_directories() {
    local -a d
    if [[ -f $ENHANCD_LOG ]]; then
        d=("${(@f)"$(<$ENHANCD_LOG)"}")
    else
        d=(
        $DOTPATH/**/*~$DOTPATH/*\.git/**(N-/)
        $HOME/Dropbox(N-/)
        $HOME
        $OLDPWD
        $($DOTPATH/bin/tfp(N))
        )
    fi
    if [[ $#d -eq 0 ]]; then
        echo "There is no available directory" >&2
        return 1
    fi

    local cmd q k res
    local line make_dir
    while : ${make_dir:=0}; cmd="$(
        echo "${(F)d}" \
            | while read line; do echo "${line:F:$make_dir:h}"; done \
            | reverse | awk '!a[$0]++' | reverse \
            | perl -pe 's/^(\/.*)$/\033[34m$1\033[m/' \
            | fzf --ansi --multi --tac --query="$q" \
            --no-sort --exit-0 --prompt="[DIR] " \
            --print-query --expect=ctrl-r,ctrl-y,ctrl-q \
            )"; do
        q="$(head -1 <<< "$cmd")"
        k="$(head -2 <<< "$cmd" | tail -1)"
        res="$(sed '1,2d;/^$/d' <<< "$cmd")"
        [ -z "$res" ] && continue
        case "$k" in
            ctrl-y)
                let make_dir--
                continue
                ;;
            ctrl-r)
                let make_dir++
                continue
                ;;
            ctrl-q)
                echo "${(@f)res}" >/dev/tty
                break
                ;;
            *)
                echo "${(@f)res}"
                break
                ;;
        esac
    done
}
alias -g DIR='$(destination_directories)'
