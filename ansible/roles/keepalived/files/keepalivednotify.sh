#!/bin/bash
exec &>> /tmp/keepalive_notify.log

TYPE=$1
NAME=$2
STATE=$3

case $STATE in
    "MASTER")
        echo "MASTER" | tee /tmp/keepalived_state
        pushd /opt/postgresql/
        docker-compose exec postgresql touch /tmp/touch_me_to_promote_to_me_master
        popd
        pushd /opt/harbor/
        /opt/harbor/install.sh --with-clair --with-chartmuseum
        popd
        exit 0
        ;;
    "BACKUP")
        echo "BACKUP" | tee /tmp/keepalived_state
        sleep 60
        pushd /opt/harbor/
        /opt/harbor/install.sh --with-clair --with-chartmuseum
        popd
        exit 0
        ;;
    "FAULT")
        echo "FAULT" | tee /tmp/keepalived_state
        #/opt/harbor/install.sh --with-clair --with-chartmuseum
        exit 0
        ;;
    *)
        echo "unknown state"
        exit 1
        ;;
esac
