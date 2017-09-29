# kubernetes stuff because I don't want to make another repo

function kns() {
  # set the default namespace for kubectl
  if [[ -z "$1" ]]; then
    unalias kubectl
  else
    alias kubectl="kubectl --namespace $1"
  fi
}

function pod() {
  # evaluate alias explicitly. function seems to use alias at definition time
  if alias kubectl &>/dev/null; then
    kc="$(alias kubectl | awk -F "'" '{print $2}')"
  else
    kc=kubectl
  fi
  # get the first pod matching a prefix
  $kc get pod | grep "^${1}" | head -n 1 | awk '{print $1}'
}
