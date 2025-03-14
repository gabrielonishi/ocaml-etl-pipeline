open Lib.Process
open Lib.Schemas

(*int_it_in*)
let%test "int_is_in empty list" = int_is_in 1 [] = false
let%test "int_is_in not in list" = int_is_in 1 [ 2; 3; 4 ] = false
let%test "int_is_in in list" = int_is_in 1 [ 1; 2; 3 ] = true

(*order_item_in_acc*)
let%test "order_item_in_acc not in list" =
  order_item_in_acc [ 1; 2; 3 ]
    {
      order_id = 4;
      product_id = 1;
      quantity = 1;
      price = 1.;
      tax = 1.;
      client_id = 1;
      order_date = "2024-10-02T03:05:39";
      status = "Pending";
      origin = "O";
    }
  = [ 4; 1; 2; 3 ]

let%test "order_item_in_acc in list" =
  order_item_in_acc [ 1; 2; 3 ]
    {
      order_id = 2;
      product_id = 1;
      quantity = 1;
      price = 1.;
      tax = 1.;
      client_id = 1;
      order_date = "2024-10-02T03:05:39";
      status = "Pending";
      origin = "O";
    }
  = [ 1; 2; 3 ]

(*process_order*)
(*type order_item = {
  order_id : int;
  product_id : int;
  quantity : int;
  price : float;
  tax : float;
  client_id : int;
  order_date : string;
  status : string;
  origin : string;
}*)

let unrepeated_ids_order_items =
  [
    {
      order_id = 1;
      product_id = 100;
      quantity = 12;
      price = 10.4;
      tax = 0.2;
      client_id = 100;
      order_date = "2024-10-02T03:05:39";
      status = "Pending";
      origin = "O";
    };
    {
      order_id = 1;
      product_id = 101;
      quantity = 1;
      price = 50.;
      tax = 0.1;
      client_id = 100;
      order_date = "2024-10-02T03:05:39";
      status = "Pending";
      origin = "O";
    };
  ]

let order_items =
  {
    order_id = 2;
    product_id = 100;
    quantity = 12;
    price = 10.4;
    tax = 0.2;
    client_id = 100;
    order_date = "2024-10-02T03:05:39";
    status = "Pending";
    origin = "O";
  }
  :: unrepeated_ids_order_items

let%test "process_order" =
  let res = process_order unrepeated_ids_order_items in
  let exp =
    {
      order_id = 1;
      total_amount = (12. *. 10.4) +. (1. *. 50.);
      total_taxes = (12. *. 10.4 *. 0.2) +. (1. *. 50. *. 0.1);
    }
  in
  res = exp

(*group_by_ids*)
let%test "group_by_ids" =
  let res = group_by_ids order_items in
  let exp =
    [
      {
        order_id = 2;
        total_amount = 12. *. 10.4;
        total_taxes = 12. *. 10.4 *. 0.2;
      };
      {
        order_id = 1;
        total_amount = (12. *. 10.4) +. (1. *. 50.);
        total_taxes = (12. *. 10.4 *. 0.2) +. (1. *. 50. *. 0.1);
      };
    ]
  in
  res = exp
