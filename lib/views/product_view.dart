import 'package:flutter/material.dart';
import 'package:shopsense/models/cart_item.dart';
import 'package:shopsense/models/product.dart';
import 'package:shopsense/repository/customer_repo.dart';
import 'package:shopsense/repository/product_repo.dart';
import 'package:shopsense/util/constants.dart';

class ProductView extends StatefulWidget {
  final String productId;

  const ProductView({super.key, required this.productId});

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  Product? product;
  int quantity = 1;
  double subTotal = 0;

  @override
  void initState() {
    super.initState();
    getProduct();
  }

  void getProduct() async {
    product = await fetchProduct(widget.productId);
    subTotal = double.parse(product!.regularPrice);
  }

  void incrementQuantity() {
    setState(() {
      quantity++;
      subTotal = double.parse(product!.regularPrice) * quantity;
    });
  }

  void decrementQuantity() {
    if (quantity > 1) {
      setState(() {
        quantity--;
        subTotal = double.parse(product!.regularPrice) * quantity;
      });
    }
  }

  void addToCart() async {
    CartItem c = CartItem(
        id: 0,
        customerId: 0,
        productId: product!.id,
        sellerId: product!.sellerId,
        storeName: product!.storeName,
        productName: product!.title,
        productThumbnailUrl: product!.thumbnailUrl,
        productUnitPrice: double.parse(product!.salePrice),
        productQuantity: quantity,
        subTotal: subTotal);
    await customerAddToCart(c)
        ? showMessage("Added to cart")
        : showMessage("Something went wrong");
  }

  showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        title: const Text(
          "Product Style",
        ),
      ),
      body: FutureBuilder(
        future: fetchProduct(widget.productId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: Column(
                  children: [
                    Image(
                      image: NetworkImage(
                          "$baseUrl/${snapshot.data!.thumbnailUrl}"),
                      width: double.infinity,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              snapshot.data!.title,
                              style: const TextStyle(fontSize: 30),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                '৳${snapshot.data!.salePrice}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                  color: Colors.green,
                                ),
                              ),
                              Text(
                                '৳${snapshot.data!.regularPrice}',
                                style: const TextStyle(
                                  color: Colors.red,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                          "Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
                          style: TextStyle()),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Text(
                                "Colors",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.circle,
                                        size: 30,
                                        color: Colors.orange,
                                      )),
                                  IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.circle,
                                        size: 30,
                                        color: Colors.red,
                                      )),
                                  IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.circle,
                                        size: 30,
                                        color: Colors.black,
                                      )),
                                  IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.circle,
                                      size: 30,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          Column(
                            children: [
                              const Text(
                                "Size",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.one_k,
                                      size: 30,
                                      color: Colors.orange,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey[350],
                                  borderRadius: BorderRadius.circular(20)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove),
                                    onPressed: decrementQuantity,
                                  ),
                                  Text(
                                    quantity.toString(),
                                    style: const TextStyle(fontSize: 20.0),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add),
                                    onPressed: incrementQuantity,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey[350],
                                  borderRadius: BorderRadius.circular(20)),
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Text(
                                  textAlign: TextAlign.center,
                                  subTotal.toString(),
                                  style: const TextStyle(fontSize: 20.0),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      color: Colors.indigo,
                      height: 70,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(4),
                            child: IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.favorite),
                              iconSize: 35,
                              color: Colors.white,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Colors.white),
                              ),
                              onPressed: () {
                                addToCart();
                              },
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.add_shopping_cart,
                                      color: Colors.white),
                                  SizedBox(width: 8.0),
                                  Text(
                                    'Add to Cart',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
