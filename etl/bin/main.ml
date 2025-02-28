open Lib.Csv_parser
open Lib.Schemas
open Lib.Process

let status, origin =
  if Array.length Sys.argv != 3 then 
    failwith "Execute com dune exec etl [pending | complete | cancelled] [physical | online | all]"
  else 
    let s = (
      match Sys.argv.(1) with
        | "pending" -> "Pending"
        | "complete" -> "Complete"
        | "cancelled" -> "Cancelled"
        | _ -> failwith "Execute com dune exec etl [pending | complete | cancelled] [physical | online | all]") in
    let o = (
      match Sys.argv.(2) with
        | "physical" -> "P"
        | "online" -> "O"
        | _ -> failwith "Execute com dune exec etl [pending | complete | cancelled] [physical | online | all]") in
    s, o

let orders_csv = Lib.Read.read_order ;;
let items_csv = Lib.Read.read_item ;;
let order_items = load_order_items orders_csv items_csv true ;;
let output = build_output order_items status origin ;;

let print_output (res : order_summary) =
  Printf.printf "%d %f %f\n" res.order_id res.total_amount res.total_taxes ;;

let () = List.iter print_output output ;;