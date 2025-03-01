open Schemas

let safe_string_to_int (s : string) : int =
  let s_int = int_of_string_opt s in
  match s_int with Some s_int -> s_int | _ -> 0

let safe_string_to_float (s : string) : float =
  let s_float = float_of_string_opt s in
  match s_float with Some s_float -> s_float | _ -> 0.

let load_order_records (orders_data : string list list) : order list =
  List.map
    (fun this_order ->
      match this_order with
      | [ a; b; c; d; e ] ->
          {
            id = safe_string_to_int a;
            client_id = safe_string_to_int b;
            order_date = c;
            status = d;
            origin = e;
          }
      | _ -> failwith "Unexpected number of items in row")
    orders_data

let load_item_records (items_data : string list list) : item list =
  List.map
    (fun this_item ->
      match this_item with
      | [ a; b; c; d; e ] ->
          {
            order_id = safe_string_to_int a;
            product_id = safe_string_to_int b;
            quantity = safe_string_to_int c;
            price = safe_string_to_float d;
            tax = safe_string_to_float e;
          }
      | _ -> failwith "Unexpected number of items in row")
    items_data

let map_products (this_order : order) (acc : order_item list) (this_item : item)
    : order_item list =
  if this_item.order_id = this_order.id then
    {
      order_id = this_item.order_id;
      product_id = this_item.product_id;
      quantity = this_item.quantity;
      price = this_item.price;
      tax = this_item.tax;
      client_id = this_order.client_id;
      order_date = this_order.order_date;
      status = this_order.status;
      origin = this_order.origin;
    }
    :: acc
  else acc

let map_orders (items : item list) (acc : order_item list) (this_order : order)
    : order_item list =
  List.fold_left (map_products this_order) acc items

let join_order_item (orders : order list) (items : item list) : order_item list
    =
  List.fold_left (map_orders items) [] orders

let load_order_items orders_csv items_csv header : order_item list =
  let orders_data = if header then List.tl orders_csv else orders_csv in
  let items_data = if header then List.tl items_csv else items_csv in

  let orders = load_order_records orders_data in
  let items = load_item_records items_data in

  join_order_item orders items

let convert_records_to_array (order_summary : order_summary list) :
    string list list =
  List.map
    (fun (order : order_summary) ->
      [
        string_of_int order.order_id;
        string_of_float order.total_amount;
        string_of_float order.total_taxes;
      ])
    order_summary
