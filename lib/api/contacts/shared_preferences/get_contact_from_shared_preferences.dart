import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/contact_model.dart';
import '../../../providers/list_providers.dart';

// Lists
// Get list from shared preference

Future<List<String>?> loadListsFromSP() async {
  SharedPreferences prefs;
  try {
    prefs = await SharedPreferences.getInstance();
  } catch (e) {
    return null;
  }

  List<String>? lists = prefs.getStringList('Lists');
  return lists;
}   

// Contacts
// Get contacts from shared preference

Future<List<ContactModel>?> loadContactsFromSP() async {
  SharedPreferences prefs;
  try {
    prefs = await SharedPreferences.getInstance();
  } catch (e) {
    return null;
  }

  List<String>? contactsJson = prefs.getStringList('Contacts');
  if (contactsJson == null) {
    return null;
  }

  List<ContactModel> contacts = contactsJson
      .map((contactJson) => ContactModel.fromJson(
          Map<String, dynamic>.from(json.decode(contactJson))))
      .toList();

  return contacts;
}