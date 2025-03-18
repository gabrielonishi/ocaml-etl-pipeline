(*FILEPATH CONSTANTS*)
let cwd = Filename.dirname (Sys.getcwd ())
let db_filepath = Filename.concat cwd "data/test/output/output.db"

let base_csv_uri =
  "https://raw.githubusercontent.com/gabrielonishi/ocaml-etl-pipeline-data/main/"
(* let order_csv_filepath = Filename.concat cwd "data/test/input/order.csv"
let item_csv_filepath = Filename.concat cwd "data/test/input/order_item.csv" *)
(* let output_csv_filepath = Filename.concat cwd "data/test/output/output.csv" *)

let args = Sys.argv
let status, origin = Lib.Io.parse_arguments args

(* let orders_csv = Lib.Io.read_csv order_csv_filepath
let items_csv = Lib.Io.read_csv item_csv_filepath *)
let orders_csv = Lib.Io.read_csv_from_url (base_csv_uri ^ "order.csv")
let items_csv = Lib.Io.read_csv_from_url (base_csv_uri ^ "order_item.csv")
let order_items = Lib.Csv_parser.load_order_items orders_csv items_csv
let order_summary_records = Lib.Process.build_output order_items status origin
let () = Lib.Debug.debug_order_items order_items
let () = Lib.Io.write_db db_filepath order_summary_records
(* let output_data = Lib.Csv_parser.build_csv_output order_summary_records
let () = Lib.Io.write_csv output_csv_filepath output_data *)
