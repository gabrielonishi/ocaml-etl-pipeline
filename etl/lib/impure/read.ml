(* Function to read and print CSV content *)
let read_csv file =
  let data = Csv.load file in
  List.iter (fun row ->
    List.iter (fun field ->
      Printf.printf "%s " field
    ) row;
    print_newline ()
  ) data
