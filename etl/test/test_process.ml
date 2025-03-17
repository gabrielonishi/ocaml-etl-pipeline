open Lib.Schemas
open Lib.Process
open Testables

let test_int_is_in (el : int) (lst : int list) (expected : bool) () =
  Alcotest.(check bool) "int_is_in" expected (int_is_in el lst)

let int_is_in_suite =
  [
    ("int_is_in empty list", `Quick, test_int_is_in 1 [] false);
    ("int_is_in not in list", `Quick, test_int_is_in 1 [ 2; 3; 4 ] false);
    ("int_is_in in list", `Quick, test_int_is_in 1 [ 1; 2; 3 ] true);
  ]

let test_process_order (order_items : order_item list)
    (expected : order_summary) () =
  Alcotest.(check order_summary_testable)
    "process_order" expected
    (process_order order_items)

let process_order_suite =
  [
    ( "process_order empty list",
      `Quick,
      test_process_order []
        { order_id = 0; total_amount = 0.; total_taxes = 0. } );
    ( "process_order single item",
      `Quick,
      test_process_order
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
        {
          order_id = 1;
          total_amount = 12. *. 10.4;
          total_taxes = 12. *. 10.4 *. 0.2;
        } );
    ( "process_order multiple items",
      `Quick,
      test_process_order
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
        {
          order_id = 1;
          total_amount = (12. *. 10.4) +. (1. *. 50.);
          total_taxes = (12. *. 10.4 *. 0.2) +. (1. *. 50. *. 0.1);
        } );
  ]

let test_group_by_ids (order_items : order_item list)
    (expected : order_summary list) () =
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
    (origin : string) (expected : order_summary list) () =
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
  ]

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
