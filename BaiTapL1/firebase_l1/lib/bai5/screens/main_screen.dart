import 'package:firebase_l1/bai5/screens/cart_screen.dart';
import 'package:firebase_l1/bai5/screens/order_history_screen.dart';
import 'package:firebase_l1/bai5/screens/product_list_screen.dart';
import 'package:firebase_l1/bai5/screens/product_management_screen.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  
  final List<Widget> _screens = [
    ProductListScreen(),
    CartScreen(),
    OrderHistoryScreen(),
    ProductManagementScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed, // Hiển thị tất cả các item
        backgroundColor: Colors.white, // Màu nền của navigation bar
        selectedItemColor: Colors.blue[700], // Màu của item được chọn
        unselectedItemColor: Colors.grey[600], // Màu của item chưa chọn
        selectedLabelStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 12,
        ),
        elevation: 8, // Đổ bóng
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            activeIcon: Icon(Icons.home, size: 28), 
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            activeIcon: Icon(Icons.shopping_cart, size: 28),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            activeIcon: Icon(Icons.history, size: 28),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory),
            activeIcon: Icon(Icons.inventory, size: 28),
            label: 'Manage',
          ),
        ],
      ),
    );
  }
}