open Lib.Helpers

let order_data = Lib.Read.read_order ;;
let orders = load_order_records order_data ;;

let item_data = Lib.Read.read_item ;;
let items = load_item_records item_data ;;

let t = join_order_item orders items ;;

let () = List.iter (
  fun x -> Printf.printf "%d %d\n" x.order_id x.product_id
  ) t ;;

(* let () = List.iter (
  fun x -> Printf.printf "%f\n" x.tax
  ) items ;; *)

