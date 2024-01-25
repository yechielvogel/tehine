import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/contact_model.dart';
import '../../../providers/list_providers.dart';

// Need to refactor all this code and move around


// Lists
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

// Delete a list from shared preference

void removeListFromSP(String item, ref) async {           
  SharedPreferences prefs = await SharedPreferences.getInstance();

  List<String>? existingList = prefs.getStringList('Lists');

  existingList ??= ref.read(listProvider);

  if (existingList!.contains(item)) {
    existingList.remove(item);
    prefs.setStringList('Lists', existingList);
    await ref.refresh(listFromSharedPrefranceProvider);
  } else {
    print('Item not found in the list: $item');
  }
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
  List<ContactModel> contacts = contactsJson
          ?.map((jsonString) => ContactModel.fromJson(json.decode(jsonString)))
          .toList() as List<ContactModel>? ??
      [];

  // Remove the contact from the list
  contacts.removeWhere(
    (existingContact) => existingContact.phoneNumber == contact.phoneNumber,
  );

  // Save the updated list back to shared preferences
  List<String> updatedContactsJson =
      contacts.map((contact) => json.encode(contact.toJson())).toList();
  prefs.setStringList('Contacts', updatedContactsJson);
}
