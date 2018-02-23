# kubernetes stuff because I don't want to make another repo

# lighter weight version of kubectx/kubens that uses environment variables
# env variables allow different shells to be in different contexts,
# unlike kubectx which touches config files

function kubectl() {
  cmd="$(which kubectl)"
  if [[ "$1" != "config" ]]; then
    # add KUBECTX context if defined
    if [[ ! -z "${KUBECTX}" && "$@" != *"--context"* ]]; then
      cmd="$cmd --context=${KUBECTX}"
    fi
    # add KUBENS context if defined
    if [[ ! -z "${KUBENS}" && "$@" != *"--namespace"* ]]; then
      cmd="$cmd --namespace=${KUBENS}"
    fi
  fi
  $cmd "$@"
}

function kctx() {
  # set default context
  export KUBECTX="$1"
}

function kns() {
  # set default namespace
  export KUBENS="$1"
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
