import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

// class ThemeProvider with WidgetsBindingObserver, ChangeNotifier {
//   SystemUiOverlayStyle _getSystemUIOverlayStyle() {
//     if (isDarkMode ||
//         WidgetsBinding.instance.window.platformBrightness == Brightness.dark) {
//       return SystemUiOverlayStyle.light;
//     } else {
//       return SystemUiOverlayStyle.dark;
//     }
//   }

//   Future<void> saveSettings() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setBool('isSystem', isSystem);
//     await prefs.setBool('isDarkMode', isDarkMode);
//   }

//   Future<void> loadSettings() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     isSystem = prefs.getBool('isSystem') ?? false;
//     themeMode =
//         prefs.getBool('isDarkMode') ?? false ? ThemeMode.dark : ThemeMode.light;
//     SystemChrome.setSystemUIOverlayStyle(_getSystemUIOverlayStyle());
//     notifyListeners();
//   }

//   ThemeMode themeMode = ThemeMode.light;

//   bool isSystem = false;

//   bool get isDarkMode => themeMode == ThemeMode.dark;

//   ThemeProvider() {
//     WidgetsBinding.instance.addObserver(this);
//   }

//   @override
//   void didChangePlatformBrightness() {
//     if (isSystem) {
//       final brightness = WidgetsBinding.instance.window.platformBrightness;
//       if (brightness == Brightness.dark) {
//         themeMode = ThemeMode.dark;
//         SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
//       } else if (brightness == Brightness.light) {
//         themeMode = ThemeMode.light;
//         SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
//       }

//       notifyListeners();
//     }
//   }

//   void toggleTheme(bool isOn) {
//     if (isSystem &&
//         isDarkMode &&
//         WidgetsBinding.instance.window.platformBrightness == Brightness.light) {
//       themeMode = ThemeMode.light;
//       WidgetsBinding.instance.addObserver(this);
//     }
//     WidgetsBinding.instance.addObserver(this);

//     themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
//     notifyListeners();

//     SystemChrome.setSystemUIOverlayStyle(
//       isDarkMode ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
//     );
//   }

//   void toggleSystem(bool isOn) {
//     WidgetsBinding.instance.addObserver(this);

//     isSystem = isOn;
//     if (isSystem) {
//       final brightness = WidgetsBinding.instance.window.platformBrightness;
//       WidgetsBinding.instance.addObserver(this);

//       if (brightness == Brightness.dark) {
//         SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
//         WidgetsBinding.instance.addObserver(this);
//         if (isDarkMode &&
//             isSystem &&
//             WidgetsBinding.instance.window.platformBrightness ==
//                 Brightness.light) {
//           themeMode = ThemeMode.light;
//           WidgetsBinding.instance.addObserver(this);
//         }

//         themeMode = ThemeMode.dark;
//       } else {
//         WidgetsBinding.instance.addObserver(this);

//         themeMode = ThemeMode.light;
//       }

//       SystemChrome.setSystemUIOverlayStyle(
//         isDarkMode ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
//       );
//     } else {
//       WidgetsBinding.instance.addObserver(this);

//       themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
//       SystemChrome.setSystemUIOverlayStyle(
//         isDarkMode ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
//       );
//     }

//     notifyListeners();
//   }

//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     super.dispose();
//   }
// }

// class MyThemes {
//   static final darkTheme = ThemeData(
//       brightness: Brightness.dark,
//       colorScheme: const ColorScheme.dark(
//         background: Color(0xFF1F1F1F), // Colors.grey[850]
//         primary: seaSault,
//         // secondary: seaSault, // white cream
//         secondaryContainer: Color(0xFFE6D3B3), // beige
//       ));

//   static final lightTheme = ThemeData(
//       brightness: Brightness.light,
//       colorScheme: const ColorScheme.light(
//           background: seaSault, // cream white
//           primary: Color(0xFF1F1F1F), // cream white
//           // secondary: Color(0xFFE6D3B3), // Colors.grey[850]

//           secondaryContainer: Color(0xFFE6D3B3)));
// }
