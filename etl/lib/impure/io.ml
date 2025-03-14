(** [parse_arguments] parses the command-line arguments for order status and
    order type. It expects two arguments and raises an exception if the
    arguments are invalid.

    @return A tuple containing the parsed status and order type.
    @raise Failure if the arguments are not in the expected format. *)
let parse_arguments =
  if Array.length Sys.argv != 3 then
    failwith
      "Execute com dune exec etl [pending | complete | cancelled] [physical | \
       online ]"
  else
    let status =
      match Sys.argv.(1) with
      | "pending" -> "Pending"
      | "complete" -> "Complete"
      | "cancelled" -> "Cancelled"
      | _ ->
          failwith
            "Execute com dune exec etl [pending | complete | cancelled] \
             [physical | online ]"
    in
    let order =
      match Sys.argv.(2) with
      | "physical" -> "P"
      | "online" -> "O"
      | _ ->
          failwith
            "Execute com dune exec etl [pending | complete | cancelled] \
             [physical | online ]"
    in
    (status, order)

(** [read_csv filepath] reads a CSV file from the specified [filepath] and
    validates its format. It expects each row to have exactly five columns,
    otherwise it raises an exception.

    @param filepath The path to the CSV file to be read.
    @return
      A list of string lists, where each inner list represents a row from the
      CSV.
    @raise Failure if a row does not contain exactly five columns. *)
let read_csv (filepath : string) : string list list =
  let data = Csv.load filepath in

  let validated_data =
    List.map
      (fun row ->
        match row with
        | [ a; b; c; d; e ] -> [ a; b; c; d; e ]
        | _ -> failwith "Formato inválido de csv")
      data
  in

  validated_data

(** [write_csv filepath data] writes the provided [data] to a CSV file at the
    specified [filepath].

    @param filepath The path to the CSV file where the data will be written.
    @param data The list of string lists to be written as rows in the CSV file.
    @return Unit.
    @raise Sys_error if the file cannot be opened or written to. *)
let write_csv (filepath : string) (data : string list list) : unit =
  let oc = open_out filepath in
  let csv_out = Csv.to_channel oc in
  Csv.output_all csv_out data;
  close_out oc
