import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../../../models/contact_model.dart';
import '../../../../providers/contact_providers.dart';
import '../../../../providers/event_providers.dart';
import '../../../../providers/general_providers.dart';
import '../../../../providers/list_providers.dart';
import '../../events/airtable/get_events.dart';
import '../shared_preferences/save_contacts_to_shared_preferences.dart';
import '../../../../providers/user_providers.dart';

// This function will get all contacts from the Tehine data base

final String airtableApiKey =
    'patS6BGUI9SY8OcFJ.fd3c067a6f9874f1847fddf6a21815d8b54dac5ed1b0340dae533856d0c9437a';
final String airtableApiEndpoint =
    'https://api.airtable.com/v0/appRoQJZBl8WC5KWa/Contacts';

int pageSize = 20;

Future<void> getAllContactsFromAT(ref) async {
  String offset = ref.read(offsetProvider);

  try {
    final Uri uri = Uri.parse(
      '$airtableApiEndpoint?filterByFormula=NOT({Last Name} = "")&sort%5B0%5D%5Bfield%5D=Last%20Name&sort%5B0%5D%5Bdirection%5D=asc&pageSize=$pageSize${offset.isNotEmpty ? '&offset=$offset' : ''}',
    );

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
          contact.contactRecordID = record['id'] ?? '';
          // Extracting linked record ID
          contact.userRecordID = (record['fields']
                      ['User Record ID (from User Link)'] as List<dynamic>?)
                  ?.join() ??
              '';
          contact.firstName = record['fields']['First Name'] ?? '';
          contact.lastName = record['fields']['Last Name'] ?? '';
          contact.phoneNumber = record['fields']['Phone Number'] ?? '';
          contact.email = record['fields']['Email'] ?? '';
          contact.addressStreet = record['fields']['Address Street'] ?? '';
          contact.addressCity = record['fields']['Address City'] ?? '';
          contact.addressState = record['fields']['Address State'] ?? '';
          contact.addressZip = record['fields']['Address Zip'] ?? '';
          contact.addressCountry = record['fields']['Address Country'] ?? '';
          String listsString = record['fields']['Lists'] ?? '';
          List<String> splitList = listsString
              .split(',')
              .map((item) => item.trim())
              .where((item) => item.isNotEmpty)
              .toList();
          contact.lists = splitList;
          saveListsToSP(splitList);
          print(contact.userRecordID);
          return contact;
        }).toList();

        // Reset offset when making a new request
        Set<String> uniquecontactRecordIDs = Set<String>();
        List<ContactModel> _contacts = [];

        contacts.forEach(
          (contact) {
            if (!uniquecontactRecordIDs.contains(contact.contactRecordID)) {
              uniquecontactRecordIDs.add(contact.contactRecordID);
              _contacts.add(contact);
            }
          },
        );

        ref.read(offsetProvider.notifier).state = responseData['offset'] ?? '';

        _contacts.sort((a, b) => a.lastName.compareTo(b.lastName));

        List<ContactModel> currentContacts =
            ref.read(filteredContactsProvider.notifier).state;

        Set<String> currentcontactRecordIDs = Set<String>.from(
            currentContacts.map((contact) => contact.contactRecordID));

        List<ContactModel> filteredUniqueContacts = _contacts
            .where((contact) =>
                !currentcontactRecordIDs.contains(contact.contactRecordID))
            .toList();

        currentContacts.addAll(filteredUniqueContacts);

        ref.read(filteredContactsProvider.notifier).state = [
          ...currentContacts
        ];
      } else {
        // No more records to fetch
      }
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

Future<void> getAllContactsDataFromAtOnStart(BuildContext context) async {
  final ref = ProviderScope.containerOf(context);
  ref.refresh(contactsFromSharedPrefProvider);
  ref.refresh(eventsFromSharedPrefProvider);
  print('contacts length: ${ref.read(contactsProvider).length}');

  // print("Line 82 ${ref.read(contactsFromSharedPrefProvider)}");
  bool isThereAnyDataOnDevice = false;
  final contacts = ref.read(contactsProvider);
  final events = ref.read(eventsProvider);
  if (contacts.isNotEmpty) {
    isThereAnyDataOnDevice = true;
    print('Line 87 there is data on device');
  }
  if (!isThereAnyDataOnDevice) {
    print('Line 90 there is no data on device');
    // search airtable
    try {
      // should put this back when finished making invitations
      // await loadEventsFromAT(ref.read(userStreamProvider).value!.uid, context);
      await loadContactsAndListsFromAT(
          ref.read(userStreamProvider).value!.uid, context);
      await loadEventsFromAT(ref.read(userStreamProvider).value!.uid, context);

      // Check if the widget is mounted before updating the state
      if (context != null && context.findRenderObject() != null) {
        ref.refresh(contactsFromSharedPrefProvider);
        ref.refresh(eventsFromSharedPrefProvider);
      }
    } catch (e) {
      // Handle any errors during the asynchronous operations
      print('Error during data loading: $e');
    }
  }
}

/* this will get all contacts for when a user 
logs in from a new device    
*/

// this should be working should double check test a few times.

Future<void> loadContactsAndListsFromAT(
    userFirebaseID, BuildContext context) async {
  final ref = ProviderScope.containerOf(context);
  final String airtableApiKey =
      'patS6BGUI9SY8OcFJ.fd3c067a6f9874f1847fddf6a21815d8b54dac5ed1b0340dae533856d0c9437a';
  final String airtableApiEndpoint =
      'https://api.airtable.com/v0/appRoQJZBl8WC5KWa/Saved%20Contacts';

  try {
    final Uri uri = Uri.parse(
        '$airtableApiEndpoint?filterByFormula={Saved By User} = "${Uri.encodeComponent(userFirebaseID!)}"');
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
        List<ContactModel> contacts = [];

        for (var record in responseData['records']) {
          // Use an asynchronous function inside the loop
          ContactModel contact = await mapRecordToContact(record);
          contacts.add(contact);
        }

        // Save all contacts to shared preferences after processing
        saveContactsToSP(contacts);
        print('saving to shared preference');
        print(ref.read(contactsProvider).length);
        ref.refresh(listFromSharedPreferenceProvider);
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

// Asynchronous function to map a record to a ContactModel
Future<ContactModel> mapRecordToContact(dynamic record) async {
  ContactModel contact = ContactModel.fromJson(record['fields']);

  // Fetch additional details from linked "Contacts" table
  if (record['fields']['Contact Link'] != null) {
    String contactLink = record['fields']['Contact Link'][0];
    final Uri contactUri = Uri.parse(
        'https://api.airtable.com/v0/appRoQJZBl8WC5KWa/Contacts/$contactLink');

    final http.Response contactResponse = await http.get(
      contactUri,
      headers: {
        'Authorization':
            'Bearer patS6BGUI9SY8OcFJ.fd3c067a6f9874f1847fddf6a21815d8b54dac5ed1b0340dae533856d0c9437a',
        'Content-Type': 'application/json',
      },
    );

    if (contactResponse.statusCode == 200) {
      Map<String, dynamic> contactFields =
          jsonDecode(contactResponse.body)['fields'];

      contact.firstName = contactFields['First Name'] ?? '';
      contact.lastName = contactFields['Last Name'] ?? '';
      contact.phoneNumber = contactFields['Phone Number'] ?? '';
      contact.email = contactFields['Email'] ?? '';
      contact.addressStreet = record['fields']['Address Street'] ?? '';
      contact.addressCity = record['fields']['Address City'] ?? '';
      contact.addressState = record['fields']['Address State'] ?? '';
      contact.addressZip = record['fields']['Address Zip'] ?? '';
      contact.addressCountry = record['fields']['Address Country'] ?? '';
    } else {
      print(
          'Failed to fetch additional contact details. Status code: ${contactResponse.statusCode}');
      print(contactResponse.body);
    }
  }

  // Extract lists from "Saved Contacts" table
  String listsString = record['fields']['Lists'] ?? '';
  List<String> splitList = listsString
      .split(',')
      .map((item) => item.trim())
      .where((item) => item.isNotEmpty)
      .toList();
  contact.lists = splitList;

  // This will save the lists to shared preference so we could get all lists
  saveListsToSP(splitList);

  // print('Original listsString: $listsString');
  // print('After splitting: $splitList');

  return contact;
}

// Search a contact airtable

Future<void> searchTehineContacts(
  ref,
  String search,
) async {
  final String airtableApiKey =
      'patS6BGUI9SY8OcFJ.fd3c067a6f9874f1847fddf6a21815d8b54dac5ed1b0340dae533856d0c9437a';
  final String airtableApiEndpoint =
      'https://api.airtable.com/v0/appRoQJZBl8WC5KWa/Contacts';

  try {
    final Uri uri = Uri.parse(
      '$airtableApiEndpoint?filterByFormula=OR(SEARCH("${Uri.encodeComponent(search.toLowerCase())}", LOWER({First Name})), SEARCH("${Uri.encodeComponent(search.toLowerCase())}", LOWER({Last Name})))',
    );

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
          contact.contactRecordID = record['id'] ?? '';
          contact.userRecordID = (record['fields']
                      ['User Record ID (from User Link)'] as List<dynamic>?)
                  ?.join() ??
              '';

          contact.firstName = record['fields']['First Name'] ?? '';
          contact.lastName = record['fields']['Last Name'] ?? '';
          contact.phoneNumber = record['fields']['Phone Number'] ?? '';
          contact.email = record['fields']['Email'] ?? '';
          contact.addressStreet = record['fields']['Address Street'] ?? '';
          contact.addressCity = record['fields']['Address City'] ?? '';
          contact.addressState = record['fields']['Address State'] ?? '';
          contact.addressZip = record['fields']['Address Zip'] ?? '';
          contact.addressCountry = record['fields']['Address Country'] ?? '';
          String listsString = record['fields']['Lists'] ?? '';
          List<String> splitList = listsString
              .split(',')
              .map((item) => item.trim())
              .where((item) => item.isNotEmpty)
              .toList();
          contact.lists = splitList;
          saveListsToSP(splitList);
          return contact;
        }).toList();
        // ref.read(tehineContacts.notifier).state = contacts;

        // Reset offset when making a new request
        // _contacts.clear();

        Set<String> uniquecontactRecordIDs = Set<String>();
        List<ContactModel> _contacts = [];

        List<ContactModel> uniqueContacts = contacts.toSet().toList();

        uniqueContacts.forEach(
          (contact) {
            if (!uniquecontactRecordIDs.contains(contact.contactRecordID)) {
              uniquecontactRecordIDs.add(contact.contactRecordID);
              _contacts.add(contact);
            }
          },
        );

// Update the offset for the next page

        uniqueContacts.sort((a, b) => a.lastName.compareTo(b.lastName));

// Get the current contacts from the provider
        List<ContactModel> currentContacts =
            ref.read(filteredContactsProvider.notifier).state;

// Create a set to track unique contact IDs in the current state
        Set<String> currentcontactRecordIDs = Set<String>.from(
            currentContacts.map((contact) => contact.contactRecordID));

// Filter out duplicates from the new uniqueContacts
        List<ContactModel> filteredUniqueContacts = uniqueContacts
            .where((contact) =>
                !currentcontactRecordIDs.contains(contact.contactRecordID))
            .toList();

// Add the filtered uniqueContacts to the existing list
        currentContacts.addAll(filteredUniqueContacts);

// Update the state with the combined list using a new list
        ref.read(filteredContactsProvider.notifier).state = [
          ...currentContacts
        ];
      } else {
        // offset = '';
        // No more records to fetch
      }
    } else {
      print('Failed to fetch data. Status code: ${response.statusCode}');
      print(response.body);
    }
  } catch (e) {
    print('Error: $e');
  }
}
