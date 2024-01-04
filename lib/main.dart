import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tehine/screens/authenticate_screens/wrapper.dart';
import 'package:tehine/screens/navigation_screens/invitations_screen.dart';
import 'package:tehine/screens/navigation_screens/navigation_screen.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
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
    // ThemeProvider themeProvider = ThemeProvider();
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
      // themeMode: themeProvider.themeMode,
      // theme: MyThemes.lightTheme,
      // theme: MyThemes.darkTheme,
      // darkTheme: MyThemes.darkTheme,
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      home: NavigationScreen(),
      // home: Wrapper(),
    );
    // );
  }
}
