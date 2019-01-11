#!/bin/bash
healthy_container_count = `docker-compose -f /opt/harbor/docker-compose.yml ps | grep Up | wc -l`

if [ $healthy_count == 9 ] ; then
    exit 0
else
    exit 1
fi