import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../models/contact_model.dart';
import '../../providers/contact_provider.dart';
import '../../providers/list_provider.dart';
import '../../providers/load_data_from_device_on_start.dart';
import '../../providers/user_provider.dart';
import '../../screens/navigation_screens/lists_screen.dart';

// This function will get all contacts from the Tehine data base

Future<void> getAllContactsFromAT(ref) async {
  final String airtableApiKey =
      'patS6BGUI9SY8OcFJ.fd3c067a6f9874f1847fddf6a21815d8b54dac5ed1b0340dae533856d0c9437a';
  final String airtableApiEndpoint =
      'https://api.airtable.com/v0/appRoQJZBl8WC5KWa/Contacts';
  final Uri uri = Uri.parse('$airtableApiEndpoint');

  try {
    final http.Response response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $airtableApiKey',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (responseData.containsKey('records') &&
          responseData['records'] is List &&
          responseData['records'].isNotEmpty) {
        List<ContactModel> contacts =
            responseData['records'].map<ContactModel>((record) {
          ContactModel contact = ContactModel.fromJson(record['fields']);

          contact.firstName = record['fields']['First Name'] ?? '';
          contact.lastName = record['fields']['Last Name'] ?? '';
          contact.phoneNumber = record['fields']['Phone'] ?? '';
          contact.phoneNumber = record['fields']['Phone'] ?? '';
          contact.email = record['fields']['Email'] ?? '';
          String listsString = record['fields']['Lists'] ?? '';
          List<String> splitList = listsString
              .split(',')
              .map((item) => item.trim())
              .where((item) => item.isNotEmpty)
              .toList();

          contact.lists = splitList;
          // This will save the lists to shared preference so we could get all lists
          saveListToSP(splitList);
          print('Original listsString: $listsString');
          print('After splitting: $splitList');
          return contact;
        }).toList();
        ref.read(filteredContactsProvider.notifier).state = contacts;
     (ref.read(filteredContactsProvider.notifier).state as List<ContactModel>).sort(
  (ContactModel a, ContactModel b) => a.lastName.compareTo(b.lastName)
);
      } else {}
    } else {
      print('Failed to fetch data. Status code: ${response.statusCode}');
      print(response.body);
    }
  } catch (e) {
    print('Error: $e');
  }
}

/* This function will check if there is any data on device if no will 
will call the next function that will check airtable and if yes will bring all 
the data down 
*/

Future<void> getAllDataFromAtOnStart(BuildContext context) async {
  final ref = ProviderScope.containerOf(context);
  ref.refresh(contactsFromSharedPrefProvider);
  print("Line 82 ${ref.read(contactsFromSharedPrefProvider)}");
  bool isThereAnyContactsDataOnDevice = false;
  final contacts = ref.read(contactsProvider);
  if (contacts.isNotEmpty) {
    isThereAnyContactsDataOnDevice = true;
    print('Line 87 there is data on device');
  }
  if (!isThereAnyContactsDataOnDevice) {
    print('Line 90 there is no data on device');
    // search airtable
    await loadContactsAndListsFromAT(
        ref.read(userStreamProvider).value!.uid, context);
    print('should run refresh');

    ref.refresh(contactsFromSharedPrefProvider);
  }
}

/* this will get all contacts for when a user 
logs in from a new device 
*/

Future<void> loadContactsAndListsFromAT(userId, BuildContext context) async {
  final ref = ProviderScope.containerOf(context);
  final String airtableApiKey =
      'patS6BGUI9SY8OcFJ.fd3c067a6f9874f1847fddf6a21ed1b0340dae533856d0c9437a';
  final String airtableApiEndpoint =
      'https://api.airtable.com/v0/appRoQJZBl8WC5KWa/Contacts';
  final Uri uri = Uri.parse(
      '$airtableApiEndpoint?filterByFormula=SEARCH("${Uri.encodeComponent(userId!)}", {Added By User})');
  try {
    final http.Response response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $airtableApiKey',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (responseData.containsKey('records') &&
          responseData['records'] is List &&
          responseData['records'].isNotEmpty) {
        List<ContactModel> contacts =
            responseData['records'].map<ContactModel>((record) {
          ContactModel contact = ContactModel.fromJson(record['fields']);

          contact.firstName = record['fields']['First Name'] ?? '';
          contact.lastName = record['fields']['Last Name'] ?? '';
          contact.phoneNumber = record['fields']['Phone'] ?? '';
          contact.phoneNumber = record['fields']['Phone'] ?? '';
          contact.email = record['fields']['Email'] ?? '';
          String listsString = record['fields']['Lists'] ?? '';
          List<String> splitList = listsString
              .split(',')
              .map((item) => item.trim())
              .where((item) => item.isNotEmpty)
              .toList();
          contact.lists = splitList;
          // This will save the lists to shared preference so we could get all lists
          saveListToSP(splitList);
          print('Original listsString: $listsString');
          print('After splitting: $splitList');
          return contact;
        }).toList();

        // Save all contacts to shared preferences after processing
        saveContactsToSP(contacts);
        ref.refresh(listFromSharedPrefranceProvider);
      } else {
        print('No contacts found for the user');
      }
    } else {
      print('Failed to fetch data. Status code: ${response.statusCode}');
      print(response.body);
    }
  } catch (e) {
    print('Error: $e');
  }
}
