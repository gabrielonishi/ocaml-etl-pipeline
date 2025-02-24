let data_path = Filename.dirname (Sys.getcwd()) ^ "/data" ;;
let input_path = data_path ^ "/input" ;;

let read_csv filename = Csv.load filename

let read_item = read_csv (input_path ^ "/order_item.csv")
let read_order = read_csv (input_path ^ "/order.csv")