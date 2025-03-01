open Schemas

let rec int_is_in (el : int) (lst : int list) : bool =
  match lst with
  | [] -> false
  | h :: t -> if h = el then true else int_is_in el t

let order_item_in_acc (acc : int list) (order_item : order_item) =
  let this_id = order_item.order_id in
  if not (int_is_in this_id acc) then order_item.order_id :: acc else acc

let unrepeated_ids (order_items : order_item list) : int list =
  List.fold_left order_item_in_acc [] order_items

let process_order (order_items : order_item list) : order_summary =
  List.fold_left
    (fun acc order_item ->
      let total_amount = order_item.price *. float_of_int order_item.quantity in
      {
        order_id = order_item.order_id;
        total_amount = acc.total_amount +. total_amount;
        total_taxes = acc.total_taxes +. (total_amount *. order_item.tax);
      })
    { order_id = 0; total_amount = 0.; total_taxes = 0. }
    order_items

let group_by_ids (order_items : order_item list) : order_summary list =
  let ids = unrepeated_ids order_items in
  List.fold_left
    (fun (acc : order_summary list) (id : int) ->
      let filtered_order =
        List.filter (fun (o : order_item) -> o.order_id = id) order_items
      in
      let compiled_order = process_order filtered_order in
      compiled_order :: acc)
    [] ids

let build_output (order_items : order_item list) (status : string)
    (origin : string) : order_summary list =
  let filtered_order_items : order_item list =
    List.filter
      (fun (o : order_item) -> o.status = status && o.origin = origin)
      order_items
  in

  group_by_ids filtered_order_items
