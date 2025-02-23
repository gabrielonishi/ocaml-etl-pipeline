#!/bin/bash
opam init -y
opam install etl/ --deps-only -y
eval $(opam env)
echo 'opam install . --deps-only -y' >> ~/.bashrc
echo 'eval $(opam env)' >> ~/.bashrc
