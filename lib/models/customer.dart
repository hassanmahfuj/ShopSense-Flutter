import 'dart:convert';

Customer customerFromJson(String str) => Customer.fromJson(json.decode(str));

String customerToJson(Customer data) => json.encode(data.toJson());

class Customer {
  int id;
  String name;
  String email;
  String? password;
  String address;
  String? status;
  bool emailVerified;
  String role;

  Customer({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.address,
    required this.status,
    required this.emailVerified,
    required this.role,
  });

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    password: json["password"],
    address: json["address"],
    status: json["status"],
    emailVerified: json["emailVerified"],
    role: json["role"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "password": password,
    "address": address,
    "status": status,
    "emailVerified": emailVerified,
    "role": role,
  };
}
