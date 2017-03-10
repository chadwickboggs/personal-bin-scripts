#!/usr/bin/env fish

set -x DOCKER_TLS_VERIFY "1"
set -x DOCKER_HOST "tcp://192.168.99.100:2376"
set -x DOCKER_CERT_PATH "/Users/cboggs1/.docker/machine/machines/default"
set -x DOCKER_MACHINE_NAME "default"

