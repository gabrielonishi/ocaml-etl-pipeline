# ETL Pipeline in OCaml

## Running the Project

This project uses a DevContainer to isolate the development environment. Make sure you have Docker and the DevContainer VsCode extension installed. You can also build the image located on `./devcontainer/Dockerfile` separately.

### To access the container shell, execute

```bash
docker exec -it CONTAINER_NAME /bin/bash
cd /workspaces/ocaml-etl-pipeline
```

### To run the project, execute

```bash
#On the /etl folder
dune build
dune exec etl

# Or with debugging with
OCAMLRUNPARAM=b dune exec etl
```

### To run the formatter

```bash
dune build @fmt
dune promote

# Or, to do both
dune build @fmt --autopromote
```

### To run tests
```bash
# Simple testing
dune test

# Or, to generate coverage report
dune runtest --instrument-with bisect_ppx --force
bisect-ppx-report html
```

### To use text completion (vscode)

Click on `Extensions` on the side bar, then under `Commands` and `Select a Sandbox`, choose `5.2.0`.


### Resources

 - [Official OCaml Documentation](https://ocaml.org/)
 - [Real World OCaml](https://dev.realworldocaml.org/)
 - [ChatGPT](https://chatgpt.com/)
 - [DeepSeek](https://chat.deepseek.com/)
