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

RUN kubectl completion bash | sudo tee /etc/bash_completion.d/kubectl > /dev/null && \
    helm completion bash | sudo tee /etc/bash_completion.d/helm > /dev/null && \
    tanzu completion bash | sudo tee /etc/bash_completion.d/tanzu > /dev/null && \
    kp completion bash | sudo tee /etc/bash_completion.d/kp > /dev/null && \
    ytt completion bash | sudo tee /etc/bash_completion.d/ytt > /dev/null && \
    kapp completion bash | grep -v Succeeded | sudo tee /etc/bash_completion.d/kapp > /dev/null && \
    imgpkg completion bash | grep -v Succeeded | sudo tee /etc/bash_completion.d/imgpkg > /dev/null && \
    kctrl completion bash | grep -v Succeeded | sudo tee /etc/bash_completion.d/kctrl > /dev/null && \
    stern --completion bash | sudo tee /etc/bash_completion.d/stern > /dev/null && \
    tilt completion bash | sudo tee /etc/bash_completion.d/tilt > /dev/null && \
    pinniped completion bash | sudo tee /etc/bash_completion.d/pinniped > /dev/null

RUN rm -f LICENSE README.md

RUN mkdir /home/coder/.bin && \
    echo "export PATH=\"\$HOME/.local/bin:\$PATH\"" | sudo tee -a /home/coder/.bashrc > /dev/null

RUN mkdir -p ${VSCODE_USER} && echo "{\"java.home\":\"$(dirname /opt/jdk-*/bin/)\",\"maven.terminal.useJavaHome\":true, \"maven.executable.path\":\"/opt/apache-maven-${MAVEN_VERSION}/bin/mvn\",\"spring-boot.ls.java.home\":\"$(dirname /opt/jdk-*/bin/)\",\"files.exclude\":{\"**/.classpath\":true,\"**/.project\":true,\"**/.settings\":true,\"**/.factorypath\":true},\"redhat.telemetry.enabled\":false,\"java.server.launchMode\": \"Standard\"}" | jq . > ${VSCODE_USER}/settings.json
RUN echo 'for f in /etc/profile.d/*.sh;do source $f;done' | sudo tee -a /home/coder/.bashrc > /dev/null
RUN rm -f /home/coder/.wget-hsts
