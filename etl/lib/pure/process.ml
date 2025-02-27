open Schemas

let calculate_totals order_items = 
  List.map
    (fun order_item ->
      let total_amount = order_item.price *. (float_of_int order_item.quantity) in
      {
        order_id = order_item.order_id;
        total_amount = total_amount;
        total_taxes = total_amount *. order_item.tax;
      } )
    order_items ;;
