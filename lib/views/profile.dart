import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopsense/models/customer.dart';
import 'package:shopsense/providers/auth_provider.dart';
import 'package:shopsense/repository/customer_repo.dart';
import 'package:shopsense/views/auth_view.dart';
import 'package:shopsense/views/orders_view.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, value, child) {
        if (value.userId == "") {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Your are not signed in. Please sign in first"),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AuthView(),
                      ),
                    );
                  },
                  child: const Text("Login"),
                ),
              ],
            ),
          );
        } else {
          return Column(
            children: [
              AppBar(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
                title: const Text("My Profile"),
              ),
              SingleChildScrollView(
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(14),
                      child: CircleAvatar(
                        radius: 80,
                        backgroundImage: AssetImage("assets/images/avatar-1.png"),
                      ),
                    ),
                    FutureBuilder<Customer>(
                      future: customerProfile(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text(
                            snapshot.error.toString(),
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                          );
                        }
                        return Text(
                          snapshot.data!.name,
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                        );
                      },
                    ),
                    ElevatedButton(
                      onPressed: () {
                        value.logout();
                      },
                      child: const Text("Logout"),
                    ),
                    const Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Actions",
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Card(
                            clipBehavior: Clip.hardEdge,
                            child: InkWell(
                              splashColor: Colors.indigo.withAlpha(30),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const OrdersView(),
                                  ),
                                );
                              },
                              child: const SizedBox(
                                height: 150,
                                child: Center(
                                  child: Text(
                                    "Orders",
                                    style: TextStyle(fontSize: 25),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Card(
                            clipBehavior: Clip.hardEdge,
                            child: InkWell(
                              splashColor: Colors.indigo.withAlpha(30),
                              onTap: () {
                                debugPrint('edit tapped.');
                              },
                              child: const SizedBox(
                                height: 150,
                                child: Center(
                                  child: Text(
                                    "Edit Profile",
                                    style: TextStyle(fontSize: 25),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Card(
                            clipBehavior: Clip.hardEdge,
                            child: InkWell(
                              splashColor: Colors.indigo.withAlpha(30),
                              onTap: () {
                                debugPrint('wishlist tapped.');
                              },
                              child: const SizedBox(
                                height: 150,
                                child: Center(
                                  child: Text(
                                    "Wishlist",
                                    style: TextStyle(fontSize: 25),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Card(
                            clipBehavior: Clip.hardEdge,
                            child: InkWell(
                              splashColor: Colors.indigo.withAlpha(30),
                              onTap: () {
                                debugPrint('addresses tapped.');
                              },
                              child: const SizedBox(
                                height: 150,
                                child: Center(
                                  child: Text(
                                    "Addresses",
                                    style: TextStyle(fontSize: 25),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          );
        }
      },
    );
  }
}
