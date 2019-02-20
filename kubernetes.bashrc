# kubernetes stuff because I don't want to make another repo

# lighter weight version of kubectx/kubens that uses environment variables
# env variables allow different shells to be in different contexts,
# unlike kubectx which touches config files

alias kube-drain="kubectl drain --force --delete-local-data --ignore-daemonsets --grace-period=0 "

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
  # echo $cmd "$@"
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

alias kube-addresses="kubectl get node -o json | jq '.items[] | [.status.addresses[].address,.spec.providerID]'"

function pod() {
  # get the first pod matching a prefix
  # useful with, e.g.
  # kubectl logs -f `pod hub`

  pod=$(kubectl get pod | grep "^${1}" | head -n 1 | awk '{print $1}')
  if [[ -z "$pod" ]]; then
    # output something to avoid `pod nomatch` returning an empty string
    # which can result in performing the operation on all pods (e.g. describe `pod nomatch`)
    echo "nosuchpod-${1}"
  else
    echo "$pod"
  fi
}
