open Schemas

(** [debug_csv csv_data] prints the contents of a CSV data structure, where each row is a list of strings.

    @param csv_data A list of string lists representing the CSV data.
    @return Unit. Prints the CSV data to the standard output.
    @raise None. *)
let debug_csv (csv_data : string list list) : unit =
  List.iter
    (fun (x : string list) ->
      List.iter (fun (y : string) -> Printf.printf "%s " y) x;
      Printf.printf "\n")
    csv_data

(** [debug_orders orders] prints the details of each order in the provided list.

    @param orders A list of [order] records to be printed.
    @return Unit. Prints the order details to the standard output.
    @raise None. *)
let debug_orders (orders : order list) : unit =
  Printf.printf "id, client_id, order_date, status, origin\n";
  List.iter
    (fun (o : order) ->
      Printf.printf "%d, %d, %s, %s, %s" o.id o.client_id o.order_date o.status
        o.origin)
    orders

(** [debug_items items] prints the details of each item in the provided list.

    @param items A list of [item] records to be printed.
    @return Unit. Prints the item details to the standard output.
    @raise None. *)
let debug_items (items : item list) : unit =
  Printf.printf "order_id, product_id, quantity, price, tax\n";
  List.iter
    (fun (i : item) ->
      Printf.printf "%d, %d, %d, %f, %f\n" i.order_id i.product_id i.quantity
        i.price i.tax)
    items

(** [debug_order_items order_items] prints the details of each order item in the provided list.

    @param order_items A list of [order_item] records to be printed.
    @return Unit. Prints the order item details to the standard output.
    @raise None. *)
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
