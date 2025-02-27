open Lib.Csv_parser
open Lib.Schemas
open Lib.Process

let orders_csv = Lib.Read.read_order
let items_csv = Lib.Read.read_item
let order_items = load_order_items orders_csv items_csv true
let output = group_by_ids order_items

let print_output res =
  Printf.printf "%d %f %f\n" res.order_id res.total_amount res.total_taxes

let () = List.iter print_output output
