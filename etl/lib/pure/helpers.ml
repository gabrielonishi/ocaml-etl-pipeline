type order = {
  id: int;
  client_id: int;
  order_date: string;
  status: string;
  origin: string;
} ;;

type item = {
  order_id: int;
  product_id: int;
  quantity: int;
  price: float;
  tax: float;
} ;;

type order_item = {
  order_id: int;
  product_id: int;
  quantity: int;
  price: float;
  tax: float;
  client_id: int;
  order_date: string;
  status: string;
  origin: string;
} ;;

let load_order_records (order_data : string list list) : order list =
  let csv_data = List.tl order_data in
  List.fold_left (fun acc this_order ->
    match this_order with
    | [a; b; c; d; e] ->
        {
          id = int_of_string a;
          client_id = int_of_string b;
          order_date = c;
          status = d;
          origin = e;
        } :: acc
    | _ -> failwith "Unexpected number of items in row"
  ) [] csv_data ;;

let load_item_records (item_data : string list list) : item list =
  let csv_data = List.tl item_data in
  List.fold_left (fun acc this_item ->
    match this_item with
    | [a; b; c; d; e] ->
        {
          order_id = int_of_string a;
          product_id = int_of_string b;
          quantity = int_of_string c;
          price = float_of_string d;
          tax = float_of_string e;
        } :: acc
    | _ -> failwith "Unexpected number of items in row"
  ) [] csv_data ;;

let product_map (this_order : order) (acc : order_item list) (this_item : item) : order_item list =
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
    } :: acc
  else acc

let order_map (items: item list) (acc : order_item list) (this_order : order) : order_item list =
  List.fold_left (product_map this_order) acc items ;;

let join_order_item (orders : order list) (items : item list) : order_item list =
  List.fold_left (order_map items) [] orders ;;
