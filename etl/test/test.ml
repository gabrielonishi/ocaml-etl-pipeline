let () =
  Alcotest.run "ETL"
    [
      ("safe_string_suite", Test_csv_parser.safe_string_suite);
      ("load_order_suite", Test_csv_parser.load_order_suite);
      ("load_item_suite", Test_csv_parser.load_item_suite);
      ("load_order_item_suite", Test_csv_parser.load_order_item_suite);
      ("build_csv_output_suite", Test_csv_parser.build_csv_output_suite);
      ("group_by", Test_process.group_by_suite);
      ("group_by_order_id", Test_process.group_by_order_id_suite);
      ("build_output", Test_process.build_output_suite);
    ]
