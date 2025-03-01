let parse_arguments =
  if Array.length Sys.argv != 3 then
    failwith
      "Execute com dune exec etl [pending | complete | cancelled] [physical | \
       online | all]"
  else
    let status =
      match Sys.argv.(1) with
      | "pending" -> "Pending"
      | "complete" -> "Complete"
      | "cancelled" -> "Cancelled"
      | _ ->
          failwith
            "Execute com dune exec etl [pending | complete | cancelled] \
             [physical | online | all]"
    in
    let order =
      match Sys.argv.(2) with
      | "physical" -> "P"
      | "online" -> "O"
      | _ ->
          failwith
            "Execute com dune exec etl [pending | complete | cancelled] \
             [physical | online | all]"
    in
    (status, order)

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

let write_csv (filepath : string) (data : string list list) : unit =
  let oc = open_out filepath in
  let csv_out = Csv.to_channel oc in
  Csv.output_all csv_out data;
  close_out oc
