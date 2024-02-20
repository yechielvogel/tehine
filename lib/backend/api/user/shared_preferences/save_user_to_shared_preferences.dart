import 'dart:convert';


import 'package:shared_preferences/shared_preferences.dart';
import 'package:tehine/models/users_model.dart';

Future<void> saveUserToSP(Users user) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // Convert the user object to JSON
  String userJson = json.encode(user.toJson());

  // Save the JSON string to SharedPreferences
  prefs.setString('User', userJson);
}