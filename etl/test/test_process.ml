open Lib.Schemas
open Lib.Process
open Testables

let test_group_by_group_items_by_product_id (data : 'a list)
    (expected : 'b IntMap.t) (key_extractor : 'a -> int)
    (value_extractor : 'a -> 'b) (aggregate_handler : 'b -> 'b -> 'b)
    (value_testable : 'b Alcotest.testable) () =
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
      test_group_by_group_items_by_product_id items expected key_extractor
        value_extractor aggregate_handler item_testable );
    ( "Group int",
      `Quick,
      let expected = IntMap.empty |> IntMap.add 100 13 in
      let key_extractor (item : item) : int = item.product_id in
      let value_extractor (item : item) : int = item.quantity in
      let aggregate_handler (acc : int) (current_item : int) : int =
        acc + current_item
      in
      test_group_by_group_items_by_product_id items expected key_extractor
        value_extractor aggregate_handler Alcotest.int );
  ]
(* let test_group_by_ids (order_items : order_item list)
    (expected : order_total list) () =
  Alcotest.(check (list order_summary_testable))
    "group_by_ids" expected (group_by_ids order_items)

let group_by_ids_suite =
  [
    ("group_by_ids empty list", `Quick, test_group_by_ids [] []);
    ( "group_by_ids single item",
      `Quick,
      test_group_by_ids
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
        ]
        [
          {
            order_id = 1;
            total_amount = 12. *. 10.4;
            total_taxes = 12. *. 10.4 *. 0.2;
          };
        ] );
    ( "group_by_ids multiple items same order",
      `Quick,
      test_group_by_ids
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
        [
          {
            order_id = 1;
            total_amount = (12. *. 10.4) +. (1. *. 50.);
            total_taxes = (12. *. 10.4 *. 0.2) +. (1. *. 50. *. 0.1);
          };
        ] );
    ( "group_by_ids multiple items different orders",
      `Quick,
      test_group_by_ids
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
            order_id = 2;
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
        [
          {
            order_id = 1;
            total_amount = (12. *. 10.4) +. (1. *. 50.);
            total_taxes = (12. *. 10.4 *. 0.2) +. (1. *. 50. *. 0.1);
          };
          {
            order_id = 2;
            total_amount = 12. *. 10.4;
            total_taxes = 12. *. 10.4 *. 0.2;
          };
        ] );
  ]

let test_build_output (order_items : order_item list) (status : string)
    (origin : string) (expected : order_total list) () =
  Alcotest.(check (list order_summary_testable))
    "build_output" expected
    (build_output order_items status origin)

let build_output_suite =
  [
    ("build_output empty list", `Quick, test_build_output [] "Pending" "O" []);
    ( "build_output single item",
      `Quick,
      test_build_output
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
        ]
        "Pending" "O"
        [
          {
            order_id = 1;
            total_amount = 12. *. 10.4;
            total_taxes = 12. *. 10.4 *. 0.2;
          };
        ] );
    ( "build_output multiple items same order",
      `Quick,
      test_build_output
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
        "Pending" "O"
        [
          {
            order_id = 1;
            total_amount = (12. *. 10.4) +. (1. *. 50.);
            total_taxes = (12. *. 10.4 *. 0.2) +. (1. *. 50. *. 0.1);
          };
        ] );
    ( "build_output multiple items different orders",
      `Quick,
      test_build_output
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
            order_id = 2;
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
        "Pending" "O"
        [
          {
            order_id = 1;
            total_amount = (12. *. 10.4) +. (1. *. 50.);
            total_taxes = (12. *. 10.4 *. 0.2) +. (1. *. 50. *. 0.1);
          };
          {
            order_id = 2;
            total_amount = 12. *. 10.4;
            total_taxes = 12. *. 10.4 *. 0.2;
          };
        ] );
  ] *)

(* open Lib.Process
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
  res = exp *)
