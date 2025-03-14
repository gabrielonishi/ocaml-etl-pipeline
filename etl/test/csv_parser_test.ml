open Lib.Csv_parser
open Lib.Schemas

(*safe_string_to_int*)
let%test "safe_string_to_int int to int" = safe_string_to_int "1123" = 1123

let%test "safe_string_to_int non-int to int" =
  safe_string_to_int "asdf3123adf.123" = 0

(*safe_float_to_int*)
let%test "safe_string_to_float float to int" =
  safe_string_to_float "1123.1234" = 1123.1234

let%test "safe_string_to_float non-float to int" =
  safe_string_to_float "asdf3123adf.123" = 0.

(*load_order_records*)
let%test "load_order_records valid row" =
  let orders_data = [ [ "1"; "112"; "2024-10-02T03:05:39"; "Pending"; "O" ] ] in
  let expected =
    [
      {
        id = 1;
        client_id = 112;
        order_date = "2024-10-02T03:05:39";
        status = "Pending";
        origin = "O";
      };
    ]
  in
  load_order_records orders_data = expected

let%test "load_order_records multiple valid rows" =
  let orders_data =
    [
      [ "1"; "100"; "2024-10-02T03:05:39"; "Pending"; "O" ];
      [ "2"; "101"; "2024-08-17T03:05:39"; "Complete"; "P" ];
    ]
  in
  let expected =
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
    ]
  in
  load_order_records orders_data = expected

let%test "load_order_records invalid row" =
  let orders_data = [ [ "1"; "100"; "2025-03-14" ] ] in
  let expected =
    [ { id = 0; client_id = 0; order_date = ""; status = ""; origin = "" } ]
  in
  load_order_records orders_data = expected

(*load_item_records*)
let%test "load_item_records valid row" =
  let items_data = [ [ "12"; "224"; "8"; "139.42"; "0.12" ] ] in
  let expected =
    [
      {
        order_id = 12;
        product_id = 224;
        quantity = 8;
        price = 139.42;
        tax = 0.12;
      };
    ]
  in
  load_item_records items_data = expected

let%test "load_item_records multiple valid rows" =
  let items_data =
    [
      [ "12"; "224"; "8"; "139.42"; "0.12" ];
      [ "13"; "225"; "9"; "139.42"; "0.12" ];
    ]
  in
  let expected =
    [
      {
        order_id = 12;
        product_id = 224;
        quantity = 8;
        price = 139.42;
        tax = 0.12;
      };
      {
        order_id = 13;
        product_id = 225;
        quantity = 9;
        price = 139.42;
        tax = 0.12;
      };
    ]
  in
  load_item_records items_data = expected

let%test "load_item_records invalid row" =
  let items_data = [ [ "12"; "224"; "8"; "139.42" ] ] in
  let expected =
    [ { order_id = 0; product_id = 0; quantity = 0; price = 0.; tax = 0. } ]
  in
  load_item_records items_data = expected

(*load_order_items*)
let%test "load_order_items valid rows" =
  let orders_csv =
    [
      [ "id"; "client_id"; "order_date"; "status"; "origin" ];
      [ "1"; "100"; "2024-10-02T03:05:39"; "Pending"; "O" ];
    ]
  in
  let items_csv =
    [
      [ "order_id"; "product_id"; "quantity"; "price"; "tax" ];
      [ "1"; "100"; "12"; "10.4"; "20" ];
      [ "1"; "101"; "1"; "50.0"; "50" ];
    ]
  in
  let expected =
    [
      {
        order_id = 1;
        product_id = 101;
        quantity = 1;
        price = 50.;
        tax = 50.;
        client_id = 100;
        order_date = "2024-10-02T03:05:39";
        status = "Pending";
        origin = "O";
      };
      {
        order_id = 1;
        product_id = 100;
        quantity = 12;
        price = 10.4;
        tax = 20.;
        client_id = 100;
        order_date = "2024-10-02T03:05:39";
        status = "Pending";
        origin = "O";
      };
    ]
  in
  load_order_items orders_csv items_csv = expected

let%test "convert_records_into_array" =
  let order_summary =
    [
      { order_id = 1; total_amount = 100.; total_taxes = 10. };
      { order_id = 2; total_amount = 200.; total_taxes = 20. };
    ]
  in
  let expected =
    [
      [ "order_id"; "total_amount"; "total_taxes" ];
      [ "1"; "100."; "10." ];
      [ "2"; "200."; "20." ];
    ]
  in
  convert_records_to_array order_summary = expected
