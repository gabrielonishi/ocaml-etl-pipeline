let () =
  Alcotest.run "ETL"
    [
      ("safe_string_suite", Test_csv_parser.safe_string_suite);
      ("load_order_suite", Test_csv_parser.load_order_suite);
      ("load_item_suite", Test_csv_parser.load_item_suite);
      ("load_order_item_suite", Test_csv_parser.load_order_item_suite);
      ("build_csv_output_suite", Test_csv_parser.build_csv_output_suite);
      (* ("int_is_in_suite", Test_process.int_is_in_suite);
      ("process_order_suite", Test_process.process_order_suite);
      ("group_by_ids_suite", Test_process.group_by_ids_suite);
      ("build_output_suite", Test_process.build_output_suite); *)
    ]
