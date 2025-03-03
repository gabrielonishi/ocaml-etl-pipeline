open Schemas

(** [int_is_in el lst] checks if the integer [el] is present in the list [lst].

    @param el The integer to search for in the list.
    @param lst The list of integers to search through.
    @return [true] if [el] is found in [lst], otherwise [false].
    @raise None. *)
let rec int_is_in (el : int) (lst : int list) : bool =
  match lst with
  | [] -> false
  | h :: t -> if h = el then true else int_is_in el t

(** [order_item_in_acc acc order_item] adds the [order_id] of the given [order_item] 
    to the accumulator list [acc] if it is not already present.

    @param acc The accumulator list of order IDs.
    @param order_item The order item whose [order_id] is being checked and added.
    @return The updated accumulator list, possibly with the [order_id] added.
    @raise None. *)
let order_item_in_acc (acc : int list) (order_item : order_item) =
  let this_id = order_item.order_id in
  if not (int_is_in this_id acc) then order_item.order_id :: acc else acc

(** [process_order order_items] processes a list of [order_item]s and computes the total amount 
    and total taxes for the corresponding order.

    @param order_items A list of [order_item] records to be processed.
    @return An [order_summary] record containing the total amount and total taxes for the order.
    @raise None. *)
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

(** [group_by_ids order_items] groups a list of [order_item]s by their [order_id] 
    and processes each group to compute a summary of total amounts and total taxes.

    @param order_items A list of [order_item] records to be grouped and processed.
    @return A list of [order_summary] records, one for each unique [order_id].
    @raise None. *)
let group_by_ids (order_items : order_item list) : order_summary list =
  let unrepeated_ids = List.fold_left order_item_in_acc [] order_items in
  List.fold_left
    (fun (acc : order_summary list) (id : int) ->
      let filtered_order =
        List.filter (fun (o : order_item) -> o.order_id = id) order_items
      in
      let compiled_order = process_order filtered_order in
      compiled_order :: acc)
    [] ids

(** [build_output order_items status origin] filters the [order_item] list by [status] and [origin], 
    and then groups the filtered items by their [order_id] to generate a summary of the order's totals.

    @param order_items A list of [order_item] records to be filtered and grouped.
    @param status The status of the orders to filter by.
    @param origin The origin of the orders to filter by.
    @return A list of [order_summary] records, each representing a unique order with the specified [status] and [origin].
    @raise None. *)
let build_output (order_items : order_item list) (status : string)
    (origin : string) : order_summary list =
  let filtered_order_items : order_item list =
    List.filter
      (fun (o : order_item) -> o.status = status && o.origin = origin)
      order_items
  in
  group_by_ids filtered_order_items
