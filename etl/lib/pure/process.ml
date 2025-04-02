open Schemas
module IntMap = Map.Make (Int)

let group_by key_extractor value_extractor aggregate_handler lst =
  List.fold_left
    (fun map element ->
      let group_key = key_extractor element in
      let current_value = value_extractor element in
      IntMap.update group_key
        (function
          | Some existing -> Some (aggregate_handler existing current_value)
          | None -> Some current_value)
        map)
    IntMap.empty lst

let group_by_order_id (order_items : order_item list) : order_total IntMap.t =
  let key_extractor (order_item : order_item) : int = order_item.order_id in
  let value_extractor (order_item : order_item) : order_total =
    {
      order_id = order_item.order_id;
      total_amount = float_of_int order_item.quantity *. order_item.price;
      total_taxes =
        float_of_int order_item.quantity *. order_item.price *. order_item.tax;
    }
  in
  let aggregate_handler (acc : order_total)
      (current_order_summary : order_total) : order_total =
    {
      order_id = acc.order_id;
      total_amount = acc.total_amount +. current_order_summary.total_amount;
      total_taxes = acc.total_taxes +. current_order_summary.total_taxes;
    }
  in
  group_by key_extractor value_extractor aggregate_handler order_items

let build_output (order_items : order_item list) (status : string)
    (origin : string) : order_total IntMap.t =
  let filtered_order_items : order_item list =
    List.filter
      (fun (o : order_item) -> o.status = status && o.origin = origin)
      order_items
  in
  group_by_order_id filtered_order_items
