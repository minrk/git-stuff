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

  # prioritize prefix
  pod=
  for match in $(kubectl get pod --no-headers | awk '{print $1}' | grep "${1}"); do
    if [[ -z "$pod" ]]; then
      pod=$match
    fi
    prefix_pod=$(echo $match | grep "^${1}")
    if [[ ! -z "$prefix_pod" ]]; then
      pod="$prefix_pod"
      break
    fi
  done

  if [[ -z "$pod" ]]; then
    # output something to avoid `pod nomatch` returning an empty string
    # which can result in performing the operation on all pods (e.g. describe `pod nomatch`)
    echo "nosuchpod-${1}"
  else
    echo "$pod"
  fi
}


function kube-delete-pods() {
  pat="$1"
  shift
  pods=$(kubectl get pod --no-headers "$@" | awk '{print $1}' | grep "$pat")
  echo "$pods"
  read -p "Delete above pods (y/[n])?" yesno
  case "$yesno" in
    y|Y )
      echo kubectl delete pod "$@" $pods;
      kubectl delete pod "$@" $pods;
      ;;
    * )
      echo "Cancelled"
      ;;
  esac
}

alias kube-watch-not-running="watch 'kubectl get pod | grep -v Running'"
