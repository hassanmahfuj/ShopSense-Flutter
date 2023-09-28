class Product {
  final int id;
  final String title;
  final String thumbnailUrl;
  final String description;
  final String regularPrice;
  final String salePrice;
  final String category;
  final String stockStatus;
  final String stockCount;
  final int sellerId;
  final String storeName;
  final String status;

  const Product({
    required this.id,
    required this.title,
    required this.thumbnailUrl,
    required this.description,
    required this.regularPrice,
    required this.salePrice,
    required this.category,
    required this.stockStatus,
    required this.stockCount,
    required this.sellerId,
    required this.storeName,
    required this.status,
  });

  factory Product.fromJson(Map<dynamic, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      thumbnailUrl: json['thumbnailUrl'],
      description: json['description'],
      regularPrice: json['regularPrice'],
      salePrice: json['salePrice'],
      category: json['category'],
      stockStatus: json['stockStatus'],
      stockCount: json['stockCount'],
      sellerId: json['sellerId'],
      storeName: json['storeName'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "thumbnailUrl": thumbnailUrl,
    "description": description,
    "regularPrice": regularPrice,
    "salePrice": salePrice,
    "category": category,
    "stockStatus": stockStatus,
    "stockCount": stockCount,
    "sellerId": sellerId,
    "storeName": storeName,
    "status": status,
  };
}