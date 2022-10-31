# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# Format history
HISTCONTROL=ignoreboth # Remove duplicate
shopt -s histappend # Append history
HISTSIZE=1000
HISTFILESIZE=2000
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# Have less display colours
# from: https://wiki.archlinux.org/index.php/Color_output_in_console#man
export LESS_TERMCAP_mb=$'\e[1;31m'     # begin bold
export LESS_TERMCAP_md=$'\e[1;33m'     # begin blink
export LESS_TERMCAP_so=$'\e[01;44;37m' # begin reverse video
export LESS_TERMCAP_us=$'\e[01;37m'    # begin underline
export LESS_TERMCAP_me=$'\e[0m'        # reset bold/blink
export LESS_TERMCAP_se=$'\e[0m'        # reset reverse video
export LESS_TERMCAP_ue=$'\e[0m'        # reset underline
export LESSHISTFILE=-                  # Remove the history file
export GROFF_NO_SGR=1                  # for konsole and gnome-terminal

# Alias definitions.
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

export GOPATH="${HOME}/gopath"
export PATH="${GOPATH}:${GOPATH}/bin:${HOME}/.myscripts:/var/lib/snapd/snap/bin:${PATH}"
export EDITOR='/usr/bin/vim'

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
if [ ! -z "$VIRTUAL_ENV" ]; then
 source $VIRTUAL_ENV/bin/activate  # commented out by conda initialize  # commented out by conda initialize
fi

__conda_setup="$('/home/rcamarasa/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/rcamarasa/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/rcamarasa/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/rcamarasa/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup

# Load environment
test -e .project && source .project

# Get current git branch
git_branch () {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/[\1]/g'
}

git_branch_space () {
    test -z "$(git branch 1> /dev/null 2> /dev/null)" && test ! "$(git branch 2> /dev/null | wc -l )" == "0" && echo " "
}

git_status () {
    test -z "$(git status --porcelain 2> /dev/null)" && echo "37" || echo "202"
}

get_ps1 () {
    # Print branch
    echo -n '\[\033[38;5;'
    echo -n "\$(git_status)"
    echo -n 'm\]'
    echo -n "\$(git_branch)"
    echo -n '\[\033[00m\]'
    echo -n "\$(git_branch_space)"

    # Print user
    echo -n '\[\033[38;5;37m\]\u\[\033[00m\]'
    # Print @
    echo -n '\[\033[38;5;37m\]@\[\033[00m\]'
    # Print host
    echo -n '\[\033[38;5;37m\]\h\[\033[00m\]'
    # Print :
    echo -n '\[\033[38;5;248m\]:\[\033[00m\]'
    # Print short working directory
    echo -n '\[\033[38;5;248m\]\W\[\033[00m\]'
    # Print >
    echo -n '\[\033[38;5;37m\] > \[\033[00m\]'
}
get_ps2 () {
    echo -n '\[\033[1m\]\[\033[38;5;37m\]-\[\033[00m\]'
    echo -n '\[\033[1m\]\[\033[38;5;37m\]-\[\033[00m\]'
    # Print >
    echo -n '\[\033[1m\]\[\033[38;5;37m\]> \[\033[00m\]'
}
get_ps3 () {
    # Print user
    echo -n '\[\033[1m\]\[\033[38;5;160m\]-\[\033[00m\]'
    # Print @
    echo -n '\[\033[1m\]\[\033[38;5;202m\]-\[\033[00m\]'
    # Print host
    echo -n '\[\033[1m\]\[\033[38;5;190m\]-\[\033[00m\]'
    # Print :
    echo -n '\[\033[1m\]\[\033[38;5;46m\]-\[\033[00m\]'
    # Print short working directory
    echo -n '\[\033[1m\]\[\033[38;5;48m\]-\[\033[00m\]'
    # Print >
    echo -n '\[\033[1m\]\[\033[38;5;39m\]? \[\033[00m\]'
}
get_ps4 () {
    # Print user
    echo -n '\[\033[1m\]\[\033[38;5;160m\]-\[\033[00m\]'
    # Print @
    echo -n '\[\033[1m\]\[\033[38;5;202m\]-\[\033[00m\]'
    # Print host
    echo -n '\[\033[1m\]\[\033[38;5;190m\]-\[\033[00m\]'
    # Print :
    echo -n '\[\033[1m\]\[\033[38;5;46m\]-\[\033[00m\]'
    # Print short working directory
    echo -n '\[\033[1m\]\[\033[38;5;48m\]-\[\033[00m\]'
    # Print >
    echo -n '\[\033[1m\]\[\033[38;5;39m\]# \[\033[00m\]'
}

PS1="$(get_ps1)"
PS2="$(get_ps2)"
PS3="$(get_ps3)"
PS4="$(get_ps4)"


export PATH=$PATH:/home/rcamarasa/bin
export PATH=$PATH:/usr/local/go/bin
