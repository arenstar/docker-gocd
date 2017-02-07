# Build using: docker build --build-arg GO_VERSION=17.x.x-xxxx -t alpine-gocd-server .

FROM openjdk:8u111-jre
ARG GO_VERSION=17.1.0-4511
ARG DOWNLOAD_URL=https://download.gocd.io/binaries

# Install GoCD
RUN apt-get -y update \
    && apt-get install -y -q unzip git ca-certificates \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /tmp

RUN curl -L --silent ${DOWNLOAD_URL}/${GO_VERSION}/deb/go-server_${GO_VERSION}_all.deb -o /tmp/go-server.deb \
    && dpkg -i --debug=10 /tmp/go-server.deb \
    && sed -i -e 's/DAEMON=Y/DAEMON=N/' /etc/default/go-server \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN mkdir -p /var/lib/go-server/plugins/external && chown -R go:go /var/lib/go-server
RUN curl -sSL https://github.com/tomzo/gocd-yaml-config-plugin/releases/download/0.2.0/yaml-config-plugin-0.2.0.jar -o /var/lib/go-server/plugins/external/yaml-config-plugin-0.2.0.jar
RUN curl -sSL https://github.com/gocd-contrib/script-executor-task/releases/download/0.2/script-executor-0.2.jar -o /var/lib/go-server/plugins/external/script-executor-0.2.jar
RUN curl -sSL https://github.com/ashwanthkumar/gocd-slack-build-notifier/releases/download/v1.4.0-RC11/gocd-slack-notifier-1.4.0-RC11.jar -o /var/lib/go-server/plugins/external/gocd-slack-notifier-1.4.0-RC11.jar
RUN curl -sSL https://github.com/ashwanthkumar/gocd-build-github-pull-requests/releases/download/v1.3.0-RC2/stash-pr-poller-1.3.0-RC2.jar -o /var/lib/go-server/plugins/external/stash-pr-poller-1.3.0-RC2.jar
RUN curl -sSL https://github.com/gocd-contrib/gocd-build-status-notifier/releases/download/1.2/stash-pr-status-1.2.jar -o /var/lib/go-server/plugins/external/stash-pr-status-1.2.jar

VOLUME ["/var/lib/go-server", "/var/log/go-server", "/etc/go", "/go-addons", "/var/go"]

EXPOSE 8153 8154

ADD docker-entrypoint.sh /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["/usr/share/go-server/server.sh"]
