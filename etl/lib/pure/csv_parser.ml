open Schemas

let load_order_records (orders_data : string list list) : order list =
  List.fold_left
    (fun acc this_order ->
      match this_order with
      | [ a; b; c; d; e ] ->
          {
            id = int_of_string a;
            client_id = int_of_string b;
            order_date = c;
            status = d;
            origin = e;
          }
          :: acc
      | _ -> failwith "Unexpected number of items in row")
    [] orders_data

let load_item_records (items_data : string list list) : item list =
  List.fold_left
    (fun acc this_item ->
      match this_item with
      | [ a; b; c; d; e ] ->
          {
            order_id = int_of_string a;
            product_id = int_of_string b;
            quantity = int_of_string c;
            price = float_of_string d;
            tax = float_of_string e;
          }
          :: acc
      | _ -> failwith "Unexpected number of items in row")
    [] items_data

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
