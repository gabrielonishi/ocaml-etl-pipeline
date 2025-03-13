# ETL Pipeline in OCaml

## Running the Project

This project uses a DevContainer to isolate the development environment. Make sure you have Docker and the DevContainer VsCode extension installed. You can also build the image located on `./devcontainer/Dockerfile` separately.

To access the container shell, execute

```bash
docker exec -it CONTAINER_NAME /bin/bash
sudo su vscode
cd /workspaces/ocaml-etl-pipeline
```

To run the project, execute

```bash
#On the /etl folder
dune build
dune exec etl

# Or with debugging on
OCAMLRUNPARAM=b dune exec etl
```

Running the formatter

```bash
dune build @fmt
dune promote
```

### Resources

 - [Official OCaml Documentation](https://ocaml.org/)
 - [Real World OCaml](https://dev.realworldocaml.org/)
 - [ChatGPT](https://chatgpt.com/)
 - [DeepSeek](https://chat.deepseek.com/)