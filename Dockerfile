FROM codercom/code-server:latest

# Misc
RUN sudo apt-get update && sudo apt-get install --no-install-recommends -y \
    jq \
    gnupg2 \
    curl \
    unzip \
    libarchive-tools \
    wget \
    bash-completion \
    dnsutils \
    netcat \
    telnet \
    postgresql-client \
    && sudo rm -rf /var/lib/apt/lists/*

ENV TZ Asia/Tokyo

# Visual Studio Code Extentions
ENV VSCODE_USER /home/coder/.local/share/code-server/User
ENV VSCODE_EXTENSIONS /home/coder/.local/share/code-server/extensions

# AZURE
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# Terraform
ENV TERRAFORM_VERSION 1.3.4
RUN wget -q -O terraform.zip https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip terraform.zip && \
    sudo install terraform /usr/local/bin/ && \
    rm -f terraform*

# Docker
ENV DOCKER_VERSION 20.10.21
RUN wget -q -O docker.tar.gz https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKER_VERSION}.tgz && \
   tar xzf docker.tar.gz && \
   sudo install docker/docker /usr/local/bin/ && \
   rm -rf docker*

# Kubectl
ENV KUBECTL_VERSION 1.23.13
RUN wget -q -O kubectl "https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl" && \
   sudo install kubectl /usr/local/bin/ && \
   rm -f kubectl*

# HELM
ENV HELM_VERSION 3.10.1
RUN wget -q -O helm.tgz "https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz" && \
    tar xzf helm.tgz && \
    sudo install linux-amd64/helm /usr/local/bin/ && \
    rm -rf linux-amd64 helm.tgz

# krew
ENV KREW_VERSION 0.4.3
RUN wget -q https://github.com/kubernetes-sigs/krew/releases/download/v${KREW_VERSION}/krew-linux_amd64.tar.gz && \
    tar xzf krew-linux_amd64.tar.gz && \
    ./krew-linux_amd64 install krew && \
    rm -rf krew* && \
    echo "export PATH=\"\${KREW_ROOT:-\$HOME/.krew}/bin:\$PATH\"" | sudo tee -a ~/.bashrc > /dev/null

# k9s
ENV K9S_VERSION 0.26.7
RUN wget -q https://github.com/derailed/k9s/releases/download/v${K9S_VERSION}/k9s_Linux_x86_64.tar.gz && \
    tar zxf k9s_Linux_x86_64.tar.gz && \
    sudo install k9s /usr/local/bin/ && \
    rm -rf k9s* README.md

# Stern
ENV STERN_VERSION 1.22.0
RUN wget -q https://github.com/stern/stern/releases/download/v${STERN_VERSION}/stern_${STERN_VERSION}_linux_amd64.tar.gz && \
    tar xzf stern_${STERN_VERSION}_linux_amd64.tar.gz && \
    sudo install stern /usr/local/bin/ && \
    rm -rf stern*

# yj
RUN wget -q -O yj https://github.com/sclevine/yj/releases/download/v5.1.0/yj-linux-amd64 && \
    sudo install yj /usr/local/bin/ && \
    rm -f yj*

RUN rm -f LICENSE README.md

# RUN code-server --extensions-dir /config/extensions --install-extension dracula-theme.theme-dracula
# RUN code-server --extensions-dir /config/extensions --install-extension MS-CEINTL.vscode-language-pack-ja
# RUN code-server --extensions-dir /config/extensions --install-extension vscode-icons-team.vscode-icons
# RUN code-server --extensions-dir /config/extensions --install-extension eamodio.gitlens
# RUN code-server --extensions-dir /config/extensions --install-extension humao.rest-client

# RUN sudo mkdir -p /home/eno/.bin && \
#     echo "export PATH=\"\$HOME/.local/bin:\$PATH\"" | sudo tee -a /home/eno/.bashrc > /dev/null

# RUN mkdir -p ${VSCODE_USER} && echo "{\"java.home\":\"$(dirname /opt/jdk-*/bin/)\",\"maven.terminal.useJavaHome\":true, \"maven.executable.path\":\"/opt/apache-maven-${MAVEN_VERSION}/bin/mvn\",\"spring-boot.ls.java.home\":\"$(dirname /opt/jdk-*/bin/)\",\"files.exclude\":{\"**/.classpath\":true,\"**/.project\":true,\"**/.settings\":true,\"**/.factorypath\":true},\"redhat.telemetry.enabled\":false,\"java.server.launchMode\": \"Standard\"}" | jq . > ${VSCODE_USER}/settings.json
# RUN echo 'for f in /etc/profile.d/*.sh;do source $f;done' | sudo tee -a /home/coder/.bashrc > /dev/null
# RUN rm -f /home/coder/.wget-hsts

ADD ./config/User/settings.json /home/coder/.local/share/code-server/User/settings.json