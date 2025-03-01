open Schemas

let debug_csv (csv_data : string list list) : unit =
  List.iter
    (fun (x : string list) ->
      List.iter (fun (y : string) -> Printf.printf "%s " y) x;
      Printf.printf "\n")
    csv_data

let debug_orders (orders : order list) : unit =
  Printf.printf "id, client_id, order_date, status, origin\n";
  List.iter
    (fun (o : order) ->
      Printf.printf "%d, %d, %s, %s, %s" o.id o.client_id o.order_date o.status
        o.origin)
    orders

let debug_items (items : item list) : unit =
  Printf.printf "order_id, product_id, quantity, price, tax\n";
  List.iter
    (fun (i : item) ->
      Printf.printf "%d, %d, %d, %f, %f\n" i.order_id i.product_id i.quantity
        i.price i.tax)
    items

let debug_order_items (order_items : order_item list) : unit =
  Printf.printf
    "order_id, product_id, quantity, price, tax, client_id, order_date, \
     status, origin\n";
  List.iter
    (fun (oi : order_item) ->
      Printf.printf "%d, %d, %d, %f, %f, %d, %s, %s, %s\n" oi.order_id
        oi.product_id oi.quantity oi.price oi.tax oi.client_id oi.order_date
        oi.status oi.origin)
    order_items
