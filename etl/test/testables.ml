open Lib.Schemas

let order_testable =
  let module M = struct
    type t = order

    let pp fmt (o : t) =
      (* Pretty-printing for error messages *)
      Format.fprintf fmt
        "{ id=%d; client_id=%d; date=%s; status=%s; origin=%s }" o.id
        o.client_id o.order_date o.status o.origin

    let equal (a : order) (b : order) =
      (* Comparison logic *)
      a.id = b.id && a.client_id = b.client_id
      && a.order_date = b.order_date
      && a.status = b.status && a.origin = b.origin
  end in
  Alcotest.testable M.pp M.equal

let item_testable =
  let module M = struct
    type t = item

    let pp fmt (i : t) =
      (* Pretty-printing for error messages *)
      Format.fprintf fmt
        "{ order_id=%d; product_id=%d; quantity=%d; price=%f; tax=%f }"
        i.order_id i.product_id i.quantity i.price i.tax

    let equal (a : item) (b : item) =
      (* Comparison logic *)
      a.order_id = b.order_id
      && a.product_id = b.product_id
      && a.quantity = b.quantity && a.price = b.price && a.tax = b.tax
  end in
  Alcotest.testable M.pp M.equal

let order_item_testable =
  let module M = struct
    type t = order_item

    let pp fmt (oi : t) =
      (* Pretty-printing for error messages *)
      Format.fprintf fmt
        "{ order_id=%d; product_id=%d; quantity=%d; price=%f; tax=%f; \
         client_id=%d; order_date=%s; status=%s; origin=%s }"
        oi.order_id oi.product_id oi.quantity oi.price oi.tax oi.client_id
        oi.order_date oi.status oi.origin

    let equal (a : order_item) (b : order_item) =
      (* Comparison logic *)
      a.order_id = b.order_id
      && a.product_id = b.product_id
      && a.quantity = b.quantity && a.price = b.price && a.tax = b.tax
      && a.client_id = b.client_id
      && a.order_date = b.order_date
      && a.status = b.status && a.origin = b.origin
  end in
  Alcotest.testable M.pp M.equal

let order_summary_testable =
  let module M = struct
    type t = order_total

    let pp fmt (os : t) =
      (* Pretty-printing for error messages *)
      Format.fprintf fmt "{ order_id=%d; total_amount=%f; total_taxes=%f }"
        os.order_id os.total_amount os.total_taxes

    let equal (a : order_total) (b : order_total) =
      (* Comparison logic *)
      a.order_id = b.order_id
      && a.total_amount = b.total_amount
      && a.total_taxes = b.total_taxes
  end in
  Alcotest.testable M.pp M.equal
