# Base image with VS Code setup
FROM mcr.microsoft.com/vscode/devcontainers/base:ubuntu-22.04

# Install dependencies for OCaml
RUN apt-get update && apt-get install -y \
    opam \
    m4 \
    pkg-config \
    git \
    curl \
    build-essential && \
    opam init -y && \
    opam install -y dune utop ocaml-lsp-server earlybird

USER vscode
COPY postCreate.sh /home/vscode/postCreate.sh
COPY postAttach.sh /home/vscode/postAttach.sh

USER root
RUN chmod +x /home/vscode/postCreate.sh
RUN chmod +x /home/vscode/postAttach.sh
