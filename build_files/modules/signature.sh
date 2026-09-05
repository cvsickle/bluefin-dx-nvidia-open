#!/bin/bash

set -ouex pipefail

# Update policy.json to include signature verification for this image
jq '.transports.docker["ghcr.io/cvsickle/bluefin-dx-nvidia-open"] = [
  {
    "type": "sigstoreSigned",
    "keyPath": "/usr/share/pki/containers/cvsickle.pub",
    "signedIdentity": {"type": "matchRepository"}
  }
]' /etc/containers/policy.json > /tmp/policy.json.tmp && \
mv /tmp/policy.json.tmp /etc/containers/policy.json
