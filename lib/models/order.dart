import 'dart:convert';

Order orderFromJson(String str) => Order.fromJson(json.decode(str));

String orderToJson(Order data) => json.encode(data.toJson());

List<Order> orderListFromJson(String str) =>
    List<Order>.from(json.decode(str).map((x) => Order.fromJson(x)));

class Order {
  int id;
  String orderDate;
  double orderTotal;
  String status;

  Order({
    required this.id,
    required this.orderDate,
    required this.orderTotal,
    required this.status,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    id: json["id"],
    orderDate: json["orderDate"],
    orderTotal: json["orderTotal"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "orderDate": orderDate,
    "orderTotal": orderTotal,
    "status": status,
  };
}
