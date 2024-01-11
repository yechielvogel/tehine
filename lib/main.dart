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