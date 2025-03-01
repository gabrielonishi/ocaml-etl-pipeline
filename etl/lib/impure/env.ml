let () = Dotenv.export ~path:"../.env" () |> ignore

let get_full_filepath (filepath: string) : string =
  let root_dir = Filename.dirname (Sys.getcwd ()) in
  Filename.concat root_dir filepath

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
    | None -> failwith "OUTPUT_FILEPATH is not set." in
  (get_full_filepath orders_filepath, 
  get_full_filepath items_filepath, 
  get_full_filepath output_filepath)