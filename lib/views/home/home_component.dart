import 'package:flutter/material.dart';
import 'package:user_app/views/home/home_screen.dart';
import 'package:user_app/views/home/order_view/order_screen.dart';
import 'package:user_app/views/home/profile_screen/profile_view.dart';
import 'package:user_app/views/home/resturent_view/resturent_screen.dart';

class HomeComponent extends StatefulWidget {

  const HomeComponent({Key? key}) : super(key: key);

  @override
  _HomeComponentState createState() => _HomeComponentState();
}

class _HomeComponentState extends State<HomeComponent> {
  int _selectedIndex = 0;

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      HomeScreen(title: 'الصفحة الرئيسية',),
      RestaurantsScreen(),
      OrdersScreen(),
      ProfileScreen(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.redAccent,
        unselectedItemColor: Colors.black.withOpacity(0.5),
        selectedLabelStyle: const TextStyle(color: Colors.black),
        unselectedLabelStyle: const TextStyle(color: Colors.blue),
        selectedIconTheme: const IconThemeData(color: Colors.redAccent),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "الرئيسية"),
          BottomNavigationBarItem(icon: Icon(Icons.fastfood), label: "المطاعم"),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag), label: "الطلبات"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "صفحتي"),
        ],
      ),
    );
  }
}
