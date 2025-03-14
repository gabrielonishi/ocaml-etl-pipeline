(*FILEPATH CONSTANTS*)
let cwd = Filename.dirname (Sys.getcwd ())
let order_csv_filepath = Filename.concat cwd "data/test/input/order.csv"
let item_csv_filepath = Filename.concat cwd "data/test/input/order_item.csv"
let output_csv_filepath = Filename.concat cwd "data/test/output/output.csv"
let args = Sys.argv
let status, origin = Lib.Io.parse_arguments args
let orders_csv = Lib.Io.read_csv order_csv_filepath
let items_csv = Lib.Io.read_csv item_csv_filepath
let order_items = Lib.Csv_parser.load_order_items orders_csv items_csv true
let order_summary_records = Lib.Process.build_output order_items status origin
let output_data = Lib.Csv_parser.convert_records_to_array order_summary_records
let () = Lib.Io.write_csv output_csv_filepath output_data
