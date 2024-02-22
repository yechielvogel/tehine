import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tehine/providers/user_providers.dart';

import '../../../../models/users_model.dart';

Future<Users?> loadUserFromSP() async {
  SharedPreferences prefs;
  try {
    prefs = await SharedPreferences.getInstance();
  } catch (e) {
    return null;
  }

  String? userJson = prefs.getString('User');
  if (userJson == null) {
    return null;
  }

  return Users.fromJson(Map<String, dynamic>.from(json.decode(userJson)));
}

Future<Users?> loadUserRecordIDFromSP() async {
  SharedPreferences prefs;
  try {
    prefs = await SharedPreferences.getInstance();
  } catch (e) {
    return null;
  }

  String? userJson = prefs.getString('User');
  if (userJson == null) {
    return null;
  }

  Users user = Users.fromJson(Map<String, dynamic>.from(json.decode(userJson)));
  return user; // Return the userRecordID
}

Future<void> populateUsersProviderIfDataExists(WidgetRef ref) async {
  final Users? user = await loadUserRecordIDFromSP();
  if (user != null) {
    // print('pop user rec ${user.userRecordID}');
    ref.read(userRecordIDProvider.notifier).state = user.userRecordID!;
  }
}
