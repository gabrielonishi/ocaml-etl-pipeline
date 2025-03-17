open Schemas

(** [safe_string_to_int s] converts the string [s] to an integer. If the
    conversion fails, it returns 0 instead of raising an exception.

    @param s The input string to be converted.
    @return The integer value of [s], or 0 if the conversion fails. *)
let safe_string_to_int (s : string) : int =
  let s_int = int_of_string_opt s in
  match s_int with Some s_int -> s_int | _ -> 0

(** [safe_string_to_float s] converts the string [s] to a float. If the
    conversion fails, it returns 0.0 instead of raising an exception.

    @param s The input string to be converted.
    @return The float value of [s], or 0.0 if the conversion fails. *)
let safe_string_to_float (s : string) : float =
  let s_float = float_of_string_opt s in
  match s_float with Some s_float -> s_float | _ -> 0.

(** [load_order_records orders_data] converts a list of string lists
    representing order data into a list of [order] records. Each inner list must
    contain exactly five elements.

    @param orders_data
      A list of string lists, where each inner list represents an order.
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
      | _ ->
          { id = 0; client_id = 0; order_date = ""; status = ""; origin = "" })
    orders_data

(** [load_item_records items_data] converts a list of string lists representing
    item data into a list of [item] records. Each inner list must contain
    exactly five elements.

    @param items_data
      A list of string lists, where each inner list represents an item.
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
      | _ ->
          { order_id = 0; product_id = 0; quantity = 0; price = 0.; tax = 0. })
    items_data

(** [load_order_items orders_csv items_csv header] constructs a list of
    [order_item] records by combining order and item data from CSV input.

    @param orders_csv
      A list of string lists, where each inner list represents an order.
    @param items_csv
      A list of string lists, where each inner list represents an item.
    @return
      A list of [order_item] records, each combining information from an order
      and its corresponding items.
    @raise Failure if the CSV data does not conform to expected formats. *)
let load_order_items orders_csv items_csv : order_item list =
  (*Considers all input csvs comes with header*)
  let orders_data = List.tl orders_csv in
  let items_data = List.tl items_csv in

  let orders = load_order_records orders_data in
  let items = load_item_records items_data in

  let order_items : order_item list =
    List.fold_left
      (fun (order_items_acc : order_item list) (order : order) ->
        let items_from_order =
          List.filter (fun (item : item) -> item.order_id = order.id) items
        in
        List.fold_left
          (fun (acc : order_item list) (item : item) ->
            {
              order_id = item.order_id;
              product_id = item.product_id;
              quantity = item.quantity;
              price = item.price;
              tax = item.tax;
              client_id = order.client_id;
              order_date = order.order_date;
              status = order.status;
              origin = order.origin;
            }
            :: acc)
          order_items_acc items_from_order)
      [] orders
  in

  List.rev order_items

(** [convert_records_to_array order_summary] converts a list of [order_summary]
    records into a list of string lists, suitable for CSV output.

    @param order_summary The list of [order_summary] records to convert.
    @return
      A list of string lists, where each inner list represents an order summary
      row. *)
let build_csv_output (order_summary : order_summary list) : string list list =
  let header = [ "order_id"; "total_amount"; "total_taxes" ] in
  let value_rows =
    List.map
      (fun (order : order_summary) ->
        [
          string_of_int order.order_id;
          string_of_float order.total_amount;
          string_of_float order.total_taxes;
        ])
      order_summary
  in
  header :: value_rows
