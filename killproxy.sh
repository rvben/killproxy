#!/bin/bash
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

iptables-save | grep -v KILLPROXY | iptables-restore
iptables -t nat -N KILLPROXY

iptables -t nat -A KILLPROXY -p tcp --dport $2 -d $1 -j REDIRECT --to-ports 8888
iptables -t nat -A KILLPROXY -p tcp --dport $2 -d $1 -j REDIRECT --to-ports 8888

iptables -t nat -A PREROUTING -i docker0 -p tcp -j KILLPROXY

pid=0
term_handler() {
    if [ $pid -ne 0 ]; then
        echo "Shutdown tinyproxy and disable killproxy rules.."
        kill -SIGTERM "$pid"
        wait "$pid"
        iptables-save | grep -v KILLPROXY | iptables-restore && \
        echo "Succesfully removed KILLPROXY iptable rules."
    fi
    exit 143;
}
trap 'kill ${!}; term_handler' SIGTERM

touch /var/log/tinyproxy/tinyproxy.log
/run.sh ANY &
pid="$!"

while true
do
    tail -f /var/log/tinyproxy/tinyproxy.log & wait ${!}
done
