open Lib.Schemas
module IntMap = Map.Make (Int)

let order_testable =
  let pp fmt (o : order) =
    (* Pretty-printing for error messages *)
    Format.fprintf fmt "{ id=%d; client_id=%d; date=%s; status=%s; origin=%s }"
      o.id o.client_id o.order_date o.status o.origin
  in

  let equal (a : order) (b : order) =
    (* Comparison logic *)
    a.id = b.id && a.client_id = b.client_id
    && a.order_date = b.order_date
    && a.status = b.status && a.origin = b.origin
  in
  Alcotest.testable pp equal

let item_testable =
  let pp fmt (i : item) =
    (* Pretty-printing for error messages *)
    Format.fprintf fmt
      "{ order_id=%d; product_id=%d; quantity=%d; price=%f; tax=%f }" i.order_id
      i.product_id i.quantity i.price i.tax
  in

  let equal (a : item) (b : item) =
    (* Comparison logic *)
    a.order_id = b.order_id
    && a.product_id = b.product_id
    && a.quantity = b.quantity && a.price = b.price && a.tax = b.tax
  in

  Alcotest.testable pp equal

let order_item_testable =
  let pp fmt (oi : order_item) =
    (* Pretty-printing for error messages *)
    Format.fprintf fmt
      "{ order_id=%d; product_id=%d; quantity=%d; price=%f; tax=%f; \
       client_id=%d; order_date=%s; status=%s; origin=%s }"
      oi.order_id oi.product_id oi.quantity oi.price oi.tax oi.client_id
      oi.order_date oi.status oi.origin
  in

  let equal (a : order_item) (b : order_item) =
    (* Comparison logic *)
    a.order_id = b.order_id
    && a.product_id = b.product_id
    && a.quantity = b.quantity && a.price = b.price && a.tax = b.tax
    && a.client_id = b.client_id
    && a.order_date = b.order_date
    && a.status = b.status && a.origin = b.origin
  in

  Alcotest.testable pp equal

let order_summary_testable =
  let pp fmt (os : order_total) =
    (* Pretty-printing for error messages *)
    Format.fprintf fmt "{ order_id=%d; total_amount=%f; total_taxes=%f }"
      os.order_id os.total_amount os.total_taxes
  in

  let equal (a : order_total) (b : order_total) =
    (* Comparison logic *)
    a.order_id = b.order_id
    && a.total_amount = b.total_amount
    && a.total_taxes = b.total_taxes
  in

  Alcotest.testable pp equal

let order_total_testable =
  let pp fmt (ot : order_total) =
    (* Pretty-printing for error messages *)
    Format.fprintf fmt "{ order_id=%d; total_amount=%f; total_taxes=%f }"
      ot.order_id ot.total_amount ot.total_taxes
  in

  let equal (a : order_total) (b : order_total) =
    (* Comparison logic *)
    a.order_id = b.order_id
    && a.total_amount = b.total_amount
    && a.total_taxes = b.total_taxes
  in
  Alcotest.testable pp equal

let map_testable (value_testable : 'a Alcotest.testable) :
    'a IntMap.t Alcotest.testable =
  let pp fmt map =
    let bindings = IntMap.bindings map in
    Format.fprintf fmt "@[<hov>%a@]"
      (Fmt.list (Fmt.pair Fmt.int (Alcotest.pp value_testable)))
      bindings
  in
  let eq m1 m2 =
    let m1_in_m2_test =
      try
        IntMap.fold
          (fun key1 value1 acc ->
            if acc = false then false
            else
              acc
              &&
              match IntMap.find_opt key1 m2 with
              | Some value2 ->
                  if Alcotest.equal value_testable value1 value2 then true
                  else false
              | None -> false)
          m1 true
      with Not_found -> false
    in

    (* Only checks for key pairings, values were already tested*)
    let m2_in_m1_test =
      try
        IntMap.fold
          (fun key2 _value2 acc ->
            if acc = false then false
            else
              acc
              &&
              match IntMap.find_opt key2 m1 with
              | Some _value1 -> true
              | None -> false)
          m2 true
      with Not_found -> false
    in

    m1_in_m2_test && m2_in_m1_test
  in
  Alcotest.testable pp eq
