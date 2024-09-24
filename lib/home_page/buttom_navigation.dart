import 'package:ern_u/constants/app_colors.dart';
import 'package:ern_u/news_pages/news_tabs.dart';
import 'package:flutter/material.dart';

import 'Books.dart';
import 'edit_user_profile.dart';
import 'home_page.dart';

class NavigationHome extends StatefulWidget {
  const NavigationHome({super.key});

  @override
  State<NavigationHome> createState() => _NavigationHomeState();
}

class _NavigationHomeState extends State<NavigationHome> {
  int currentIndex = 0;
  List<Widget> screens = [
    HomePage(),
    const Books(),
    const NewsTabs(),
    const EditProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        selectedItemColor: Colors.black,
        iconSize: 20,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: currentIndex == 0
                ? Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue.withOpacity(0.2), // Circle color
                    ),
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.home, color: AppColor.kPrimary),
                  )
                : const Icon(Icons.home),
            label: 'Admins',
          ),

          BottomNavigationBarItem(
            icon: currentIndex == 1
                ? Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue.withOpacity(0.2), // Circle color
              ),
              padding: const EdgeInsets.all(8.0),
              child: const Icon(Icons.book, color: Colors.blue),
            )
                : const Icon(Icons.book, color: Colors.blue),
            label: 'Books',
          ),
          BottomNavigationBarItem(
            icon: currentIndex == 2
                ? Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue.withOpacity(0.2), // Circle color
                    ),
                    padding: const EdgeInsets.all(8.0),
                    child: const Icon(Icons.newspaper, color: Colors.blue),
                  )
                : const Icon(Icons.newspaper, color: Colors.blue),
            label: 'News',
          ),

          BottomNavigationBarItem(
            icon: currentIndex == 3
                ? Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue.withOpacity(0.2), // Circle color
                    ),
                    padding: const EdgeInsets.all(8.0),
                    child: const Icon(Icons.person, color: Colors.blue),
                  )
                : const Icon(Icons.person, color: Colors.blue),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
