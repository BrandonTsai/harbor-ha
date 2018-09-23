Harbor on AWS with Ansible and Terraform
=========================================

Usage
-----

### Create AWS environment via Terraform

```bash
terraform init
terraform apply -var-file=secret.tfvars -auto-approve
```

### Create ssl certification files

```bash
openssl req \
    -newkey rsa:2048 -nodes -sha256 -keyout ca.key \
    -x509 -days 365 -out ca.crt -subj /C=AU/ST=NSW/L=Sydney/O=Darumatic/OU=IT/CN=harbor-elb-012345678.ap-southeast-2.elb.amazonaws.com
openssl req \
    -newkey rsa:2048 -nodes -sha256 -keyout server.key \
    -out server.csr -subj /C=AU/ST=NSW/L=Sydney/O=Darumatic/OU=IT/CN=harbor-elb-012345678.ap-southeast-2.elb.amazonaws.com

openssl x509 -req -days 365 -in server.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out server.crt
```


### Run ansible

```bash
ansible-playbook plays/harbor.yml -i hosts/prod.ini
```


Mac User
========

1. Add cert file to keychain

```bash
sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain ./server.crt
```

2. Restart Docker

3. Docker Login