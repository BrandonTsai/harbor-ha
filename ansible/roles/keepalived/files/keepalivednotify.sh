#!/bin/bash -x
exec &>> /var/log/keepalive_notify.log

TYPE=$1
NAME=$2
STATE=$3

make_sure_postgresql_running(){
  pushd /opt/postgresql/
  if [ -z `docker ps -q --no-trunc | grep $(docker-compose ps -q postgresql)` ]; then
    echo "Postgresql is not running."
    docker-compose postgresql up -d
    sleep 3
  else
    echo "Postgresql is running."
  fi
  popd

}

case $STATE in
    "MASTER")
        echo "MASTER" | tee /tmp/keepalived_state
        pushd /opt/postgresql/
        make_sure_postgresql_running
        docker-compose exec -T postgresql touch /tmp/touch_me_to_promote_to_me_master
        docker-compose exec -T postgresql ls /tmp/touch_me_to_promote_to_me_master
        popd
        sleep 5
        # pushd /opt/harbor/
        # /opt/harbor/install.sh --with-clair --with-chartmuseum
        # popd
        exit 0
        ;;
    "BACKUP")
        echo "BACKUP" | tee /tmp/keepalived_state
        sleep 60
        # pushd /opt/harbor/
        # /opt/harbor/install.sh --with-clair --with-chartmuseum
        # popd
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
