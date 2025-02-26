type order = {
  id : int;
  client_id : int;
  order_date : string;
  status : string;
  origin : string;
}

type item = {
  order_id : int;
  product_id : int;
  quantity : int;
  price : float;
  tax : float;
}

type order_item = {
  order_id : int;
  product_id : int;
  quantity : int;
  price : float;
  tax : float;
  client_id : int;
  order_date : string;
  status : string;
  origin : string;
}
