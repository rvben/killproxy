#!/bin/#!/bin/sh
set -x
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

sysctl -w net.ipv4.ip_forward=1

iptables-save | grep -v KILLPROXY | iptables-restore
iptables -t nat -N KILLPROXY

iptables -t nat -A KILLPROXY -p tcp --dport $2 -d $1 -j REDIRECT --to-ports 8888
iptables -t nat -A KILLPROXY -p tcp --dport $2 -d $1 -j REDIRECT --to-ports 8888

iptables -t nat -A PREROUTING -i docker0 -p tcp -j KILLPROXY
/opt/docker-tinyproxy/run.sh ANY
