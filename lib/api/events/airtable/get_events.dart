import 'dart:convert';

import 'package:http/http.dart' as http;

/* This function will check if there is any data on device if no will 
will call the next function that will check airtable and if yes will bring all 
the data down 
*/

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/event_model.dart';
import '../../../providers/contact_providers.dart';
import '../../../providers/event_providers.dart';
import '../../../providers/user_providers.dart';
import '../../contacts/airtable/get_contacts.dart';
import '../shared_preferences/save_event_to_shared_preferences.dart';

// Future<void> getAllDataFromAtOnStart(BuildContext context) async {
//   final ref = ProviderScope.containerOf(context);
//   ref.refresh(contactsFromSharedPrefProvider);
//   ref.refresh(eventsFromSharedPrefProvider);
//   print("Line 82 ${ref.read(contactsFromSharedPrefProvider)}");
//   bool isThereAnyDataOnDevice = false;
//   final contacts = ref.read(contactsProvider);
//   final events = ref.read(eventsProvider);
//   if (contacts.isNotEmpty || events.isNotEmpty) {
//     isThereAnyDataOnDevice = true;
//     print('Line 87 there is data on device');
//   }
//   if (!isThereAnyDataOnDevice) {
//     print('Line 90 there is no data on device');
//     // search airtable

//     await loadContactsAndListsFromAT(
//         ref.read(userStreamProvider).value!.uid, context);

//     ref.refresh(contactsFromSharedPrefProvider);
//     //     await loadEventsFromAT(
//     //     ref.read(userStreamProvider).value!.uid, context);

//     // ref.refresh(eventsFromSharedPrefProvider);
//   }
// }

Future<List<EventModel>> loadEventsFromAT(userId, ref) async {
  List<EventModel> events = [];
  // final ref = ProviderScope.containerOf(context);
  final String airtableApiKey =
      'patS6BGUI9SY8OcFJ.fd3c067a6f9874f1847fddf6a21815d8b54dac5ed1b0340dae533856d0c9437a';
  final String airtableApiEndpoint =
      'https://api.airtable.com/v0/appRoQJZBl8WC5KWa/Events';

  try {
    final Uri uri = Uri.parse(
        // need to change this to sent to user or something
        '$airtableApiEndpoint?filterByFormula={Created By User} = "${Uri.encodeComponent(userId!)}"');
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
        List<EventModel> events = [];

        for (var record in responseData['records']) {
          // Use an asynchronous function inside the loop
          EventModel contact = await mapRecordToContact(record);
          events.add(contact);
        }

        // Save all contacts to shared preferences after processing
        saveEventsToSP(events);
        ref.refresh(eventsFromSharedPrefProvider);
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
  return events;
}

// Asynchronous function to map a record to a ContactModel
Future<EventModel> mapRecordToContact(dynamic record) async {
  EventModel event = EventModel.fromJson(record['fields']);

  // Fetch additional details from linked "Contacts" table
  if (record['fields']['Invitations Link'] != null) {
    String invitationLink = record['fields']['Invitations Link'][0];
    final Uri eventUri = Uri.parse(
        'https://api.airtable.com/v0/appRoQJZBl8WC5KWa/Contacts/$invitationLink');

    final http.Response eventResponse = await http.get(
      eventUri,
      headers: {
        'Authorization':
            'Bearer patS6BGUI9SY8OcFJ.fd3c067a6f9874f1847fddf6a21815d8b54dac5ed1b0340dae533856d0c9437a',
        'Content-Type': 'application/json',
      },
    );

    if (eventResponse.statusCode == 200) {
      Map<String, dynamic> eventFields =
          jsonDecode(eventResponse.body)['fields'];
// Might need to add (from Invitations Link) to each one.
      event.eventName = eventFields['Event Name'] ?? '';
      event.eventDescription = eventFields['Event Description'] ?? '';
      event.eventType = eventFields['Event Type'] ?? '';
      event.eventDate = eventFields['Event Date'] ?? '';
      event.eventAddress = eventFields['Address'] ?? '';
      event.eventAddress2 = eventFields['Address 2'] ?? '';
      event.eventCountry = eventFields['Country'] ?? '';
      event.eventState = eventFields['State'] ?? '';
      event.eventZipPostalCode = eventFields['Zip/Postal Code'] ?? '';
      event.invited = eventFields['Invited'] ?? 0;
      event.attending = eventFields['Attending'] ?? 0;
      event.pending = eventFields['Pending'] ?? 0;
      event.notAttending = eventFields['notAttending'] ?? 0;
    } else {
      print(
          'Failed to fetch additional contact details. Status code: ${eventResponse.statusCode}');
      print(eventResponse.body);
    }
  }

  // Extract lists from "Saved Contacts" table

  // This will save the lists to shared preference so we could get all lists

  return event;
}
