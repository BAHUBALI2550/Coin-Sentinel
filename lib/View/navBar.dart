import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'anotherPage.dart';
import 'home.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _currentIndex = 0;

  List<Widget> pages = [
    Home(),
    AnotherPage(),
    AnotherPage(),
    AnotherPage(),
  ];

  @override
  Widget build(BuildContext context) {
    double myHeight = MediaQuery.of(context).size.height;
    double myWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: pages.elementAt(_currentIndex),
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            backgroundColor: Colors.white,
            type: BottomNavigationBarType.fixed,
            onTap: ((value) {
              setState(() {
                _currentIndex = value;
              });
            }),
            items: [
              BottomNavigationBarItem(
                  icon: Icon(
                    CupertinoIcons.home,
                    size: myHeight * 0.03,
                    color: Colors.grey,
                  ),
                  label: '',
                  activeIcon: Icon(
                    Icons.home_filled,
                    size: myHeight * 0.03,
                    color: Color(0xffb3e82e),
                  )),
              BottomNavigationBarItem(
                  icon: Icon(
                    CupertinoIcons.compass,
                    size: myHeight * 0.03,
                    color: Colors.grey,
                  ),
                  label: '',
                  activeIcon: Icon(
                    CupertinoIcons.compass_fill,
                    size: myHeight * 0.03,
                    color: Color(0xffb3e82e),
                  )),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.notifications_outlined,
                    size: myHeight * 0.03,
                    color: Colors.grey,
                  ),
                  label: '',
                  activeIcon: Icon(
                    Icons.notifications_rounded,
                    size: myHeight * 0.03,
                    color: Color(0xffb3e82e),
                  )),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.person_3_rounded,
                    size: myHeight * 0.03,
                    color: Colors.grey,
                  ),
                  label: '',
                  activeIcon: Icon(
                    Icons.person_3,
                    size: myHeight * 0.03,
                    color: Color(0xffb3e82e),
                  )),
            ]),
      ),
    );
  }
}