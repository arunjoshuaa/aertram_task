import 'package:aetram_task/pages/dashboard_page.dart';
import 'package:aetram_task/pages/profile_page.dart';

import 'package:flutter/material.dart';

class BottomnavbarWidget extends StatefulWidget {
  const BottomnavbarWidget({super.key});

  @override
  State<BottomnavbarWidget> createState() => _BottomnavbarWidgetState();
}

class _BottomnavbarWidgetState extends State<BottomnavbarWidget> {
  int currentIndex=0;
    final List<Widget> _screens = [
      DashboardPage(),
 ProfilePage()
  ];
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: _screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index){
          setState(() {
            currentIndex=index;
          });
        },
        
        items: [
           BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ]),
    );
  }
}