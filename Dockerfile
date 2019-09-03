FROM alpine:3.10
MAINTAINER Ruben J. Jongejan <ruben.jongejan@gmail.com>
COPY run.sh /run.sh
COPY killproxy.sh /killproxy.sh
RUN apk add --no-cache bash iptables tinyproxy && \
    chmod +x /killproxy.sh && \
    chmod +x /run.sh
ENTRYPOINT ["bash", "/killproxy.sh"]
