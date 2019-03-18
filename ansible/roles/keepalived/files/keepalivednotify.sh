#!/bin/bash -x
exec &>> /var/log/keepalive_notify.log

echo "---------------------------------------------------------------------"
date

TYPE=$1
NAME=$2
STATE=$3
KEEPALIVED_CONF="/etc/keepalived/keepalived.conf"

make_sure_postgresql_running(){
  pushd /opt/postgresql/
  if [ -z `docker ps -q --no-trunc | grep $(docker-compose ps -q postgresql)` ]; then
    echo "Postgresql is not running."
    docker-compose up -d postgresql
    sleep 3
  else
    echo "Postgresql is running."
  fi
  popd

}

become_master(){
  pushd /opt/postgresql/
  make_sure_postgresql_running
  docker-compose exec -T postgresql touch /tmp/touch_me_to_promote_to_me_master
  docker-compose exec -T postgresql ls /tmp/touch_me_to_promote_to_me_master
  popd
  touch /tmp/keepalived_is_masteer
}


become_backup(){
  sleep 2 # wait until master ready
  /opt/postgresql/become_standby.sh

  rm -rf /tmp/keepalived_is_masteer
  if [ -s /opt/harbor/docker-compose.yml ]; then
      unhealthy_harbor_num=$(/bin/docker-compose -f /opt/harbor/docker-compose.yml -f /opt/harbor/docker-compose.clair.yml -f /opt/harbor/docker-compose.chartmuseum.yml ps | awk '/Exit|Restarting/' | wc -l)
      if [ "$unhealthy_harbor_num" == "0" ]; then
        /opt/harbor/install.sh --with-clair --with-chartmuseum
      fi
  fi
}

case $STATE in
    "MASTER")
        become_master
        exit 0
        ;;
    "BACKUP")
        if [ -f /tmp/keepalived_is_masteer ] && [ -s "/data/database/PG_VERSION" ] ; then
          become_backup
        fi
        exit 0
        ;;
    "FAULT")
        if [ -f /tmp/keepalived_is_masteer ] && [ -s "/data/database/PG_VERSION" ] ; then
          touch /tmp/disable_keepalived
          become_backup
          rm -rf /tmp/disable_keepalived
        fi
        exit 0
        ;;
    *)
        echo "unknown state ${STATE}"
        exit 1
        ;;
esac
