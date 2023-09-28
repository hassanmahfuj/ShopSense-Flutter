import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shopsense/models/product.dart';
import 'package:shopsense/util/constants.dart';

List<Product> studentFromJson(String str) =>
    List<Product>.from(json.decode(str).map((x) => Product.fromJson(x)));

Future<List<Product>> fetchProducts() async {
  final response = await http.get(Uri.parse('$baseUrl/products'));
  if (response.statusCode == 200) {
    return studentFromJson(response.body);
  } else {
    throw Exception('Failed to load album');
  }
}

Future<Product> fetchProduct(String id) async {
  final response = await http.get(Uri.parse('$baseUrl/product/$id'));
  if (response.statusCode == 200) {
    return Product.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load album');
  }
}
