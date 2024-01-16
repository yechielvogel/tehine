import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/contact_model.dart';

class LoadAllDataFromDevice {
  static void runAllFunctions() {
    loadListsFromSP();
    // function2();
    // function3();
  }

  static void function1() {
    print('Function 1 executed');
  }
}

// Lists
// Load list from shared preference

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

// Save list to shared preference

void saveListToSP(List<String> data) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  List<String>? existingList = prefs.getStringList('Lists');

  existingList ??= [
    'Tehine',
    'All',
    'Wedding List',
    "Shmuel's Bar Mitzvah",
    'Engagement',
  ];

  for (String item in data) {
    if (!existingList.contains(item)) {
      existingList.add(item);
    }
  }

  // Save the modified list back to SharedPreferences
  prefs.setStringList('Lists', existingList);
}

// Contacts
// Load contacts from shared preference

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

// Save contacts to SharedPreferences
Future<void> saveContactsToSP(List<ContactModel> contacts) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // Remove duplicates based on phone number
  Map<String, ContactModel> uniqueContactsMap = {};
  for (ContactModel contact in contacts) {
    uniqueContactsMap[contact.phoneNumber] = contact;
  }

  List<ContactModel> uniqueContacts = uniqueContactsMap.values.toList();

  List<String> contactsJson =    
      uniqueContacts.map((contact) => json.encode(contact.toJson())).toList();

  prefs.setStringList('Contacts', contactsJson);
}

Future<void> deleteContactFromSP(ContactModel contact) async {    
  SharedPreferences prefs = await SharedPreferences.getInstance();

  List<String>? contactsJson = prefs.getStringList('Contacts');
  List<ContactModel> contacts = contactsJson?.map((jsonString) => ContactModel.fromJson(json.decode(jsonString))).toList() as List<ContactModel>? ?? [];

  // Remove the contact from the list
  contacts.removeWhere(
    (existingContact) => existingContact.phoneNumber == contact.phoneNumber,
  );

  // Save the updated list back to shared preferences
  List<String> updatedContactsJson =
      contacts.map((contact) => json.encode(contact.toJson())).toList();
  prefs.setStringList('Contacts', updatedContactsJson);
}


