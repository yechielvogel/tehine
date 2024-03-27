import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tehine/shared/style.dart';

import '../../backend/authenticate/auth.dart';
import '../../backend/api/contacts/shared_preferences/get_contact_from_shared_preferences.dart';
import '../../backend/api/events/shared_preferences/get_event_from_shared_preference.dart';
import '../../backend/api/user/shared_preferences/get_user_from_shared_preferences.dart';
import '../../providers/contact_providers.dart';
import '../../providers/event_providers.dart';
import '../../providers/user_providers.dart';
import '../../widgets/bottom_sheet_widgets/calendar_widget.dart';
import '../../widgets/menus/list_menus/for_list_screen/list_screen_add_menu.dart';
import '../../widgets/menus/list_menus/for_list_screen/list_screen_ellipsis_menu.dart';
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
        backgroundColor: seaSault, // Cream
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Invitations',
              style: TextStyle(
                color: darkGrey,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    CupertinoIcons.calendar,
                  ),
                  color: steelBlue,
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
                IconButton(
                  icon: Icon(
                    CupertinoIcons.search,
                  ),
                  color: steelBlue,
                  splashColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onPressed: () async {
                    AuthService _auth = AuthService();
                    _auth.signOut(ref);
                    setState(() {
                      showSearchBar = false;
                      // print(showSearchBar);
                      _auth.signOut(ref);
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),

      // bellow are different appBars

      AppBar(
        elevation: 0.0,
        backgroundColor: seaSault,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'My Events',
              style: TextStyle(color: darkGrey, fontWeight: FontWeight.bold),
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
              style: TextStyle(color: darkGrey, fontWeight: FontWeight.bold),
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
                              color: steelBlue),
                          child: TextButton(
                            onPressed: () async {
                              ref.read(selectedContacts.notifier).state = [];
                              ref.read(isSelectable.notifier).state = false;
                            },
                            child: Text(
                              'Done',
                              style: TextStyle(color: seaSault),
                            ),
                          ),
                        )
                      : IconButton(
                          icon: Icon(
                            Icons.add,
                            color: steelBlue,
                            size: 25,
                          ),

                          // padding: EdgeInsets.all(0),
                          onPressed: () async {
                            listScreenAddMenu(context, ref);
                          },
                        ),
                  // SizedBox(width: 5),
                  IconButton(
                    icon: Icon(
                      CupertinoIcons.ellipsis,
                      color: steelBlue,
                      size: 25,
                    ),
                    onPressed: () async {
                      // ref
                      //     .read(contactsProvider)
                      //     .where((contact) => contact.lists
                      //       Color.fromARGB(255, 190, 154, 154)"Shmuel's Bar Mitzvah"))
                      //     .forEach((contact) => print(contact.firstName));
                      listScreenEllipsisMenu(context, ref);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: seaSault,
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
        backgroundColor: seaSault,
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
      selectedItemColor: darkGrey,
      backgroundColor: seaSault,
      unselectedItemColor: darkGrey,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      selectedFontSize: 10,
      elevation: 0,
      unselectedFontSize: 10,
      type: BottomNavigationBarType.fixed,
      onTap: (index) async {
        if (index == 0) {
          await populateUsersProviderIfDataExists(ref);
        }
        if (index == 1) {
          if (ref.read(eventsProvider).isEmpty) {
            // print('events length before ${ref.read(eventsProvider).length}');
            await populateEventsProviderIfDataExists(ref);
            // print('events length after ${ref.read(eventsProvider).length}');
          }
        }
        /*
      The following is for the list page to check if there is any contacts
      if yes it will fill the provider if not will do other functions 
      */
        if (index == 2) {
          if (ref.read(contactsProviderCheck).isEmpty) {
            await populateContactsProviderIfDataExists(ref);
          }
        }
        AnimatedPositioned(
          duration: Duration(milliseconds: 300),
          left: currentIndex * 80,
          bottom: 30,
          child: Container(
            width: 80,
            height: 10,
            decoration: BoxDecoration(
              color: Colors.grey[850],
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        );
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
          color: currentIndex == itemIndex ? ashGrey : seaSault,
          // : Color(0xFFE6D3B3),
          border:
              Border.all(color: currentIndex == itemIndex ? seaSault : seaSault
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
                    color: currentIndex == itemIndex ? darkGrey : darkGrey)),
          ],
        ),
      ),
      label: '',
    );
  }
}




// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import '../../authenticate/auth.dart';
// import '../../providers/contact_providers.dart';
// import '../../providers/user_providers.dart';
// import '../../widgets/bottom_sheet_widgets/calendar_widget.dart';
// import '../../widgets/menus/list_menus/for_list_screen/list_screen_add_menu.dart';
// import '../../widgets/menus/list_menus/for_list_screen/list_screen_ellipsis_menu.dart';
// import 'settings_screen.dart';
// import 'lists_screen.dart';
// import 'invitations_screen.dart';
// import 'my_events_screen.dart';

// class NavigationScreen extends ConsumerStatefulWidget {
//   const NavigationScreen({Key? key}) : super(key: key);

//   @override
//   ConsumerState createState() => _NavigationScreenState();
// }

// class _NavigationScreenState extends ConsumerState<NavigationScreen> {
//   bool showSearchBar = false;
//   int currentIndex = 0;

//   final List<Widget> screens = [
//     InvitationsScreen(
//       showSearchBar: false,
//     ),
//     MyEventsScreen(key: UniqueKey()),
//     ListsScreen(key: UniqueKey()),
//     SettingsScreen(key: UniqueKey()),
//   ];
//   double boxLeft = 0.0;

//   @override
//   void initState() {
//     super.initState();
//     (screens[0] as InvitationsScreen).showSearchBar = showSearchBar;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final user = ref.watch(userStreamProvider);
//     final List<AppBar> appBars = [
//       AppBar(
//         elevation: 0.0,
//         backgroundColor: seaSault, // cream
//         // backgroundColor: Theme.of(context).colorScheme.background,
//         title: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               'Invitations',
//               style: TextStyle(
//                   color: Colors.grey[850], fontWeight: FontWeight.bold),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(left: 170),
//               child: SizedBox(
//                 width: 40,
//                 height: 40,
//                 child: IconButton(
//                   icon: Icon(
//                     CupertinoIcons.calendar,
//                   ),
//                   color: Colors.grey[850],
//                   splashColor: Colors.transparent,
//                   hoverColor: Colors.transparent,
//                   highlightColor: Colors.transparent,
//                   onPressed: () {
//                     AuthService _auth = AuthService();
//                     WidgetsBinding.instance.addPostFrameCallback(
//                       (_) async {
//                         showModalBottomSheet(
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.vertical(
//                               top: Radius.circular(20),
//                             ),
//                           ),
//                           context: context,
//                           builder: (context) => CalendarWidget(),
//                         );
//                       },
//                     );
//                   },
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(0.0),
//               child: SizedBox(
//                 width: 40,
//                 height: 40,
//                 child: IconButton(
//                   icon: Icon(
//                     CupertinoIcons.search,
//                   ),
//                   color: Colors.grey[850],
//                   splashColor: Colors.transparent,
//                   hoverColor: Colors.transparent,
//                   highlightColor: Colors.transparent,
//                   onPressed: () async {
//                     AuthService _auth = AuthService();
//                     _auth.signOut();
//                     setState(() {
//                       showSearchBar = false;
//                       print(showSearchBar);
//                       _auth.signOut();
//                     });
//                   },
//                 ),
//               ),
//             ),
//             // Padding(
//             //   padding: const EdgeInsets.all(0.0),
//             //   child: SizedBox(
//             //     width: 40,
//             //     height: 40,
//             //     child: IconButton(
//             //       icon: Icon(
//             //         CupertinoIcons.gear,
//             //       ),
//             //       color: Colors.grey[850],
//             //       splashColor: Colors.transparent,
//             //       hoverColor: Colors.transparent,
//             //       highlightColor: Colors.transparent,
//             //       onPressed: () async {
//             //         print('User UID: ${user.value?.uid}');
//             //         // await userInfoAt(user.value!.uid, user.value!.username);
//             //         getUserInfoFromAirtable(user.value!.uid);
//             //       },
//             //     ),
//             //   ),
//             // ),
//           ],
//         ),
//       ),

//       // bellow are different appBars

//       AppBar(
//         elevation: 0.0,
//         backgroundColor: seaSault,
//         title: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               'My Events',
//               style: TextStyle(
//                   color: Colors.grey[850], fontWeight: FontWeight.bold),
//             ),
//           ],
//         ),
//       ),
//       AppBar(
//         elevation: 0.0,
//         title: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               "Lists",
//               style: TextStyle(
//                   color: Colors.grey[850], fontWeight: FontWeight.bold),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(0.0),
//               child: Row(
//                 children: [
//                   ref.watch(isSelectable)
//                       ? Container(
//                           height: 32,
//                           decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(20.0),
//                               color: Colors.grey[850]),
//                           child: TextButton(
//                             onPressed: () async {
//                               ref.read(selectedContacts.notifier).state = [];
//                               ref.read(isSelectable.notifier).state = false;
//                             },
//                             child: Text(
//                               'Cancel',
//                               style: TextStyle(color: seaSault),
//                             ),
//                           ),
//                         )
//                       : SizedBox(
//                           width: 30,
//                           height: 30,
//                           child: InkWell(
//                             onTap: () {},
//                             borderRadius: BorderRadius.circular(12),
//                             child: Container(
//                               width: 25,
//                               height: 25,
//                               decoration: BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 color: Colors.grey[850],
//                               ),
//                               child: IconButton(
//                                 icon: Icon(
//                                   Icons.add,
//                                   color: Colors.white,
//                                   size: 15,
//                                 ),
//                                 onPressed: () async {
//                                   listScreenAddMenu(context, ref);
//                                 },
//                               ),
//                             ),
//                           ),
//                         ),
//                   SizedBox(width: 5),
//                   SizedBox(
//                     width: 30,
//                     height: 30,
//                     child: InkWell(
//                       onTap: () {},
//                       child: Container(
//                         width: 25,
//                         height: 25,
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           color: Colors.grey[850],
//                         ),
//                         child: IconButton(
//                           icon: Icon(
//                             CupertinoIcons.ellipsis,
//                             color: Colors.white,
//                             size: 15,
//                           ),
//                           onPressed: () async {
//                             // ref
//                             //     .read(contactsProvider)
//                             //     .where((contact) => contact.lists
//                             //         .contains("Shmuel's Bar Mitzvah"))
//                             //     .forEach((contact) => print(contact.firstName));
//                             listScreenEllipsisMenu(context, ref);
//                           },
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//         backgroundColor: seaSault,
//       ),
//       AppBar(
//         elevation: 0.0,
//         title: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               'Settings',
//               style: TextStyle(
//                   color: Colors.grey[850], fontWeight: FontWeight.bold),
//             ),
//           ],
//         ),
//         backgroundColor: seaSault,
//       ),
//     ];
//     return Scaffold(
//       appBar: appBars[currentIndex],
//       body: screens[currentIndex],
//       bottomNavigationBar: AnimatedBottomNavigationBar(
//         currentIndex: currentIndex,
//         onTabSelected: (index) {
//           setState(() {
//             currentIndex = index;
//           });
//         },
//       ),
//     );
//   }

//   BottomNavigationBarItem buildBottomNavigationBarItem(
//       IconData icon, String label, int itemIndex) {
//     return BottomNavigationBarItem(
//       icon: AnimatedContainer(
//         duration: Duration(milliseconds: 300),
//         width: 80,
//         height: 61,
//         padding: EdgeInsets.all(8.0),
//         alignment: Alignment.center,
//         decoration: BoxDecoration(
//           color:
//               currentIndex == itemIndex ? Colors.grey[850] : seaSault,
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(icon),
//             SizedBox(
//               height: 5,
//             ),
//             Text(
//               label,
//               style: TextStyle(
//                 fontSize: 12.0,
//                 color: currentIndex == itemIndex
//                     ? seaSault
//                     : Colors.grey[850],
//               ),
//             ),
//           ],
//         ),
//       ),
//       label: '',
//     );
//   }
// }

// class AnimatedBottomNavigationBar extends StatelessWidget {
//   final int currentIndex;
//   final Function(int) onTabSelected;
//   final double itemWidth = 80.0; // Width of each item

//   AnimatedBottomNavigationBar({
//     required this.currentIndex,
//     required this.onTabSelected,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       alignment: Alignment.center,
//       children: [
//         // Bottom navigation bar items
//         BottomNavigationBar(
//           currentIndex: currentIndex,
//           items: [
//             buildBottomNavigationBarItem(
//               Icons.email,
//               'Invitations',
//               0,
//             ),
//             buildBottomNavigationBarItem(Icons.event, 'My Events', 1),
//             buildBottomNavigationBarItem(Icons.person, "Lists", 2),
//             buildBottomNavigationBarItem(Icons.settings, 'Settings', 3),
//           ],
//           selectedItemColor: seaSault,
//           backgroundColor: seaSault,
//           unselectedItemColor: Colors.grey[850],
//           showSelectedLabels: false,
//           showUnselectedLabels: false,
//           selectedFontSize: 10,
//           elevation: 0,
//           unselectedFontSize: 10,
//           type: BottomNavigationBarType.fixed,
//           onTap: onTabSelected,
//         ),
//         // Animated indicator
//         AnimatedPositioned(
//           duration: Duration(milliseconds: 300),
//           left: currentIndex *
//               itemWidth, // Adjust position based on current index
//           bottom: 30,
//           child: Container(
//             width: 80,
//             height: 10,
//             decoration: BoxDecoration(
//               color: Colors.grey[850],
//               borderRadius: BorderRadius.circular(20),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   BottomNavigationBarItem buildBottomNavigationBarItem(
//       IconData icon, String label, int itemIndex) {
//     return BottomNavigationBarItem(
//       icon: Container(
//         width: 80,
//         height: 61,
//         padding: EdgeInsets.all(8.0),
//         decoration: BoxDecoration(
//           color:
//               currentIndex == itemIndex ? Colors.grey[850] : seaSault,
//           border: Border.all(
//             color: currentIndex == itemIndex
//                 ? Colors.grey[850] ?? Colors.grey
//                 : seaSault,
//           ),
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(icon),
//             SizedBox(height: 5),
//             Text(
//               label,
//               style: TextStyle(
//                 fontSize: 12.0,
//                 color: currentIndex == itemIndex
//                     ? seaSault
//                     : Colors.grey[850] ?? Colors.grey,
//               ),
//             ),
//           ],
//         ),
//       ),
//       label: '',
//     );
//   }
// }
