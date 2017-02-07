# Build using: docker build --build-arg GO_VERSION=16.x.x-xxxx -t gocd-agent .

FROM openjdk:8u111-jre
ARG GO_VERSION=17.1.0-4511
ARG DOWNLOAD_URL="https://download.gocd.io/binaries"

# Install GoCD
RUN apt-get -y update \
    && apt-get install -y -q unzip git iptables init-system-helpers libapparmor1 libltdl7 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /tmp

RUN curl -L --silent ${DOWNLOAD_URL}/${GO_VERSION}/deb/go-agent_${GO_VERSION}_all.deb -o /tmp/go-agent.deb \
    && dpkg -i /tmp/go-agent.deb \
    && rm -rf /tmp/go-agent.deb \
    && sed -i -e 's/DAEMON=Y/DAEMON=N/' /etc/default/go-agent

RUN curl -L --silent https://apt.dockerproject.org/repo/pool/main/d/docker-engine/docker-engine_1.12.6-0~debian-jessie_amd64.deb -o /tmp/docker.deb \
    && dpkg -i /tmp/docker.deb \
    && rm -rf /tmp/docker.deb

RUN curl -k -L "https://github.com/docker/compose/releases/download/1.10.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose \
    && chmod +x /usr/local/bin/docker-compose

# Setup docker
RUN usermod -aG docker root
RUN usermod -aG docker go

USER go

ADD docker-entrypoint.sh /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["/usr/share/go-agent/agent.sh go-agent"]
