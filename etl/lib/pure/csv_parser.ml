open Schemas

(** [safe_string_to_int s] converts the string [s] to an integer.
    If the conversion fails, it returns 0 instead of raising an exception.

    @param s The input string to be converted.
    @return The integer value of [s], or 0 if the conversion fails. *)
let safe_string_to_int (s : string) : int =
  let s_int = int_of_string_opt s in
  match s_int with Some s_int -> s_int | _ -> 0

(** [safe_string_to_float s] converts the string [s] to a float.
    If the conversion fails, it returns 0.0 instead of raising an exception.

    @param s The input string to be converted.
    @return The float value of [s], or 0.0 if the conversion fails. *)
let safe_string_to_float (s : string) : float =
  let s_float = float_of_string_opt s in
  match s_float with Some s_float -> s_float | _ -> 0.

(** [load_order_records orders_data] converts a list of string lists representing order data 
    into a list of [order] records. Each inner list must contain exactly five elements.

    @param orders_data A list of string lists, where each inner list represents an order.
    @return A list of [order] records.
    @raise Failure if an inner list does not contain exactly five elements. *)
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

(** [load_item_records items_data] converts a list of string lists representing item data 
    into a list of [item] records. Each inner list must contain exactly five elements.

    @param items_data A list of string lists, where each inner list represents an item.
    @return A list of [item] records.
    @raise Failure if an inner list does not contain exactly five elements. *)
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

(** [map_products this_order acc this_item] maps an [item] to an [order_item] 
    if the item's [order_id] matches the order's [id], accumulating the result.

    @param this_order The order to match against.
    @param acc The accumulator list of [order_item]s.
    @param this_item The item to check and potentially map.
    @return An updated list of [order_item]s, with the new item added if it matches the order. *)
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

(** [map_orders items acc this_order] maps all items related to [this_order] 
    into [order_item] records and accumulates them.

    @param items The list of items to be checked and mapped.
    @param acc The accumulator list of [order_item]s.
    @param this_order The order to match items against.
    @return An updated list of [order_item]s with items matching [this_order] added. *)
let map_orders (items : item list) (acc : order_item list) (this_order : order)
    : order_item list =
  List.fold_left (map_products this_order) acc items

(** [join_order_item orders items] joins orders with their corresponding items, 
    producing a list of [order_item] records.

    @param orders The list of orders.
    @param items The list of items to be matched with orders.
    @return A list of [order_item]s representing the joined order and item data. *)
let join_order_item (orders : order list) (items : item list) : order_item list
    =
  List.fold_left (map_orders items) [] orders

(** [load_order_items orders_csv items_csv header] loads and processes order and item data 
    from CSV format, returning a list of [order_item] records.

    @param orders_csv The raw order data as a list of string lists.
    @param items_csv The raw item data as a list of string lists.
    @param header A boolean indicating whether the first row contains headers and should be skipped.
    @return A list of [order_item]s representing the processed data. *)
let load_order_items orders_csv items_csv header : order_item list =
  let orders_data = if header then List.tl orders_csv else orders_csv in
  let items_data = if header then List.tl items_csv else items_csv in

  let orders = load_order_records orders_data in
  let items = load_item_records items_data in

  join_order_item orders items

(** [convert_records_to_array order_summary] converts a list of [order_summary] records 
    into a list of string lists, suitable for CSV output.

    @param order_summary The list of [order_summary] records to convert.
    @return A list of string lists, where each inner list represents an order summary row. *)
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
