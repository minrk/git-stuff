# source this from your bashrc to load all the git-stuff

# add git-stuff/bin to the PATH
export PATH=`dirname ${BASH_SOURCE[0]}`/bin:$PATH

# BSD `which -s` that works on Linux
alias whichs='which >/dev/null 2>&1'
# use hub git wrapper if available:
whichs hub && alias git=hub

# git-related aliases
alias gdiff='git diff --color-words'
alias status='git status -uno'
alias commit='git commit'
alias checkout='git fuzzy-checkout'
alias branch='git checkout -b'
alias amend='git commit --amend'
alias push='git push'
alias pull='git pull'
alias fetch='git fetch'
alias remote='git remote add'
alias cherry='git cherry-pick'
alias pick='git cherry-pick'
alias submodule='git submodule init && git submodule update'
alias m="git checkout master"
alias mp="git checkout master && git pull"
alias b="git checkout -b"
alias ci='git commit'
alias c="git fuzzy-checkout"
alias co="git fuzzy-checkout"
alias c-="git-last-branch"
alias pr="git push mine && hub pull-request"
alias uncommit="git log -1 && git reset HEAD^1"
alias rebase='git rebase -i origin/master'
alias fork='hub fork && hub remote add -p mine $(hub config --get github.user)'

# completion for aliases
if [ ! -z "$(declare -f __git_complete)" ]; then
    __git_complete gdiff _git_diff
    __git_complete commit _git_commit
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
