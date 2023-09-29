import 'package:flutter/material.dart';
import 'package:shopsense/models/product.dart';
import 'package:shopsense/repository/product_repo.dart';
import 'package:shopsense/util/constants.dart';
import 'package:shopsense/views/cart_view.dart';
import 'package:shopsense/views/product_view.dart';
import 'package:shopsense/widgets/product_card.dart';

class Explore extends StatefulWidget {
  const Explore({super.key});

  @override
  State<Explore> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
          title: const Text("ShopSense"),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CartView(),
                  ),
                );
              },
              icon: const Icon(Icons.shopping_cart),
            ),
          ],
        ),
        Expanded(
          child: SingleChildScrollView(
            child: FutureBuilder<List<Product>>(
              future: fetchProducts(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<Product>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  List<Product> items = snapshot.data!;
                  return GridView.builder(
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                      mainAxisExtent: 330,
                    ),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductView(
                                    productId: items[index].id.toString()),
                              ),
                            );
                          },
                          child: ProductCard(
                            title: items[index].title,
                            price: double.parse(items[index].regularPrice),
                            salePrice: double.parse(items[index].salePrice),
                            thumbnailUrl:
                                "$baseUrl/${items[index].thumbnailUrl}",
                          ));
                    },
                  );
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
