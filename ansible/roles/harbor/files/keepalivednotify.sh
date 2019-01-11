#!/bin/bash

TYPE=$1
NAME=$2
STATE=$3

case $STATE in
    "MASTER")
        echo "MASTER" > /tmp/keepalived_state
        pushd /opt/postgresql/
        docker-compose exec postgresql touch /tmp/touch_me_to_promote_to_me_master
        /opt/harbor/install.sh --with-notary --with-clair --with-chartmuseum
        popd
        exit 0
        ;;
    "BACKUP")
        echo "BACKUP" > /tmp/keepalived_state
        exit 0
        ;;
    "FAULT")
        echo "FAULT" > /tmp/keepalived_state
        /opt/harbor/install.sh --with-notary --with-clair --with-chartmuseum
        exit 0
        ;;
    *)
        echo "unknown state"
        exit 1
        ;;
esac