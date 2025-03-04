let () = Dotenv.export ~path:"../.env" () |> ignore

(** [get_full_filepath filepath] computes the full file path by combining the
    current working directory with the provided relative file path.

    @param filepath
      The file path from project root to be combined with the current working
      directory.
    @return The full file path as a string.
    @raise Invalid_argument if the provided filepath is not valid. *)
let get_full_filepath (filepath : string) : string =
  let root_dir = Filename.dirname (Sys.getcwd ()) in
  Filename.concat root_dir filepath

(** [fetch_filepaths] retrieves the file paths for orders, order items, and
    output from environment variables. If a required variable is not set, it
    raises an exception.

    @return
      A tuple containing the full file paths for orders, order items, and
      output.
    @raise Failure if any required environment variable is missing. *)
let fetch_filepaths =
  let orders_filepath =
    match Sys.getenv_opt "ORDER_FILEPATH" with
    | Some path -> path
    | None -> failwith "OUTPUT_FILEPATH is not set."
  in
  let items_filepath =
    match Sys.getenv_opt "ORDER_ITEM_FILEPATH" with
    | Some path -> path
    | None -> failwith "ORDER_ITEM_FILEPATH is not set."
  in
  let output_filepath =
    match Sys.getenv_opt "OUTPUT_FILEPATH" with
    | Some path -> path
    | None -> failwith "OUTPUT_FILEPATH is not set."
  in
  ( get_full_filepath orders_filepath,
    get_full_filepath items_filepath,
    get_full_filepath output_filepath )
