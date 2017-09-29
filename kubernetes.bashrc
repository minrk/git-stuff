# kubernetes stuff because I don't want to make another repo

function kns() {
  # set the default namespace for kubectl
  if [[ -z "$1" ]]; then
    unalias kubectl
  else
    alias kubectl="kubectl --namespace $1"
  fi
}
