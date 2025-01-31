#!/usr/bin/env bash

source ./utils.sh

export SSH_AUTHORIZED_KEYS="ssh-ed25519 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY"
export PASSWORD=student

KINDEST_NODE_VER=$(curl -s https://hub.docker.com/v2/namespaces/kindest/repositories/node/tags \
                   | jq -r '.results[].name' \
                   | sort -k2 -rn | egrep -v 'alpha|beta' | head -1)

TSANGHAN_NODE_VER=$(curl -s https://hub.docker.com/v2/namespaces/tsanghan/repositories/node/tags \
                   | jq -r '.results[].name' \
                   | sort -k2 -rn | egrep -v 'alpha|beta' | egrep '^v1\.[0-9]{2}\.[0-9]{1,2}$' | head -1)

DH_NAMESPACE=kindest
vercomp "${KINDEST_NODE_VER:1}" "${TSANGHAN_NODE_VER:1}"
if [[ "$?" = 2 ]]; then
    KINDEST_NODE_VER="$TSANGHAN_NODE_VER"
    DH_NAMESPACE=tsanghan
fi

KUBECTL_VER=${KINDEST_NODE_VER:1}
REPO_VER=${KINDEST_NODE_VER::-2}
KINDEST_NODE_HASH=$(curl -s https://hub.docker.com/v2/namespaces/"$DH_NAMESPACE"/repositories/node/tags \
                    | jq -r --arg KINDEST_NODE_VER "$KINDEST_NODE_VER" '.results[] | select(.name==$KINDEST_NODE_VER) | .images[] | select(.architecture=="amd64") | .digest')

KINDEST_NODE_VER=$KINDEST_NODE_VER@$KINDEST_NODE_HASH

export DH_NAMESPACE KINDEST_NODE_VER KUBECTL_VER REPO_VER

pushd ../../templates

export USER=student
envsubst '$USER:
          $PASSWORD:
          $SSH_AUTHORIZED_KEYS:
          $DH_NAMESPACE:
          $KINDEST_NODE_VER:
          $KUBECTL_VER:
          $REPO_VER' \
          < cloud-config-hyperv.tmpl > ../cloud-configs/cloud-config.yaml
#          < cloud-config-hyperv.tmpl > ../cloud-configs/cloud-config-hyperv.yaml
# export USER=student
# envsubst '$USER:
#           $PASSWORD:
#           $DH_NAMESPACE:
#           $KINDEST_NODE_VER:
#           $KUBECTL_VER
#           $REPO_VER' \
#           < cloud-config-wsl.tmpl > ../cloud-configs/cloud-config-wsl.yaml

popd