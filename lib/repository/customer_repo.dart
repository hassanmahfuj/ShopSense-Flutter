import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopsense/models/cart_item.dart';
import 'package:shopsense/models/auth_response.dart';
import 'package:shopsense/models/customer.dart';
import 'package:shopsense/models/order.dart';
import 'package:shopsense/models/place_order.dart';
import 'package:shopsense/util/constants.dart';

Future<bool> customerSignup(Customer c) async {
  final response = await http.post(Uri.parse('$baseUrl/customer/signup'),
      headers: {"Content-Type": "application/json"}, body: customerToJson(c));
  return response.statusCode == 200;
}

Future<bool> customerSignin(Customer c) async {
  final response = await http.post(Uri.parse('$baseUrl/customer/login'),
      headers: {"Content-Type": "application/json"}, body: customerToJson(c));
  if (response.statusCode == 200) {
    AuthResponse a = authResponseFromJson(response.body);
    if (a.status == "success") {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', a.token!);
      await prefs.setString('userId', a.user!['id'].toString());
      return true;
    } else {
      return false;
    }
  } else {
    return false;
  }
}

Future<Customer> customerProfile() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String userId = prefs.getString('userId') ?? "";
  String token = prefs.getString('token') ?? "";
  final response = await http.get(Uri.parse('$baseUrl/customer/$userId'),
      headers: {"Content-Type": "application/json", "Authorization": "Bearer $token"});
  if (response.statusCode == 200) {
    return customerFromJson(response.body);
  } else {
    throw Exception("Failed to get customer profile");
  }
}

Future<List<Order>> customerOrders() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String userId = prefs.getString('userId') ?? "";
  String token = prefs.getString('token') ?? "";
  final response = await http.get(Uri.parse('$baseUrl/customer/orders?id=$userId'),
      headers: {"Content-Type": "application/json", "Authorization": "Bearer $token"});
  if (response.statusCode == 200) {
    return orderListFromJson(response.body);
  } else {
    throw Exception("Failed to get customer orders");
  }
}

Future<List<CartItem>> customerCart() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String userId = prefs.getString('userId') ?? "";
  String token = prefs.getString('token') ?? "";
  final response = await http.get(Uri.parse('$baseUrl/customer/cart?id=$userId'),
      headers: {"Content-Type": "application/json", "Authorization": "Bearer $token"});
  if (response.statusCode == 200) {
    return cartItemListFromJson(response.body);
  } else {
    throw Exception("Failed to get customer cart items");
  }
}

Future<bool> customerAddToCart(CartItem c) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String userId = prefs.getString('userId') ?? "";
  String token = prefs.getString('token') ?? "";
  c.customerId = int.parse(userId);
  final response = await http.post(Uri.parse('$baseUrl/customer/cart'),
      headers: {"Content-Type": "application/json", "Authorization": "Bearer $token"},
  body: jsonEncode(c.toJson()));
  if (response.statusCode == 200) {
    return response.body != "";
  } else {
    throw Exception("Failed to get customer cart items");
  }
}

Future<String> customerPlaceOrder(PlaceOrder c) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String userId = prefs.getString('userId') ?? "";
  String token = prefs.getString('token') ?? "";
  c.customerId = int.parse(userId);
  final response = await http.post(Uri.parse('$baseUrl/customer/order'),
      headers: {"Content-Type": "application/json", "Authorization": "Bearer $token"},
  body: jsonEncode(c.toJson()));
  if (response.statusCode == 200 && response.body != "") {
    Order o = orderFromJson(response.body);
    return o.id.toString();
  } else {
    return "";
  }
}

Future<PlaceOrder> customerGetOrder(String orderId) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String userId = prefs.getString('userId') ?? "";
  String token = prefs.getString('token') ?? "";
  final response = await http.get(Uri.parse('$baseUrl/customer/order?id=$orderId'),
      headers: {"Content-Type": "application/json", "Authorization": "Bearer $token"});
  if (response.statusCode == 200 && response.body != "") {
    return placeOrderFromJson(response.body);
  } else {
    throw Exception("Failed to get customer profile");
  }
}