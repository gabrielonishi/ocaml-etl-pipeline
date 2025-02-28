let data_path = Filename.dirname (Sys.getcwd ()) ^ "/data/test"
let input_path = data_path ^ "/input"
let output_path = data_path ^ "/output"

let read_csv filename = Csv.load filename
let read_item = read_csv (input_path ^ "/order_item.csv")
let read_order = read_csv (input_path ^ "/order.csv")

let write_csv data =
  let filepath = output_path ^ "/output.csv" in
  let oc = open_out filepath in
  let csv_out = Csv.to_channel oc in
  Csv.output_all csv_out data;
  close_out oc
