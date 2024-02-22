import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tehine/screens/authenticate_screens/wrapper.dart';

import 'Themes/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  ThemeProvider themeProvider = ThemeProvider();
  await themeProvider.loadSettings();

  // ThemeProvider themeProvider = ThemeProvider();

  runApp(ProviderScope(
    child: MyApp(),
  ));
  // WidgetsBinding.instance.addObserver(
  //   AppLifecycleObserver(themeProvider: themeProvider),
  // );
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = ThemeProvider();
    return

        // MultiProvider(
        //   providers: [
        //     StreamProvider<Users?>.value(
        //       value: AuthService().user,
        //       initialData: null,
        //     ),
        //   ],
        //   child:
        MaterialApp(
      themeMode: themeProvider.themeMode,
// lightTheme: MyThemes.lightTheme,
      darkTheme: MyThemes.darkTheme,
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      home: Wrapper(),
    );
    // );
  }
}

class AppLifecycleObserver extends WidgetsBindingObserver {
  final ThemeProvider themeProvider;

  AppLifecycleObserver({required this.themeProvider});

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      themeProvider.saveSettings();
    }
  }
}

SystemUiOverlayStyle _getSystemUIOverlayStyle(ThemeProvider themeProvider) {
  if (WidgetsBinding.instance.window.platformBrightness == Brightness.dark ||
      themeProvider.isDarkMode) {
    return const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    );
  }

  return const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  );
}

// FutureBuilder<void>(
//   future: getAllDataFromAtOnStart(context),
//   builder: (context, snapshot) {
//     if (snapshot.connectionState == ConnectionState.waiting) {
//       // Display a loading indicator while waiting for data
//       return Loading();
//     } else if (snapshot.hasError) {
//       // Handle errors
//       return Text('Error: ${snapshot.error}');
//     } else {
//       // Data has been fetched, build your UI here
//       return Consumer(
//         builder: (context, watch, child) {
//           final filteredContacts =
//               ref.watch(filteredContactsProvider);
//           final checkIfContactsProviderIsEmpty =
//               ref.watch(contactsProvider);

//           // Check if contactsProvider is empty
//           if (checkIfContactsProviderIsEmpty.isEmpty) {
//             print('contacts are empty');
//             return Loading(); // Show loading indicator while fetching data
//           } else {
//             // Contacts are available, build contact list
//             return Column(
//               children: [
//                 SizedBox(height: 10),
//                 Listener(
//                   onPointerMove: (event) async {
//                     loadMore();
//                   },
//                   child: ListView.builder(
//                     key: ValueKey(ref.watch(isSelectable)),
//                     physics: NeverScrollableScrollPhysics(),
//                     shrinkWrap: true,
//                     itemCount: filteredContacts.length,
//                     itemBuilder: (BuildContext context, int index) {
//                       final contact = filteredContacts[index];
//                       return Padding(
//                         padding: const EdgeInsets.only(
//                           top: 6,
//                           bottom: 6,
//                         ),
//                         child: ref
//                                 .watch(isSelectable.notifier)
//                                 .state
//                             ? Hero(
//                                 tag:
//                                     'contactHeroTag_${contact.phoneNumber}',
//                                 child: SelectContactTileWidget(
//                                   contact: contact,
//                                 ),
//                               )
//                             : ContactTileWidget(contact: contact),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             );
//           }
//         },
//       );
//     }
//   },
// ),
