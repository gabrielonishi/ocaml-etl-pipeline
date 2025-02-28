open Lib.Csv_parser
(* open Lib.Schemas *)
open Lib.Process
open Lib.Io

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

let orders_csv = read_order ;;
let items_csv = read_item ;;
let order_items = load_order_items orders_csv items_csv true ;;
let order_summary_records = build_output order_items status origin ;;
let output = convert_records_to_array order_summary_records ;;
let () = write_csv output ;;
(* let () =
  List.iter (
    fun (x: string list) -> 
      List.iter (
        fun (y: string) ->
          Printf.printf "%s " y
    ) x;
    Printf.printf "\n"
  ) output *)

(* let print_output (res : string list) =
  Printf.printf "%s %s %s\n" res.order_id res.total_amount res.total_taxes ;;

let () = List.iter print_output output ;; *)