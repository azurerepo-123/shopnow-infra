FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    ca-certificates \
    curl \
    dos2unix \
    git \
    jq \
    libicu74 \
    libkrb5-3 \
    libssl3 \
    tar \
    unzip \
    zlib1g \
    && rm -rf /var/lib/apt/lists/*

RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash \
    && rm -rf /var/lib/apt/lists/*

ARG TERRAFORM_VERSION="1.10.5"
RUN curl -fsSL https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip -o terraform.zip \
    && unzip terraform.zip -d /usr/local/bin/ \
    && rm terraform.zip

RUN useradd -m -u 1001 azp && \
    mkdir -p /azp && \
    chown -R azp:azp /azp

WORKDIR /azp

COPY ./start.sh .
RUN dos2unix ./start.sh && chmod +x ./start.sh && chown azp:azp ./start.sh

USER 1000

ENTRYPOINT ["./start.sh"]