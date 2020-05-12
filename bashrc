# source this from your bashrc to load all the git-stuff

# add git-stuff/bin to the PATH
export PATH=`dirname ${BASH_SOURCE[0]}`/bin:$PATH

source `dirname ${BASH_SOURCE[0]}`/aliases

# completion for aliases
if [ ! -z "$(declare -f __git_complete)" ]; then
    __git_complete clone _git_clone
    __git_complete gdiff _git_diff
    __git_complete commit _git_commit
    __git_complete amend _git_commit
    __git_complete aamend _git_commit
    __git_complete ci _git_commit
    __git_complete fetch _git_fetch
    __git_complete branch _git_branch
    __git_complete b _git_checkout
    __git_complete c _git_checkout
    __git_complete co _git_checkout
    __git_complete push _git_push
    __git_complete pull _git_pull
    __git_complete remote _git_remote
    __git_complete pick _git_cherry_pick
    __git_complete cherry _git_cherry_pick
    __git_complete rebase _git_rebase
    __git_complete fork _git_fork
    __git_complete pm _git_push
fi

# add the git branch to the prompt
# turns out: elaborate bash prompts are super gross
function _git_branch_paren {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1) /'
}
function proml {
  local           X="\[$(tput sgr0 2>/dev/null)\]" # reset
  local        BLUE="\[\033[0;34m\]"
  local       LBLUE="\[\033[1;34m\]"
  local         RED="\[\033[0;31m\]"
  local        LRED="\[\033[1;31m\]"
  local       GREEN='\[\033[0;32m\]'
  local      LGREEN="\[\033[1;32m\]"
  local        GRAY="\[\033[0;37m\]"
  local       WHITE="\[\033[1;37m\]"
  case $TERM in
    xterm*)
    TITLEBAR='\u@\h:\w'
    ;;
    *)
    TITLEBAR=""
    ;;
  esac

  PS1="$X\u$RED[\A]$X\w $GREEN\$(_git_branch_paren)$X\$ "
  test -z "$SSH_CONNECTION" || PS1="$X$LRED\u@\h$X[\A]$X\w $GREEN\$(_git_branch_paren)$X\$ "
}
proml

source "${BASH_SOURCE%/*}/aliases"
source "${BASH_SOURCE%/*}/kubernetes.bashrc"
