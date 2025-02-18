#!/usr/bin/env bash

cd $(dirname ${BASH_SOURCE})

source ./utils.sh
source ./.versionsrc.sh

set -e

export SSH_AUTHORIZED_KEYS="ssh-ed25519 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY"
export PASSWORD=student

KINDEST_NODE_VER=$(curl -s https://hub.docker.com/v2/namespaces/kindest/repositories/node/tags \
                   | jq -r '.results[].name' \
                   | sort -k2 -rn | egrep -v 'alpha|beta' | head -1)

TSANGHAN_NODE_VER=$(curl -s https://hub.docker.com/v2/namespaces/tsanghan/repositories/node/tags \
                   | jq -r '.results[].name' \
                   | sort -k2 -rn | egrep -v 'alpha|beta' | egrep '^v1\.[0-9]{2}\.[0-9]{1,2}$' | head -1)

DH_NAMESPACE=kindest
KINDEST_NODE_VER_ARM64="$KINDEST_NODE_VER"
KINDEST_NODE_VER_AMD64="$KINDEST_NODE_VER"
KUBECTL_VER=${KINDEST_NODE_VER:1}
REPO_VER=${KINDEST_NODE_VER::-2}
vercomp "${KINDEST_NODE_VER:1}" "${TSANGHAN_NODE_VER:1}"
if [[ "$?" = 2 ]]; then
    KUBECTL_VER=${TSANGHAN_NODE_VER:1}
    REPO_VER=${TSANGHAN_NODE_VER::-2}
    KINDEST_NODE_VER_AMD64="$TSANGHAN_NODE_VER"
    KUBECTL_VER=${TSANGHAN_NODE_VER:1}
    DH_NAMESPACE=tsanghan
fi

KINDEST_NODE_VER=$KINDEST_NODE_VER_AMD64
KINDEST_NODE_HASH=$(curl -s https://hub.docker.com/v2/namespaces/"$DH_NAMESPACE"/repositories/node/tags \
                   | jq -r --arg KINDEST_NODE_VER "$KINDEST_NODE_VER" '.results[] |
                                                                      select( .name == $KINDEST_NODE_VER) |
                                                                      .digest')

KINDEST_NODE_VER=$KINDEST_NODE_VER@$KINDEST_NODE_HASH

export DH_NAMESPACE KINDEST_NODE_VER KUBECTL_VER REPO_VER

pushd ../../templates

export USER=student
export TOKEN=null

export ARCH=amd64
export KINDEST_NODE_VER=$KINDEST_NODE_VER_AMD64@$KINDEST_NODE_HASH
envsubst '$ARCH:
          $USER:
          $PASSWORD:
          $SSH_AUTHORIZED_KEYS:
          $DH_NAMESPACE:
          $KINDEST_NODE_VER:
          $KUBECTL_VER:
          $REPO_VER:
          $TOKEN:
          $KIND_VER:
          $HELM_VER:
          $CILIUM_CLI_VERSION:
          $HUBBLE_VERSION:
          $FZF_VER:
          $K9S_VER' \
          < cloud-config-hyperv.tmpl > ../cloud-configs/cloud-config.yaml

export ARCH=arm64
export DH_NAMESPACE=kindest
export REPO_VER=${KINDEST_NODE_VER_ARM64::-2}
export KINDEST_NODE_VER=$KINDEST_NODE_VER_ARM64
KINDEST_NODE_HASH=$(curl -s https://hub.docker.com/v2/namespaces/"$DH_NAMESPACE"/repositories/node/tags \
                   | jq -r --arg KINDEST_NODE_VER "$KINDEST_NODE_VER" '.results[] |
                                                                      select( .name == $KINDEST_NODE_VER) |
                                                                      .digest')
export KINDEST_NODE_VER=$KINDEST_NODE_VER@$KINDEST_NODE_HASH
envsubst '$ARCH:
          $USER:
          $PASSWORD:
          $SSH_AUTHORIZED_KEYS:
          $DH_NAMESPACE:
          $KINDEST_NODE_VER:
          $KUBECTL_VER:
          $REPO_VER:
          $TOKEN:
          $KIND_VER:
          $HELM_VER:
          $CILIUM_CLI_VERSION:
          $HUBBLE_VERSION:
          $FZF_VER: \
          $K9S_VER' \
          < cloud-config-hyperv.tmpl > ../cloud-configs/cloud-config-arm64.yaml
popd