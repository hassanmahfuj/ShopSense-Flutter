import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:shopsense/views/explore.dart';
import 'package:shopsense/views/profile.dart';
import 'package:shopsense/views/search.dart';
import 'package:shopsense/views/wishlist.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int selectedScreen = 0;
  List<Widget> screens = [
    const Explore(),
    const Search(),
    const Wishlist(),
    const Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[selectedScreen],
      bottomNavigationBar: Container(
        color: Colors.indigo,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: GNav(
              onTabChange: (index) {
                setState(() {
                  selectedScreen = index;
                });
              },
              gap: 8,
              padding: const EdgeInsets.all(12),
              backgroundColor: Colors.indigo,
              color: Colors.white,
              activeColor: Colors.white,
              tabBackgroundColor: Colors.white38,
              tabs: const [
                GButton(
                  icon: Icons.home,
                  text: 'Home',
                ),
                GButton(
                  icon: Icons.search,
                  text: 'Search',
                ),
                GButton(
                  icon: Icons.favorite,
                  text: 'Wishlist',
                ),
                GButton(
                  icon: Icons.account_circle,
                  text: 'Profile',
                )
              ]),
        ),
      ),
    );
  }
}
