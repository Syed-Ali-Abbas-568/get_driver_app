import 'package:flutter/material.dart';

import 'package:get_driver_app/screens/dashboard_screen.dart';
import 'package:get_driver_app/screens/profile_screen.dart';
import 'package:get_driver_app/screens/report_screen.dart';

class NavBar extends StatefulWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _selectedIndex = 2;
  static const List<Widget> _widgetOptions = <Widget>[
    DashBoard(),
    Report(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage("assets/images/dashboard_icon.png"),
              color: Color(0xFF152C5E),
              size: 24,
            ),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage("assets/images/report_icon.png"),
              color: Color(0xFF152C5E),
              size: 24,
            ),
            label: 'Report',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage("assets/images/profile_icon.png"),
              color: Color(0xFF152C5E),
              size: 24,
            ),
            label: 'Profile',
          ),
        ],
        iconSize: 40,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.red,
        unselectedItemColor: const Color(0xFF152C5E),
        backgroundColor: Colors.white,
        onTap: _onItemTapped,
      ),
    );
  }
}
