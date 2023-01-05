FROM lscr.io/linuxserver/code-server:latest

# Misc
RUN sudo apt-get update && sudo apt-get install --no-install-recommends -y \
    gnupg2 \
    unzip \
    libarchive-tools \
    wget \
    bash-completion \
    dnsutils \
    netcat \
    telnet \
    postgresql-client \
    && sudo rm -rf /var/lib/apt/lists/*

# Kubectl
ENV KUBECTL_VERSION 1.23.13
RUN wget -q -O kubectl "https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl" && \
    sudo install kubectl /usr/local/bin/ && \
    rm -f kubectl*

# Docker
ENV DOCKER_VERSION 20.10.21
RUN wget -q -O docker.tar.gz https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKER_VERSION}.tgz && \
    tar xzf docker.tar.gz && \
    sudo install docker/docker /usr/local/bin/ && \
    rm -rf docker*
