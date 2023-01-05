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

# HELM
ENV HELM_VERSION 3.10.1
RUN wget -q -O helm.tgz "https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz" && \
    tar xzf helm.tgz && \
    sudo install linux-amd64/helm /usr/local/bin/ && \
    rm -rf linux-amd64 helm.tgz

# Terraform
ENV TERRAFORM_VERSION 1.3.4
RUN wget -q -O terraform.zip https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip terraform.zip && \
    sudo install terraform /usr/local/bin/ && \
    rm -f terraform*

# yj
RUN wget -q -O yj https://github.com/sclevine/yj/releases/download/v5.1.0/yj-linux-amd64 && \
    sudo install yj /usr/local/bin/ && \
    rm -f yj*

# ytt
ENV YTT_VERSION 0.43.0
RUN wget -q -O ytt https://github.com/vmware-tanzu/carvel-ytt/releases/download/v${YTT_VERSION}/ytt-linux-amd64 && \
    sudo install ytt /usr/local/bin/ && \
    rm -f ytt*

# krew
ENV KREW_VERSION 0.4.3
RUN wget -q https://github.com/kubernetes-sigs/krew/releases/download/v${KREW_VERSION}/krew-linux_amd64.tar.gz && \
    tar xzf krew-linux_amd64.tar.gz && \
    ./krew-linux_amd64 install krew && \
    rm -rf krew* && \
    echo "export PATH=\"\${KREW_ROOT:-\$HOME/.krew}/bin:\$PATH\"" | sudo tee -a /home/coder/.bashrc > /dev/null

# Tilt
ENV TILT_VERSION=0.30.11
RUN wget -q -O tilt.tar.gz https://github.com/tilt-dev/tilt/releases/download/v${TILT_VERSION}/tilt.${TILT_VERSION}.linux.x86_64.tar.gz && \
    tar xzf tilt.tar.gz && \
    sudo install tilt /usr/local/bin/ && \
    rm -rf tilt*

# Stern
ENV STERN_VERSION 1.22.0
RUN wget -q https://github.com/stern/stern/releases/download/v${STERN_VERSION}/stern_${STERN_VERSION}_linux_amd64.tar.gz && \
    tar xzf stern_${STERN_VERSION}_linux_amd64.tar.gz && \
    sudo install stern /usr/local/bin/ && \
    rm -rf stern*

# k9s
ENV K9S_VERSION 0.26.7
RUN wget -q https://github.com/derailed/k9s/releases/download/v${K9S_VERSION}/k9s_Linux_x86_64.tar.gz && \
    tar zxf k9s_Linux_x86_64.tar.gz && \
    sudo install k9s /usr/local/bin/ && \
    rm -rf k9s* README.md

# Docker
ENV DOCKER_VERSION 20.10.21
RUN wget -q -O docker.tar.gz https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKER_VERSION}.tgz && \
    tar xzf docker.tar.gz && \
    sudo install docker/docker /usr/local/bin/ && \
    rm -rf docker*

# SCDF Shell
ENV SCDF_VERSION 2.9.6
RUN wget -q https://repo.spring.io/release/org/springframework/cloud/spring-cloud-dataflow-shell/${SCDF_VERSION}/spring-cloud-dataflow-shell-${SCDF_VERSION}.jar && \
    sudo mv spring-cloud-dataflow-shell-${SCDF_VERSION}.jar /opt/

# WebSocat
ENV WEBSOCAT_VERSION=1.11.0
RUN wget -q -O websocat https://github.com/vi/websocat/releases/download/v${WEBSOCAT_VERSION}/websocat.x86_64-unknown-linux-musl && \
    sudo install websocat /usr/local/bin/ && \
    rm -f websocat*

# AZURE
RUN wget -q -O az.deb https://packages.microsoft.com/repos/azure-cli/pool/main/a/azure-cli/azure-cli_2.42.0-1~focal_all.deb && \
    sudo dpkg -i az.deb && \
    rm -f az.deb

RUN /home/coder/.krew/bin/kubectl-krew install tree && \
    /home/coder/.krew/bin/kubectl-krew install neat

RUN wget -q https://github.com/jonmosco/kube-ps1/raw/master/kube-ps1.sh && \
    sudo mv kube-ps1.sh /opt/

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
