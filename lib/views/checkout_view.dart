import 'package:flutter/material.dart';
import 'package:shopsense/models/cart_item.dart';
import 'package:shopsense/models/order_details.dart';
import 'package:shopsense/models/place_order.dart';
import 'package:shopsense/repository/customer_repo.dart';
import 'package:shopsense/views/order_placed_view.dart';

class CheckoutView extends StatefulWidget {
  const CheckoutView({super.key});

  @override
  State<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {
  final TextEditingController _division = TextEditingController();
  final TextEditingController _district = TextEditingController();
  final TextEditingController _postCode = TextEditingController();
  final TextEditingController _street = TextEditingController();

  List<CartItem> items = [];

  double orderTotal = 0;
  double discount = 0;
  double shippingCharge = 150;
  double tax = 0;
  double subTotal = 0;
  double gatewayFee = 0;

  @override
  void initState() {
    super.initState();
    getCartItems();
  }

  void getCartItems() async {
    items = await customerCart();
    for (CartItem i in items) {
      subTotal += i.subTotal;
    }
    tax = subTotal * .05;
    orderTotal = subTotal + shippingCharge + gatewayFee - discount + tax;
    setState(() {});
  }

  void placeOrder() async {
    List<OrderDetail> orderDetails = [];
    for (CartItem item in items) {
      orderDetails.add(OrderDetail(
        id: 0,
        orderId: 0,
        productId: item.productId,
        sellerId: item.sellerId,
        storeName: item.storeName,
        productName: item.productName,
        productUnitPrice: item.productUnitPrice,
        productThumbnailUrl: item.productThumbnailUrl,
        status: "Pending",
        quantity: item.productQuantity,
        subTotal: item.subTotal,
        deliveryDate: DateTime.now(),
      ));
    }

    final order = PlaceOrder(
      id: 0,
      orderDate: DateTime.now(),
      orderTotal: orderTotal,
      customerId: 0,
      discount: discount,
      shippingCharge: shippingCharge,
      tax: tax,
      shippingStreet: _street.text,
      shippingCity: _district.text,
      shippingPostCode: _postCode.text,
      shippingState: _division.text,
      shippingCountry: "Bangladesh",
      status: "Processing",
      subTotal: subTotal,
      paymentStatus: "Paid",
      paymentMethod: "COD",
      cardNumber: "",
      cardCvv: "",
      cardHolderName: "",
      cardExpiryDate: "",
      gatewayFee: gatewayFee,
      orderDetails: orderDetails,
    );

    String orderId = await customerPlaceOrder(order);
    if (orderId != "") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => OrderPlacedView(
            orderId: orderId,
          ),
        ),
      );
    } else {
      showMessage("Something went wrong");
    }
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
        title: const Text("Order Confirmation"),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Shipping Info",
                      style: TextStyle(
                        fontSize: 20,
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: TextField(
                      controller: _street,
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                      decoration: const InputDecoration(
                        labelText: "Street Address",
                        labelStyle: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: TextField(
                      controller: _postCode,
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                      decoration: const InputDecoration(
                        labelText: "Post Code",
                        labelStyle: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: TextField(
                      controller: _district,
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                      decoration: const InputDecoration(
                        labelText: "District",
                        labelStyle: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: TextField(
                      controller: _division,
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                      decoration: const InputDecoration(
                        labelText: "Division",
                        labelStyle: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Order Summary",
                      style: TextStyle(
                        fontSize: 20,
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  FutureBuilder<List<CartItem>>(
                    future: customerCart(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text(snapshot.error.toString()),
                        );
                      } else if (snapshot.hasData) {
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              leading: Text(
                                (index + 1).toString(),
                                style: const TextStyle(fontSize: 14),
                              ),
                              title: Text(
                                "${snapshot.data![index].productName} x${snapshot.data![index].productQuantity}",
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              trailing: Text(
                                "৳${snapshot.data![index].subTotal.toStringAsFixed(2)}",
                                style: const TextStyle(fontSize: 16),
                              ),
                            );
                          },
                        );
                      }
                      return const Center(child: CircularProgressIndicator());
                    },
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Expanded(
                        flex: 3,
                        child: Padding(
                          padding: EdgeInsets.only(left: 8, right: 25),
                          child: Text(
                            "Shipping Charge :",
                            textAlign: TextAlign.end,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8, right: 25),
                          child: Text(
                            "৳${shippingCharge.toStringAsFixed(2)}",
                            textAlign: TextAlign.end,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Expanded(
                        flex: 3,
                        child: Padding(
                          padding: EdgeInsets.only(left: 8, right: 25),
                          child: Text(
                            "Tax (5%) :",
                            textAlign: TextAlign.end,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8, right: 25),
                          child: Text(
                            textAlign: TextAlign.end,
                            "৳${tax.toStringAsFixed(2)}",
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Expanded(
                        flex: 3,
                        child: Padding(
                          padding: EdgeInsets.only(left: 8, right: 25),
                          child: Text(
                            "Order Total :",
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8, right: 25),
                          child: Text(
                            textAlign: TextAlign.end,
                            "৳${orderTotal.toStringAsFixed(2)}",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          Container(
            height: 80,
            width: double.infinity,
            color: Colors.indigo,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.white),
                    ),
                    onPressed: () {
                      placeOrder();
                    },
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.shopify, color: Colors.white),
                        SizedBox(width: 8.0),
                        Text(
                          'Place Order',
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
    );
  }
}
