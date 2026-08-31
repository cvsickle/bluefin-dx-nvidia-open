FROM mcr.microsoft.com/devcontainers/base:ubuntu-24.04

ARG TARGETARCH=amd64

RUN apt-get update && apt-get install -y \
    curl \
    wget \
    tar \
    unzip \
    ca-certificates \
    gnupg \
    bash-completion \
    && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL \
    "https://github.com/sigstore/cosign/releases/latest/download/cosign-linux-amd64" \
    -o /usr/local/bin/cosign \
    && chmod +x /usr/local/bin/cosign