#!/bin/bash
opam init -y
opam install etl/ --deps-only -y
eval $(opam env)