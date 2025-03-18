# Base image with VS Code setup
FROM mcr.microsoft.com/vscode/devcontainers/base:ubuntu-22.04

# Install dependencies for OCaml
RUN apt-get update && apt-get install -y \
    opam \
    m4 \
    pkg-config \
    git \
    curl \
    build-essential \
    libpcre3-dev \
    libsqlite3-dev && \
    libgmp-dev && \
    opam init -y

COPY postCreate.sh /home/vscode/postCreate.sh
RUN chmod +x /home/vscode/postCreate.sh

USER vscode
