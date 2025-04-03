open Lib.Schemas
open Lib.Process
open Testables

let test_group_by (data : 'a list) (expected : 'b IntMap.t)
    (key_extractor : 'a -> int) (value_extractor : 'a -> 'b)
    (aggregate_handler : 'b -> 'b -> 'b) (value_testable : 'b Alcotest.testable)
    () =
  let result = group_by key_extractor value_extractor aggregate_handler data in
  Alcotest.(check (map_testable value_testable)) "group_by" expected result

let items =
  [
    { order_id = 1; product_id = 100; quantity = 12; price = 10.4; tax = 0.2 };
    { order_id = 2; product_id = 100; quantity = 1; price = 50.; tax = 0.1 };
  ]

let group_by_suite =
  [
    ( "Group record",
      `Quick,
      let expected =
        IntMap.of_list
          [
            ( 100,
              {
                order_id = 3;
                product_id = 100;
                quantity = 13;
                price = 60.4;
                tax = 0.3;
              } );
          ]
      in
      let key_extractor (item : item) : int = item.product_id in
      let value_extractor (item : item) : item = item in
      let aggregate_handler (acc : item) (current_item : item) : item =
        {
          order_id = acc.order_id + current_item.order_id;
          product_id = acc.product_id;
          quantity = acc.quantity + current_item.quantity;
          price = acc.price +. current_item.price;
          tax = acc.tax +. current_item.tax;
        }
      in
      test_group_by items expected key_extractor value_extractor
        aggregate_handler item_testable );
    ( "Group int",
      `Quick,
      let expected = IntMap.empty |> IntMap.add 100 13 in
      let key_extractor (item : item) : int = item.product_id in
      let value_extractor (item : item) : int = item.quantity in
      let aggregate_handler (acc : int) (current_item : int) : int =
        acc + current_item
      in
      test_group_by items expected key_extractor value_extractor
        aggregate_handler Alcotest.int );
  ]

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

let test_group_by_order_id (data : order_item list)
    (expected : order_total IntMap.t) () =
  let result = group_by_order_id data in
  Alcotest.(check (map_testable order_total_testable))
    "group_by_order_id" expected result

let order_items =
  [
    {
      order_id = 1;
      product_id = 100;
      quantity = 12;
      price = 10.4;
      tax = 0.2;
      client_id = 1;
      order_date = "2023-01-01";
      status = "completed";
      origin = "online";
    };
    {
      order_id = 1;
      product_id = 101;
      quantity = 1;
      price = 50.;
      tax = 0.1;
      client_id = 1;
      order_date = "2023-01-01";
      status = "completed";
      origin = "online";
    };
    {
      order_id = 2;
      product_id = 100;
      quantity = 1;
      price = 50.;
      tax = 0.1;
      client_id = 2;
      order_date = "2023-01-02";
      status = "completed";
      origin = "online";
    };
  ]

let group_by_order_id_suite =
  [
    ( "Group by order_id",
      `Quick,
      let expected =
        IntMap.of_list
          [
            ( 1,
              {
                order_id = 1;
                total_amount = (12. *. 10.4) +. (1. *. 50.);
                total_taxes = (12. *. 10.4 *. 0.2) +. (1. *. 50. *. 0.1);
              } );
            ( 2,
              {
                order_id = 2;
                total_amount = 1. *. 50.;
                total_taxes = 1. *. 50. *. 0.1;
              } );
          ]
      in
      test_group_by_order_id order_items expected );
  ]

let test_build_output (order_items : order_item list)
    (expected : order_total IntMap.t) (status : string) (origin : string) () =
  let result = build_output order_items status origin in
  Alcotest.(check (map_testable order_total_testable))
    "build_output" expected result

let build_output_suite =
  [
    ( "Build output",
      `Quick,
      let expected =
        IntMap.of_list
          [
            ( 1,
              {
                order_id = 1;
                total_amount = (12. *. 10.4) +. (1. *. 50.);
                total_taxes = (12. *. 10.4 *. 0.2) +. (1. *. 50. *. 0.1);
              } );
          ]
      in
      test_build_output order_items expected "completed" "online" );
  ]
