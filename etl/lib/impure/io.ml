open Sqlite3
open Schemas
open Lwt.Syntax
module D = Sqlite3.Data

(** [parse_arguments] parses the command-line arguments for order status and
    order type. It expects two arguments and raises an exception if the
    arguments are invalid.

    @return A tuple containing the parsed status and order type.
    @raise Failure if the arguments are not in the expected format. *)
let parse_arguments (args : string array) =
  if Array.length args != 3 then
    failwith
      "Execute com dune exec etl [pending | complete | cancelled] [physical | \
       online ]"
  else
    let status =
      match args.(1) with
      | "pending" -> "Pending"
      | "complete" -> "Complete"
      | "cancelled" -> "Cancelled"
      | _ ->
          failwith
            "Execute com dune exec etl [pending | complete | cancelled] \
             [physical | online ]"
    in
    let order =
      match args.(2) with
      | "physical" -> "P"
      | "online" -> "O"
      | _ ->
          failwith
            "Execute com dune exec etl [pending | complete | cancelled] \
             [physical | online ]"
    in
    (status, order)

(** [read_csv filepath] reads a CSV file from the specified [filepath] and
    validates its format. It expects each row to have exactly five columns,
    otherwise it raises an exception.

    @param filepath The path to the CSV file to be read.
    @return
      A list of string lists, where each inner list represents a row from the
      CSV.
    @raise Failure if a row does not contain exactly five columns. *)
let read_csv (filepath : string) : string list list =
  let data = Csv.load filepath in

  let validated_data =
    List.map
      (fun row ->
        match row with
        | [ a; b; c; d; e ] -> [ a; b; c; d; e ]
        | _ -> failwith "Formato inválido de csv")
      data
  in

  validated_data

(** [write_csv filepath data] writes the provided [data] to a CSV file at the
    specified [filepath].

    @param filepath The path to the CSV file where the data will be written.
    @param data The list of string lists to be written as rows in the CSV file.
    @return Unit.
    @raise Sys_error if the file cannot be opened or written to. *)
let write_csv (filepath : string) (data : string list list) : unit =
  let oc = open_out filepath in
  let csv_out = Csv.to_channel oc in
  Csv.output_all csv_out data;
  close_out oc

let insert_order (db : db) (order_summary : order_summary) =
  let stmt =
    prepare db
      "INSERT INTO order_summary (order_id, total_amount, total_taxes) VALUES \
       (?, ?, ?)"
  in
  let bind_value pos value =
    match bind stmt pos value with
    | Rc.OK -> ()
    | rc -> failwith ("Bind failed: " ^ Rc.to_string rc)
  in

  bind_value 1 (D.INT (Int64.of_int order_summary.order_id));
  bind_value 2 (D.FLOAT order_summary.total_amount);
  bind_value 3 (D.FLOAT order_summary.total_taxes);

  match step stmt with
  | Rc.DONE -> finalize stmt |> ignore
  | rc -> failwith ("Insert failed: " ^ Rc.to_string rc)

let read_csv_from_url url : string list list =
  let str_csv =
    Lwt_main.run
      (let* resp, body = Cohttp_lwt_unix.Client.get (Uri.of_string url) in
       let* body_str = Cohttp_lwt.Body.to_string body in
       match Cohttp.Response.status resp with
       | `OK -> Lwt.return body_str
       | _ -> Lwt.fail_with "HTTP request failed")
  in

  let channel = Csv.of_string ~has_header:true str_csv in
  Csv.input_all channel

let create_table (db : db) =
  let sql =
    "CREATE TABLE IF NOT EXISTS order_summary (\n\
    \              order_id INTEGER PRIMARY KEY,\n\
    \              total_amount REAL NOT NULL,\n\
    \              total_taxes REAL NOT NULL);"
  in

  match exec db sql with
  | Rc.OK -> ()
  | rc -> failwith ("Table creation failed: " ^ Rc.to_string rc)

let rec insert_orders (db : db) (order_summaries : order_summary list) =
  match order_summaries with
  | [] -> ()
  | order_summary :: tl ->
      insert_order db order_summary;
      insert_orders db tl

let write_db (filepath : string) (order_summary_list : order_summary list) :
    unit =
  let& db = db_open filepath in
  create_table db;
  insert_orders db order_summary_list
