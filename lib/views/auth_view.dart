import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopsense/models/customer.dart';
import 'package:shopsense/providers/auth_provider.dart';
import 'package:shopsense/repository/customer_repo.dart';

class AuthView extends StatefulWidget {
  const AuthView({super.key});

  @override
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  bool isLogin = true;

  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _address = TextEditingController();

  final TextEditingController _emailLogin = TextEditingController();
  final TextEditingController _passwordLogin = TextEditingController();

  void signup() async {
    Customer c = Customer(
        id: 0,
        name: _name.text,
        email: _email.text,
        password: _password.text,
        address: _address.text,
        status: "Pending",
        emailVerified: false,
        role: "CUSTOMER");
    bool s = await customerSignup(c);
    if(s) {
      showMessage("Sign up successful");
      setState(() {
        isLogin = true;
      });
    } else {
      showMessage("Something went wrong");
    }
  }

  void signin() async {
    Customer c = Customer(
        id: 0,
        name: "",
        email: _emailLogin.text,
        password: _passwordLogin.text,
        address: "",
        status: "",
        emailVerified: false,
        role: "");
    bool s = await customerSignin(c);
    if(s) {
      showMessage("Sign in successful");
      context.read<AuthProvider>().updateUserId();
      Navigator.pop(context);
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
        title: const Text("ShopSense"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (isLogin)
              Column(
                children: [
                  const SizedBox(
                    height: 200,
                    child: Center(
                      child: Text(
                        "Sign in",
                        style: TextStyle(fontSize: 40),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _emailLogin,
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                      decoration: const InputDecoration(
                        labelText: "Email",
                        labelStyle: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _passwordLogin,
                      obscureText: true,
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                      decoration: const InputDecoration(
                        labelText: "Password",
                        labelStyle: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isLogin = false;
                      });
                    },
                    child: const Text("Not a member? Signup here"),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        signin();
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 40),
                      ),
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            if (!isLogin)
              Column(
                children: [
                  const SizedBox(
                    height: 200,
                    child: Center(
                      child: Text(
                        "Sign up",
                        style: TextStyle(fontSize: 40),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _name,
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                      decoration: const InputDecoration(
                        labelText: "Name",
                        labelStyle: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _email,
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                      decoration: const InputDecoration(
                        labelText: "Email",
                        labelStyle: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _password,
                      obscureText: true,
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                      decoration: const InputDecoration(
                        labelText: "Password",
                        labelStyle: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _address,
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                      decoration: const InputDecoration(
                        labelText: "Address",
                        labelStyle: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isLogin = true;
                      });
                    },
                    child: const Text("Already registered? Login here"),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        signup();
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 40),
                      ),
                      child: const Text(
                        "Sign up",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              )
          ],
        ),
      ),
    );
  }
}
