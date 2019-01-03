#!/bin/bash
chown root:root /etc/adminserver/secretkey
cp /etc/adminserver/secretkey /etc/adminserver/key
chown 10000:10000 /etc/adminserver/secretkey
chown root:root /etc/adminserver/key && /harbor/harbor_adminserver