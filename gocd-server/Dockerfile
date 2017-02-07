# Build using: docker build --build-arg GO_VERSION=16.x.x-xxxx -t alpine-gocd-server .

FROM openjdk:8u111-jre
ARG GO_VERSION=17.1.0-4511
ARG DOWNLOAD_URL=https://download.gocd.io/binaries

# Install GoCD
RUN apt-get -y update \
    && apt-get install -y -q unzip git \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /tmp

RUN curl -L --silent ${DOWNLOAD_URL}/${GO_VERSION}/deb/go-server_${GO_VERSION}_all.deb -o /tmp/go-server.deb \
    && dpkg -i --debug=10 /tmp/go-server.deb \
    && sed -i -e 's/DAEMON=Y/DAEMON=N/' /etc/default/go-server \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

VOLUME ["/var/lib/go-server", "/var/log/go-server", "/etc/go", "/go-addons", "/var/go"]

EXPOSE 8153 8154

ADD docker-entrypoint.sh /docker-entrypoint.sh

ENTRYPOINT /docker-entrypoint.sh
