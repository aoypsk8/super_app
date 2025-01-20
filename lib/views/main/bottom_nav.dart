import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:super_app/home_screen.dart';
import 'package:super_app/widget/textfont.dart';

class BottomNav extends StatefulWidget {
  @override
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _currentIndex = 0;

  final List<Map<String, dynamic>> _menuItems = [
    {'icon': 'assets/icons/ic_home.svg', 'title': 'nav_home'},
    {'icon': 'assets/icons/ic_box.svg', 'title': 'nav_service'},
    {'icon': 'assets/icons/ic_myqr.svg', 'title': 'nav_myqr'},
    {'icon': 'assets/icons/ic_history.svg', 'title': 'nav_history'},
    {'icon': 'assets/icons/ic_setting.svg', 'title': 'nav_setting'},
  ];

  final List<Widget> _pages = [
    HomeScreen(),
    Center(child: TextFont(text: 'nav_service')),
    Center(child: TextFont(text: 'nav_myqr')),
    Center(child: TextFont(text: 'nav_history')),
    Center(child: TextFont(text: 'nav_setting')),
  ];

  @override
  Widget build(BuildContext context) {
    // Get theme colors
    final activeColor = Theme.of(context).colorScheme.primary; // Active color
    final inactiveColor = Theme.of(context).unselectedWidgetColor; // Inactive color

    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: Stack(
        clipBehavior: Clip.none, // Allow the active indicator to overflow
        children: [
          // Active Indicator Positioned Above the BottomNavigationBar
          Positioned(
            top: -5, // Position the active indicator 5px above the BottomNavigationBar
            left: MediaQuery.of(context).size.width / _menuItems.length * _currentIndex,
            width: MediaQuery.of(context).size.width / _menuItems.length,
            child: Container(
              height: 5,
              color: activeColor, // Active indicator color
            ),
          ),
          // BottomNavigationBar
          BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            items: _menuItems.map((item) {
              int index = _menuItems.indexOf(item);
              bool isActive = _currentIndex == index;

              return BottomNavigationBarItem(
                icon: Column(
                  children: [
                    SvgPicture.asset(
                      item['icon'],
                      color: isActive ? activeColor : inactiveColor,
                    ),
                    TextFont(
                      text: item['title'],
                      color: isActive ? activeColor : inactiveColor,
                      fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                    )
                  ],
                ),
                label: '',
              );
            }).toList(),
            selectedItemColor: activeColor,
            unselectedItemColor: inactiveColor,
            type: BottomNavigationBarType.fixed,
          ),
        ],
      ),
    );
  }
}
