opam init -y && \
eval $(opam env)
opam install etl/ --deps-only -y
opam install -y ocamlformat user-setup
opam user-setup install
echo 'opam install . --deps-only -y' >> ~/.bashrc
echo 'eval $(opam env)' >> ~/.bashrc
