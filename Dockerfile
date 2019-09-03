FROM dannydirect/tinyproxy
MAINTAINER Ruben J. Jongejan <ruben.jongejan@gmail.com>
COPY killproxy.sh /killproxy.sh
RUN apk add --no-cache bash iptables tinyproxy && \
    chmod +x /killproxy.sh
ENTRYPOINT ["bash", "/killproxy.sh"]
