opam init --compiler=5.2.0 --disable-sandboxing -y
echo "test -r /home/vscode/.opam/opam-init/init.sh && . /home/vscode/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true" >> ~/.bashrc
opam install etl/ --deps-only -y
opam install -y ocamlformat user-setup ocaml-lsp-server utop
opam user-setup install