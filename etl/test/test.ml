let () =
  Alcotest.run "csv_parser"
    [
      ("safe_string_suite", Csv_parser_test.safe_string_suite);
      ("load_order_suite", Csv_parser_test.load_order_suite);
      ("load_item_suite", Csv_parser_test.load_item_suite);
      ("load_order_item_suite", Csv_parser_test.load_order_item_suite);
      ("build_csv_output_suite", Csv_parser_test.build_csv_output_suite);
    ]
