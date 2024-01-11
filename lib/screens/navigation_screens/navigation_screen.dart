import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../authenticate/auth.dart';
import '../../providers/contact_provider.dart';
import '../../providers/user_info_provider.dart';
import '../../widgets/calendar_widget.dart';
import '../../widgets/menus/list_menus/list_screen_add_menu.dart';
import '../../widgets/menus/list_menus/list_screen_ellipsis_menu.dart';
import 'settings_screen.dart';
import 'lists_screen.dart';
import 'invitations_screen.dart';
import 'my_events_screen.dart';

class NavigationScreen extends ConsumerStatefulWidget {
  const NavigationScreen({Key? key}) : super(key: key);

  @override
  ConsumerState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends ConsumerState<NavigationScreen> {
  bool showSearchBar = false;
  int currentIndex = 0;

  final List<Widget> screens = [
    InvitationsScreen(
      showSearchBar: false,
    ),
    MyEventsScreen(key: UniqueKey()),
    ListsScreen(key: UniqueKey()),
    SettingsScreen(key: UniqueKey()),
  ];
  double boxLeft = 0.0;

  @override
  void initState() {
    super.initState();
    (screens[0] as InvitationsScreen).showSearchBar = showSearchBar;
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userStreamProvider);
    final List<AppBar> appBars = [
      AppBar(
        elevation: 0.0,
        backgroundColor: Color(0xFFF5F5F5), // cream
        // backgroundColor: Theme.of(context).colorScheme.background,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Invitations',
              style: TextStyle(
                  color: Colors.grey[850], fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 170),
              child: SizedBox(
                width: 40,
                height: 40,
                child: IconButton(
                  icon: Icon(
                    CupertinoIcons.calendar,
                  ),
                  color: Colors.grey[850],
                  splashColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onPressed: () {
                    AuthService _auth = AuthService();
                    WidgetsBinding.instance.addPostFrameCallback(
                      (_) async {
                        showModalBottomSheet(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                          context: context,
                          builder: (context) => CalendarWidget(),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
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
                    AuthService _auth = AuthService();
                    _auth.signOut();
                    setState(() {
    
                      showSearchBar = false;
                      print(showSearchBar);
                      _auth.signOut();
                    });
                  },
                ),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(0.0),
            //   child: SizedBox(
            //     width: 40,
            //     height: 40,
            //     child: IconButton(
            //       icon: Icon(
            //         CupertinoIcons.gear,
            //       ),
            //       color: Colors.grey[850],
            //       splashColor: Colors.transparent,
            //       hoverColor: Colors.transparent,
            //       highlightColor: Colors.transparent,
            //       onPressed: () async {
            //         print('User UID: ${user.value?.uid}');
            //         // await userInfoAt(user.value!.uid, user.value!.username);
            //         getUserInfoFromAirtable(user.value!.uid);
            //       },
            //     ),
            //   ),
            // ),
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
            Text(
              'My Events',
              style: TextStyle(
                  color: Colors.grey[850], fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      AppBar(
        elevation: 0.0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Lists",
              style: TextStyle(
                  color: Colors.grey[850], fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: Row(
                children: [
                  ref.watch(isSelectable)
                      ? Container(
                          height: 32,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Colors.grey[850]),
                          child: TextButton(
                            onPressed: () async {
                                 ref.read(selectedContacts.notifier).state = [];
                              ref.read(isSelectable.notifier).state = false;
                            },
                            child: Text(
                              'Cancel',
                              style: TextStyle(color: Color(0xFFF5F5F5)),
                            ), 
                          ),
                        )
                      : SizedBox(
                          width: 30,
                          height: 30,
                          child: InkWell(
                            onTap: () {
                            },
                            borderRadius: BorderRadius.circular(
                                12), 
                            child: Container(
                              width: 25,
                              height: 25,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey[850],
                              ),
                              child: IconButton(
                                icon: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 15,
                                ),
                                onPressed: () async {
                                  listScreenAddMenu(context, ref);
                                },
                              ),
                            ),
                          ),
                        ),
                  SizedBox(width: 5),
                  SizedBox(
                    width: 30,
                    height: 30,
                    child: InkWell(
                      onTap: () {
                      },
                      child: Container(
                        width: 25,
                        height: 25,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey[850],
                        ),
                        child: IconButton(
                          icon: Icon(
                            CupertinoIcons.ellipsis,
                            color: Colors.white,
                            size: 15,
                          ),
                          onPressed: () async {
                            // ref
                            //     .read(contactsProvider)
                            //     .where((contact) => contact.lists
                            //         .contains("Shmuel's Bar Mitzvah"))
                            //     .forEach((contact) => print(contact.firstName));
                            listScreenEllipsisMenu(context, ref);
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: Color(0xFFF5F5F5),
      ),
      AppBar(
        elevation: 0.0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Settings',
              style: TextStyle(
                  color: Colors.grey[850], fontWeight: FontWeight.bold),
            ),
          ],
        ),
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
          Icons.email,
          'Invitations',
          0,
        ),
        buildBottomNavigationBarItem(Icons.event, 'My Events', 1),
        buildBottomNavigationBarItem(Icons.person, "Lists", 2),
        buildBottomNavigationBarItem(Icons.settings, 'Settings', 3),
      ],
      selectedItemColor: Colors.grey[850] ?? Colors.grey,
      backgroundColor: Color(0xFFF5F5F5),
      unselectedItemColor: Colors.grey[850],
      showSelectedLabels: false,
      showUnselectedLabels: false,
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
      IconData icon, String label, int itemIndex) {
    return BottomNavigationBarItem(
      icon: Container(
        width: 80,
        height: 61,
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color:
              currentIndex == itemIndex ? Color(0xFFE6D3B3) : Color(0xFFF5F5F5),
          // : Color(0xFFE6D3B3),
          border: Border.all(
              color: currentIndex == itemIndex
                  ? Color(0xFFE6D3B3)
                  : Color(0xFFF5F5F5)
              // : Color(0xFFE6D3B3),
              ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon),
            SizedBox(
              height: 5,
            ),
            Text(label,
                style: TextStyle(
                  fontSize: 12.0,
                  color: currentIndex == itemIndex
                      ? Colors.grey[850] ?? Colors.grey
                      : Colors.grey[850] ?? Colors.grey,
                )),
          ],
        ),
      ),
      label: '', 
    );
  }
}



// BottomNavyBar buildBottomNavyBar() {
  //   return BottomNavyBar(
  //     selectedIndex: currentIndex,
  //     curve: Curves.slowMiddle,
  //     onItemSelected: (index) {
  //       setState(() {
  //         currentIndex = index;
  //       });
  //     },
  //     items: [
  //       BottomNavyBarItem(
  //         icon: Icon(Icons.email),
  //         title: Text('Invitations'),
  //         activeColor: Colors.grey[850] ?? Colors.grey,
  //         inactiveColor: Colors.grey[850] ?? Colors.grey,
  //       ),
  //       BottomNavyBarItem(
  //         icon: Icon(Icons.event),
  //         title: Text('My Events'),
  //         activeColor: Colors.grey[850] ?? Colors.grey,
  //         inactiveColor: Colors.grey[850] ?? Colors.grey,
  //       ),
  //       BottomNavyBarItem(
  //         icon: Icon(Icons.person),
  //         title: Text('Lists'),
  //         activeColor: Colors.grey[850] ?? Colors.grey,
  //         inactiveColor: Colors.grey[850] ?? Colors.grey,
  //       ),
  //       BottomNavyBarItem(
  //         icon: Icon(Icons.settings),
  //         title: Text('Settings'),
  //         activeColor: Colors.grey[850] ?? Colors.grey,
  //         inactiveColor: Colors.grey[850] ?? Colors.grey,
  //       ),
  //     ],
  //   );
  // }