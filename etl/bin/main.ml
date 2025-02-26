open Lib.Csv_parser
open Lib.Schemas

let orders_csv = Lib.Read.read_order ;;
let items_csv = Lib.Read.read_item ;;

let order_item_list = load_order_items orders_csv items_csv true ;;

let () = List.iter (
  fun x -> Printf.printf "%d %d\n" x.order_id x.product_id
  ) order_item_list ;;

(* let () = List.iter (
  fun x -> Printf.printf "%f\n" x.tax
  ) items ;; *)

