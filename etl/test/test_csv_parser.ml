open Lib.Schemas
open Lib.Csv_parser
open Testables

let test_safe_string_to_int (s : string) () =
  (*Math int_of_string with error*)
  let res = match int_of_string s with exception _ -> 0 | i -> i in

  Alcotest.(check int)
    "safe_string_to_int int to int" res (safe_string_to_int s)

let test_safe_string_to_float (s : string) () =
  (*Math float_of_string with error*)
  let res = match float_of_string s with exception _ -> 0. | f -> f in

  Alcotest.(check (float 0.))
    "safe_string_to_float float to int" res (safe_string_to_float s)

let safe_string_suite =
  [
    ("Int to int", `Quick, test_safe_string_to_int "1123");
    ("Non-int to int", `Quick, test_safe_string_to_int "asdf3123adf.123");
    ("Float to float", `Quick, test_safe_string_to_float "1123.1234");
    ("Non-float to float", `Quick, test_safe_string_to_float "asdf3123adf.123");
  ]

let test_load_order_records (order_data : string list list)
    (expected_order : order list) () =
  Alcotest.(check (list order_testable))
    "load_order_records valid row" expected_order
    (load_order_records order_data)

let load_order_suite =
  [
    ( "Valid row record",
      `Quick,
      test_load_order_records
        [ [ "1"; "112"; "2024-10-02T03:05:39"; "Pending"; "O" ] ]
        [
          {
            id = 1;
            client_id = 112;
            order_date = "2024-10-02T03:05:39";
            status = "Pending";
            origin = "O";
          };
        ] );
    ( "Multiple valid rows",
      `Quick,
      test_load_order_records
        [
          [ "1"; "100"; "2024-10-02T03:05:39"; "Pending"; "O" ];
          [ "2"; "101"; "2024-08-17T03:05:39"; "Complete"; "P" ];
        ]
        [
          {
            id = 1;
            client_id = 100;
            order_date = "2024-10-02T03:05:39";
            status = "Pending";
            origin = "O";
          };
          {
            id = 2;
            client_id = 101;
            order_date = "2024-08-17T03:05:39";
            status = "Complete";
            origin = "P";
          };
        ] );
    ( "Invalid row record",
      `Quick,
      test_load_order_records
        [ [ "1"; "100"; "2025-03-14" ] ]
        [ { id = 0; client_id = 0; order_date = ""; status = ""; origin = "" } ]
    );
  ]

let test_load_item_records (item_data : string list list)
    (expected_item : item list) () =
  Alcotest.(check (list item_testable))
    "load_item_records valid row" expected_item
    (load_item_records item_data)

let load_item_suite =
  [
    ( "Valid row record",
      `Quick,
      test_load_item_records
        [ [ "1"; "1"; "1"; "1.0"; "0.1" ] ]
        [
          { order_id = 1; product_id = 1; quantity = 1; price = 1.0; tax = 0.1 };
        ] );
    ( "Multiple valid rows",
      `Quick,
      test_load_item_records
        [ [ "1"; "1"; "1"; "1.0"; "0.1" ]; [ "2"; "2"; "2"; "2.0"; "0.2" ] ]
        [
          { order_id = 1; product_id = 1; quantity = 1; price = 1.0; tax = 0.1 };
          { order_id = 2; product_id = 2; quantity = 2; price = 2.0; tax = 0.2 };
        ] );
    ( "Invalid row record",
      `Quick,
      test_load_item_records
        [ [ "1"; "1"; "1"; "0.1" ] ]
        [
          { order_id = 0; product_id = 0; quantity = 0; price = 0.0; tax = 0.0 };
        ] );
  ]

let load_order_items (orders_data : string list list)
    (items_data : string list list) (expected_order_item : order_item list) () =
  Alcotest.(check (list order_item_testable))
    "load_order_items valid row" expected_order_item
    (load_order_items orders_data items_data)

let load_order_item_suite =
  [
    ( "Valid row record",
      `Quick,
      load_order_items
        [
          [ "id"; "client_id"; "order_date"; "status"; "origin" ];
          [ "1"; "1"; "2024-10-02T03:05:39"; "Pending"; "O" ];
        ]
        [
          [ "order_id"; "product_id"; "quantity"; "price"; "tax" ];
          [ "1"; "1"; "1"; "1.0"; "0.1" ];
        ]
        [
          {
            order_id = 1;
            product_id = 1;
            quantity = 1;
            price = 1.0;
            tax = 0.1;
            client_id = 1;
            order_date = "2024-10-02T03:05:39";
            status = "Pending";
            origin = "O";
          };
        ] );
    ( "Multiple valid rows",
      `Quick,
      load_order_items
        [
          [ "id"; "client_id"; "order_date"; "status"; "origin" ];
          [ "1"; "1"; "2024-10-02T03:05:39"; "Pending"; "O" ];
          [ "2"; "2"; "2024-08-17T03:05:39"; "Complete"; "P" ];
        ]
        [
          [ "order_id"; "product_id"; "quantity"; "price"; "tax" ];
          [ "1"; "1"; "1"; "1.0"; "0.1" ];
          [ "2"; "2"; "2"; "2.0"; "0.2" ];
        ]
        [
          {
            order_id = 1;
            product_id = 1;
            quantity = 1;
            price = 1.0;
            tax = 0.1;
            client_id = 1;
            order_date = "2024-10-02T03:05:39";
            status = "Pending";
            origin = "O";
          };
          {
            order_id = 2;
            product_id = 2;
            quantity = 2;
            price = 2.0;
            tax = 0.2;
            client_id = 2;
            order_date = "2024-08-17T03:05:39";
            status = "Complete";
            origin = "P";
          };
        ] );
    ( "Invalid row record",
      `Quick,
      load_order_items
        [
          [ "id"; "client_id"; "order_date"; "status"; "origin" ];
          [ "1"; "100"; "2025-03-14" ];
        ]
        [
          [ "order_id"; "product_id"; "quantity"; "price"; "tax" ];
          [ "1"; "1"; "1"; "1.0"; "1.0" ];
        ]
        [] );
  ]

let test_build_csv_output (order_summary : order_summary list)
    (expected_array : string list list) () =
  Alcotest.(check (list (list string)))
    "convert_records_to_array valid row" expected_array
    (build_csv_output order_summary)

let build_csv_output_suite =
  [
    ( "Valid row record",
      `Quick,
      test_build_csv_output
        [ { order_id = 1; total_amount = 1.0; total_taxes = 0.1 } ]
        [ [ "order_id"; "total_amount"; "total_taxes" ]; [ "1"; "1."; "0.1" ] ]
    );
    ( "Multiple valid rows",
      `Quick,
      test_build_csv_output
        [
          { order_id = 1; total_amount = 1.0; total_taxes = 0.1 };
          { order_id = 2; total_amount = 2.0; total_taxes = 0.2 };
        ]
        [
          [ "order_id"; "total_amount"; "total_taxes" ];
          [ "1"; "1."; "0.1" ];
          [ "2"; "2."; "0.2" ];
        ] );
  ]
