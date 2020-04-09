#!/bin/bash

set -e

export DEBIAN_FRONTEND=noninteractive

export HOSTNAME="${domain}"
export EMAIL="${email}"

echo $EMAIL | /usr/share/jitsi-meet/scripts/install-letsencrypt-cert.sh
