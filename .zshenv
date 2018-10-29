typeset -gx -U path
path=( \
    /usr/local/bin(N-/) \
    ~/bin(N-/) \
    ~/.zplug/bin(N-/) \
    ~/.tmux/bin(N-/) \
    "$path[@]" \
    )

# NOTE: set fpath before compinit
typeset -gx -U fpath
fpath=( \
    ~/.zsh/Completion(N-/) \
    ~/.zsh/functions(N-/) \
    ~/.zsh/plugins/zsh-completions(N-/) \
    /usr/local/share/zsh/site-functions(N-/) \
    $fpath \
    )

# autoload
autoload -Uz run-help
autoload -Uz add-zsh-hook
autoload -Uz colors && colors
autoload -Uz compinit && compinit -u
autoload -Uz is-at-least

# LANGUAGE must be set by en_US
export LANGUAGE="en_US.UTF-8"
export LANG="${LANGUAGE}"
export LC_ALL="${LANGUAGE}"
export LC_CTYPE="${LANGUAGE}"

# Editor
export EDITOR=vim
export CVSEDITOR="${EDITOR}"
export SVN_EDITOR="${EDITOR}"
export GIT_EDITOR="${EDITOR}"

# Pager
export PAGER=less
# Less status line
export LESS='-R -f -X -i -P ?f%f:(stdin). ?lb%lb?L/%L.. [?eEOF:?pb%pb\%..]'
export LESSCHARSET='utf-8'

# LESS man page colors (makes Man pages more readable).
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[00;44;37m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

# ls command colors
export LSCOLORS=exfxcxdxbxegedabagacad
export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'

setopt no_global_rcs
# Add ~/bin to PATH
export PATH=~/bin:"$PATH"

# declare the environment variables
export CORRECT_IGNORE='_*'
export CORRECT_IGNORE_FILE='.*'

export WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'
export WORDCHARS='*?.[]~&;!#$%^(){}<>'

# History
# History file
export HISTFILE=~/.zsh_history
# History size in memory
export HISTSIZE=10000
# The number of histsize
export SAVEHIST=1000000
# The size of asking history
export LISTMAX=50
# Do not add in root
if [[ $UID == 0 ]]; then
    unset HISTFILE
    export SAVEHIST=0
fi

# available $INTERACTIVE_FILTER
export INTERACTIVE_FILTER="fzf"
export FZF_DEFAULT_OPTS="
--height 40% --reverse --border --cycle
--bind 'ctrl-r:toggle-sort'
--color dark,hl:33,hl+:37,fg:-1,fg+:254,bg:-1,bg+:166
--color info:254,prompt:37,spinner:108,pointer:235,marker:235
"

export DOTPATH=${0:A:h}

# # adb
# export PATH=$PATH:/Users/k-mituys/Library/Android/sdk/platform-tools
#
# # OMNeT-5.2
# export PATH=$PATH:$HOME/omnetpp-5.2/bin:$HOME/omnetpp-5.2/tools/macosx/bin
# export QT_PLUGIN_PATH=$HOME/omnetpp-5.2/tools/macosx/plugins
#
# # java
# export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_151.jdk/Contents/Home
# PATH=$PATH:${JAVA_HOME}/bin:${PLAY_HOME}
#
# # pyenv
# export PYENV_ROOT=$HOME/.pyenv
# export PATH=$PYENV_ROOT/bin:$PATH
# eval "$(pyenv init - --no-rehash)"
# eval "$(pyenv virtualenv-init - --no-rehash)"

function prompt_steeef_precmd {
  # Check for untracked files or updated submodules since vcs_info does not.
  if [[ -n $(git ls-files --other --exclude-standard 2> /dev/null) ]]; then
    branch_format="(${_prompt_steeef_colors[1]}%b%f%u%c${_prompt_steeef_colors[4]}●%f)"
  else
    branch_format="(${_prompt_steeef_colors[1]}%b%f%u%c)"
  fi

  zstyle ':vcs_info:*:prompt:*' formats "${branch_format}"

  vcs_info 'prompt'

  if (( $+functions[python-info] )); then
    python-info
  fi
}

function prompt_steeef_setup {
  setopt LOCAL_OPTIONS
  unsetopt XTRACE KSH_ARRAYS
  prompt_opts=(cr percent sp subst)

  # Add hook for calling vcs_info before each command.
  add-zsh-hook precmd prompt_steeef_precmd

  # Use extended color pallete if available.
  if [[ $TERM = *256color* || $TERM = *rxvt* ]]; then
    _prompt_steeef_colors=(
      "%F{81}"  # Turquoise
      "%F{166}" # Orange
      "%F{135}" # Purple
      "%F{161}" # Hotpink
      "%F{118}" # Limegreen
    )
  else
    _prompt_steeef_colors=(
      "%F{cyan}"
      "%F{yellow}"
      "%F{magenta}"
      "%F{red}"
      "%F{green}"
    )
  fi

  # Formats:
  #   %b - branchname
  #   %u - unstagedstr (see below)
  #   %c - stagedstr (see below)
  #   %a - action (e.g. rebase-i)
  #   %R - repository path
  #   %S - path in the repository
  local branch_format="(${_prompt_steeef_colors[1]}%b%f%u%c)"
  local action_format="(${_prompt_steeef_colors[5]}%a%f)"
  local unstaged_format="${_prompt_steeef_colors[2]}●%f"
  local staged_format="${_prompt_steeef_colors[5]}●%f"

  # Set vcs_info parameters.
  zstyle ':vcs_info:*' enable bzr git hg svn
  zstyle ':vcs_info:*:prompt:*' check-for-changes true
  zstyle ':vcs_info:*:prompt:*' unstagedstr "${unstaged_format}"
  zstyle ':vcs_info:*:prompt:*' stagedstr "${staged_format}"
  zstyle ':vcs_info:*:prompt:*' actionformats "${branch_format}${action_format}"
  zstyle ':vcs_info:*:prompt:*' formats "${branch_format}"
  zstyle ':vcs_info:*:prompt:*' nvcsformats   ""

  # Set python-info parameters.
  zstyle ':prezto:module:python:info:virtualenv' format '(%v)'

  # Define prompts.　at ${_prompt_steeef_colors[2]}%m%f
  PROMPT="
${_prompt_steeef_colors[2]}%n%f : ${_prompt_steeef_colors[1]}%~%f "'${vcs_info_msg_0_}'"
"'${python_info[virtualenv]}'"> "
  RPROMPT='[%F{red}%D{%H:%M:%S}%f]'
}

prompt_steeef_setup "$@"
