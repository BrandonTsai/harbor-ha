#!/bin/bash
healthy_harbor_count=`docker-compose -f /opt/harbor/docker-compose.yml ps | grep Up | wc -l`
healthy_postgresql_count=`docker-compose -f /opt/postgresql/docker-compose.yml ps | grep Up | wc -l`

if [ $healthy_harbor_count == 9 ] && [ $healthy_postgresql_count == 1 ] ; then
    exit 0
else
    exit 0
fi
