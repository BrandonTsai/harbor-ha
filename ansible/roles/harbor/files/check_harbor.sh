#!/bin/bash
healthy_harbor_count=`docker-compose -f /opt/harbor/docker-compose.chartmuseum.yml -f /opt/harbor/docker-compose.clair.yml -f /opt/harbor/docker-compose.yml ps | grep Up | wc -l`
healthy_postgresql_count=`docker-compose -f /opt/postgresql/docker-compose.yml ps | grep Up | wc -l`

if [ $healthy_harbor_count == 11 ] && [ $healthy_postgresql_count == 1 ] ; then
    exit 0
else
    echo "healthy_harbor_count: $healthy_harbor_count" > /tmp/check_harblr.result
    docker-compose -f /opt/harbor/docker-compose.chartmuseum.yml -f /opt/harbor/docker-compose.clair.yml -f /opt/harbor/docker-compose.yml ps >> /tmp/check_harblr.result
    exit 1
fi
