type order = {
  id: int;
  client_id: int;
  order_date: string;
  status: string;
  origin: string
} ;;

type item = {
  order_id: int;
  product_id: int;
  quantity: int;
  price: float;
  tax: float;
} ;;

let load_order_records order_data =
  let data = List.tl order_data in
    let records =
      List.fold_left (fun acc order ->
        match order with
        | [a; b; c; d; e] ->
            let this_order = {
              id = int_of_string a;
              client_id = int_of_string b;
              order_date = c;
              status = d;
              origin = e;
            } in
            this_order :: acc
        | _ -> failwith "Unexpected number of items in row"
      ) [] data in records ;;

let load_item_records item_data =
  let data = List.tl item_data in
    let records =
      List.fold_left (fun acc item ->
        match item with
        | [a; b; c; d; e] ->
            let this_order = {
              order_id = int_of_string a;
              product_id = int_of_string b;
              quantity = int_of_string c;
              price = float_of_string d;
              tax = float_of_string e;
            } in
            this_order :: acc
        | _ -> failwith "Unexpected number of items in row"
      ) [] data in records ;;