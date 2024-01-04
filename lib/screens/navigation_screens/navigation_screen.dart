import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'account_screen.dart';
import 'contacts_screen.dart';
import 'invitations_screen.dart';
import 'my_events_screen.dart';

class NavigationScreen extends ConsumerStatefulWidget {
  const NavigationScreen({Key? key}) : super(key: key);

  @override
  ConsumerState createState() => _HomeState();
}

class _HomeState extends ConsumerState<NavigationScreen> {
  int currentIndex = 0;

  final List<Widget> screens = [
    InvitationsScreen(key: UniqueKey()),
    MyEventsScreen(key: UniqueKey()),
    ContactsScreen(key: UniqueKey()),
    AccountScreen(key: UniqueKey()),
  ];

  @override
  Widget build(BuildContext context) {
    final List<AppBar> appBars = [
      AppBar(
        elevation: 0.0,
        backgroundColor: Color(0xFFF5F5F5), // cream
        // backgroundColor: Theme.of(context).colorScheme.background,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: SizedBox(
                width: 40,
                height: 40,
                child: IconButton(
                  icon: Icon(
                    CupertinoIcons.search,
                  ),
                  color: Colors.grey[850],
                  splashColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onPressed: () async {
                    // AuthService _auth = AuthService();
                    // _auth.signOut();
                  },
                ),
              ),
            ),
            Text(
              'Invitations',
              style: TextStyle(color: Colors.grey[850]),
            ),
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: SizedBox(
                width: 40,
                height: 40,
                child: IconButton(
                  icon: Icon(
                    CupertinoIcons.gear,
                  ),
                  color: Colors.grey[850],
                  splashColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onPressed: () async {},
                ),
              ),
            ),
          ],
        ),
      ),

      // bellow are different appBars

      AppBar(
        elevation: 0.0,
        backgroundColor: Color(0xFFF5F5F5),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: SizedBox(
                width: 40,
                height: 40,
              ),
            ),
            Text(
              'My Events',
              style: TextStyle(color: Colors.grey[850]),
            ),
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: SizedBox(
                width: 40,
                height: 40,
              ),
            ),
          ],
        ),
      ),
      AppBar(
        elevation: 0.0,
        title: Text('Contacts', style: TextStyle(color: Colors.grey[850])),
        backgroundColor: Color(0xFFF5F5F5),
      ),
      AppBar(
        elevation: 0.0,
        title: Text('Account', style: TextStyle(color: Colors.grey[850])),
        backgroundColor: Color(0xFFF5F5F5),
      ),
    ];
    return Scaffold(
      appBar: appBars[currentIndex],
      body: screens[currentIndex],
      bottomNavigationBar: buildBottomNavigationBar(),
    );
  }

  BottomNavigationBar buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      items: [
        buildBottomNavigationBarItem(
          Icons.card_giftcard,
          'Invitations',
        ),
        buildBottomNavigationBarItem(CupertinoIcons.calendar, 'My events'),
        buildBottomNavigationBarItem(CupertinoIcons.person_2, 'Contacts'),
        buildBottomNavigationBarItem(CupertinoIcons.person, 'Account'),
      ],
      selectedItemColor: Colors.grey[850],
      backgroundColor: Color(0xFFF5F5F5),
      unselectedItemColor: Color(0xFFE6D3B3),
      selectedFontSize: 10,
      elevation: 0,
      unselectedFontSize: 10,
      type: BottomNavigationBarType.fixed,
      onTap: (index) {
        setState(() {
          currentIndex = index;
        });
      },
    );
  }

  BottomNavigationBarItem buildBottomNavigationBarItem(
      IconData icon, String label) {
    return BottomNavigationBarItem(
      icon: Icon(icon),
      label: label,
    );
  }
}
