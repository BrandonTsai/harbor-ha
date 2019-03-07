Harbor on AWS with Ansible and Terraform
=========================================

Pre-Fight
---------

- Two VMs
- Virtual IP
- Openstack Swift Credential
- ssl certificate

### Create ssl certificate files

You can use openssl, EasyRSA or other tools to generate the ssl certificate

Reference commamnds

```bash
openssl req \
    -newkey rsa:2048 -nodes -sha256 -keyout ca.key \
    -x509 -days 365 -out ca.crt -subj /C=AU/ST=NSW/L=Sydney/O=Darumatic/OU=IT/CN=harbor-elb-012345678.ap-southeast-2.elb.amazonaws.com
openssl req \
    -newkey rsa:2048 -nodes -sha256 -keyout server.key \
    -out server.csr -subj /C=AU/ST=NSW/L=Sydney/O=Darumatic/OU=IT/CN=harbor-elb-012345678.ap-southeast-2.elb.amazonaws.com

openssl x509 -req -days 365 -in server.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out server.crt
```

Usage
-----

```
cd ansible
```

### create inventory file

Copy host/example.ini to hosts/production/xxx.ini

Modify hosts/production/xxx.ini with appropriate value.


### Run ansible

```bash
ansible-playbook harbor.yml -i hosts/production/xxx.ini
```

### Make sure docker containers are running. 

connect to master node

```
sudo docker ps
```


Test Harbor
------------

### Mac User


1. Add cert file to keychain

```bash
sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain ./server.crt
```

or set as insecure registry

2. Restart Docker

3. Docker Login

