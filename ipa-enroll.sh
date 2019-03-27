#!/bin/bash
set -x

admin_PASSWD="$1"
ipa_DOMAIN="braincraft.io"
ipa_REALM="BRAINCRAFT.IO"
server_FQDN="ipa.braincraft.io"
server_IPADDR="10.0.0.246"
name_HOST="$(hostname --short)"
client_HOSTNAME="${name_HOST}.${ipa_DOMAIN}"
ip_ADDR=$(ip addr show | grep "inet\b" | grep "10.10.0" | awk '{print $2}' | cut -d/ -f1)

server_IPA_HOSTS_BOOL=$(grep "ipa" /etc/hosts; echo $?)
if [[ ${server_IP_HOSTS_BOOL} != 0 ]]; then
	echo "10.0.0.246 ipa.braincraft.io ipa" >>/etc/hosts
fi

#echo "${ip_ADDR} ${name_HOST}.${ipa_DOMAIN}" >>/etc/hosts
#echo "${name_HOST}.${ipa_DOMAIN}" >/etc/hostname
#hostnamectl set-hostname $(cat /etc/hostname)

apt-get install -y freeipa-client openssh-server sssd nscd nslcd

ipa-client-install                   \
    --mkhomedir                      \
    --request-cert                   \
    --ssh-trust-dns                  \
    --ip-address=${ip_ADDR}          \
    --hostname=${client_HOSTNAME}    \
    --principal admin                \
    --password="${admin_PASSWD}" \
    --server=${server_FQDN}          \
    --domain=${ipa_DOMAIN}          \
    --realm=${ipa_REALM}            \
    --unattended --force-join

## REFRENCE
#	--configure-firefox
