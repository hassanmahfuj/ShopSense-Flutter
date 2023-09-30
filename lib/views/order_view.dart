import 'package:flutter/material.dart';
import 'package:shopsense/models/place_order.dart';
import 'package:shopsense/repository/customer_repo.dart';

class OrderView extends StatefulWidget {
  final String orderId;

  const OrderView({super.key, required this.orderId});

  @override
  State<OrderView> createState() => _OrderViewState();
}

class _OrderViewState extends State<OrderView> {
  PlaceOrder? p;

  @override
  void initState() {
    super.initState();
    getOrder();
  }

  void getOrder() async {
    p = await customerGetOrder(widget.orderId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        title: const Text("Order Details"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Order ID : ${p?.id.toString()}",
                  style: const TextStyle(fontSize: 18),
                ),
                Text(
                  "Placed On : ${p?.orderDate.toString().split(" ")[0]}",
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Order Items",
              style: TextStyle(
                fontSize: 20,
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          FutureBuilder<PlaceOrder>(
            future: customerGetOrder(widget.orderId),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.orderDetails.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Text(
                        (index + 1).toString(),
                        style: const TextStyle(fontSize: 14),
                      ),
                      title: Text(
                        "${snapshot.data!.orderDetails[index].productName} x${snapshot.data!.orderDetails[index].quantity}",
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        snapshot.data!.orderDetails[index].status,
                        style: const TextStyle(fontSize: 16),
                      ),
                      trailing: Text(
                        "৳${snapshot.data!.orderDetails[index].subTotal.toStringAsFixed(2)}",
                        style: const TextStyle(fontSize: 16),
                      ),
                    );
                  },
                );
              }
              return const CircularProgressIndicator();
            },
          ),
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
                    "৳${p?.shippingCharge.toStringAsFixed(2)}",
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
                    "৳${p?.tax.toStringAsFixed(2)}",
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
                    "৳${p?.orderTotal.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
