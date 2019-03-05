#!/bin/bash

gen_cert(){

    openssl req \
        -newkey rsa:2048 -nodes -sha256 -keyout ca.key \
        -x509 -days 365 -out ca.crt -subj /C=AU/ST=NSW/L=Sydney/O=Darumatic/OU=IT/CN=$1
    openssl req \
        -newkey rsa:2048 -nodes -sha256 -keyout server.key \
        -out server.csr -subj /C=AU/ST=NSW/L=Sydney/O=Darumatic/OU=IT/CN=$1

    openssl x509 -req -days 365 -in server.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out server.crt
}

if [ -z "$1" ]; then
  echo "Usage: $0 <DNS name>"
else
  gen_cert $1
fi