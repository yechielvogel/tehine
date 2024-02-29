import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../../../models/event_model.dart';

import '../../../../providers/event_providers.dart';

import '../../../../providers/general_providers.dart';
import '../../../../providers/invitations_providers.dart';
import '../../../../providers/user_providers.dart';
import '../shared_preferences/save_event_to_shared_preferences.dart';

/* This function will check if there is any data on device if no will 
will call the next function that will check airtable and if yes will bring all 
the data down 
*/   

Future<void> getAllEventsDataFromAtOnStart(BuildContext context) async {
  final ref = ProviderScope.containerOf(context);    
  ref.refresh(eventsFromSharedPrefProvider);   
  bool isThereAnyDataOnDevice = false;
  final events = ref.read(eventsProvider);
  if (events.isNotEmpty) {
    isThereAnyDataOnDevice = true;
  }
  if (!isThereAnyDataOnDevice) {
    
    // search airtable
    try {
      // should put this back when finished making invitations
      // await loadEventsFromAT(ref.read(userStreamProvider).value!.uid, context);

      await loadEventsFromAT(ref.read(userStreamProvider).value!.uid, context);

      // Check if the widget is mounted before updating the state
      if (context != null && context.findRenderObject() != null) {
        ref.refresh(eventsFromSharedPrefProvider);
      }
    } catch (e) {
      // Handle any errors during the asynchronous operations
      print('Error during data loading: $e');
    }
  }
}

// Get events

Future<List<EventModel>> loadEventsFromAT(userFirebaseID, ref) async {
  final String airtableApiKey =
      'patS6BGUI9SY8OcFJ.fd3c067a6f9874f1847fddf6a21815d8b54dac5ed1b0340dae533856d0c9437a';
  final String airtableApiEndpoint =
      'https://api.airtable.com/v0/appRoQJZBl8WC5KWa/Events';

  List<EventModel> events = [];

  try {
    final Uri uri = Uri.parse(
        '$airtableApiEndpoint?filterByFormula={Created By User} = "${Uri.encodeComponent(userFirebaseID!)}"');
    final http.Response response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $airtableApiKey',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      // Parse JSON response
      final Map<String, dynamic> eventData = json.decode(response.body);
      final List<dynamic> records = eventData['records'];
      for (final record in records) {
        final Map<String, dynamic> fields = record['fields'];
        final eventType = fields['Event Type'];
        String eventTypeString = '';
        if (eventType is List<dynamic>) {
          eventTypeString = eventType.join(', ');
        } else if (eventType != null) {
          eventTypeString = eventType.toString();
        }

        String listsString = record['fields']['Lists'] ?? '';
        List<String> splitList = listsString
            .split(',')
            .map((item) => item.trim())
            .where((item) => item.isNotEmpty)
            .toList();
        final EventModel event = EventModel(
          eventRecordID: record['id'],
          eventName: fields['Event Name'] ?? '',
          eventDescription: fields['Event Description'] ?? '',
          eventType: eventTypeString,
          eventDate: fields['Event Date'] ?? '',
          eventAddress: fields['Address'] ?? '',
          eventAddress2: fields['Address2'] ?? '',
          eventCountry: fields['Country'] ?? '',
          eventState: fields['State'] ?? '',
          eventZipPostalCode: fields['Zip/Postal Code'] ?? '',
          attachment: fields['Attachment'] ?? '',
          lists: splitList,
        );
        events.add(event);
      }

      ref.read(eventsProvider.notifier).state = events;
      // saveEventsToSP(events);
    } else {
      print('Failed to fetch data. Status code: ${response.statusCode}');
      print(response.body);
    }

    saveEventsToSP(events);
    ref.refresh(eventsFromSharedPrefProvider);
  } catch (e) {
    print('Error: $e');
  }
  return events;
}

// this gets attending info for events

Future<List<EventModel>> loadEventAttendingFromAT(
    userRecordID, List<String> eventRecordIds, ref) async {
  List<EventModel> events = [];

  try {
    final List<EventModel> events = [];
    final String airtableApiKey =
        'patS6BGUI9SY8OcFJ.fd3c067a6f9874f1847fddf6a21815d8b54dac5ed1b0340dae533856d0c9437a';
    final String airtableApiEndpoint =
        'https://api.airtable.com/v0/appRoQJZBl8WC5KWa/Events';

    for (String eventId in eventRecordIds) {
      // Construct URL to fetch event data for a specific event ID
      final String eventUrl = '$airtableApiEndpoint/$eventId';

      // Make API request to fetch event data
      final response = await http.get(Uri.parse(eventUrl), headers: {
        'Authorization': 'Bearer $airtableApiKey',
      });

      if (response.statusCode == 200) {
        // Parse JSON response
        final Map<String, dynamic> eventData = json.decode(response.body);
        final Map<String, dynamic> fields = eventData['fields'];

        // Get invited number
        int invitedInt = 0;
        var invitedField = fields['Invited'];
        if (invitedField != null) {
          if (invitedField is List<dynamic>?) {
            invitedInt = invitedField!.length;
          } else if (invitedField.runtimeType == String) {
            invitedInt = 1;
          }
        }

        // Get attending number
        int attendingInt = 0;
        var attendingField = fields['Attending'];
        if (attendingField != null) {
          if (attendingField is List<dynamic>?) {
            attendingInt = attendingField!.length;
          } else if (attendingField.runtimeType == String) {
            attendingInt = 1;
          }
        }

        // Get notAttending number
        int notAttendingInt = 0;
        var notAttendingField = fields['Not Attending'];
        if (notAttendingField != null) {
          if (notAttendingField is List<dynamic>?) {
            notAttendingInt = notAttendingField!.length;
          } else if (notAttendingField.runtimeType == String) {
            notAttendingInt = 1;
          }
        }

        // Sort pending

        int pendingInt = invitedInt - attendingInt - notAttendingInt;

// Get invited names
        List invitedList = [];

        List invitedListFirstName = [];
        var invitedListFirstNameField = fields['First Name (from Invited)'];
        if (invitedListFirstNameField != null) {
          if (invitedListFirstNameField is List<dynamic>?) {
            invitedListFirstName
                .addAll(invitedListFirstNameField!.map((name) => name.trim()));
          } else if (invitedListFirstNameField.runtimeType == String) {
            invitedListFirstName.add(invitedListFirstNameField.trim());
          }
        }
        List invitedListLastName = [];
        var invitedListLastNameField = fields['Last Name (from Invited)'];
        if (invitedListLastNameField != null) {
          if (invitedListLastNameField is List<dynamic>?) {
            invitedListLastName
                .addAll(invitedListLastNameField!.map((name) => name.trim()));
          } else if (invitedListLastNameField.runtimeType == String) {
            invitedListLastName.add(invitedListLastNameField.trim());
          }
        }

        for (int i = 0; i < invitedListFirstName.length; i++) {
          String fullName =
              '${invitedListFirstName[i]} ${invitedListLastName[i]}';
          invitedList.add(fullName.trim());
        }

        // get attending names

        List attendingList = [];

        List attendingListFirstName = [];
        var attendingListFirstNameField = fields['First Name (from Attending)'];
        if (attendingListFirstNameField != null) {
          if (attendingListFirstNameField is List<dynamic>?) {
            attendingListFirstName.addAll(
                attendingListFirstNameField!.map((name) => name.trim()));
          } else if (attendingListFirstNameField.runtimeType == String) {
            attendingListFirstName.add(attendingListFirstNameField.trim());
          }
        }
        List attendingListLastName = [];
        var attendingListLastNameField = fields['Last Name (from Attending)'];
        if (attendingListLastNameField != null) {
          if (attendingListLastNameField is List<dynamic>?) {
            attendingListLastName
                .addAll(attendingListLastNameField!.map((name) => name.trim()));
          } else if (attendingListLastNameField.runtimeType == String) {
            attendingListLastName.add(attendingListLastNameField.trim());
          }
        }

        for (int i = 0; i < attendingListFirstName.length; i++) {
          String fullName =
              '${attendingListFirstName[i]} ${attendingListLastName[i]}';
          attendingList.add(fullName.trim());
        }

// get not attending names

        List notAttendingList = [];

        List notAttendingListFirstName = [];
        var notAttendingListFirstNameField =
            fields['First Name (from Not Attending)'];
        if (notAttendingListFirstNameField != null) {
          if (notAttendingListFirstNameField is List<dynamic>?) {
            notAttendingListFirstName.addAll(
                notAttendingListFirstNameField!.map((name) => name.trim()));
          } else if (notAttendingListFirstNameField.runtimeType == String) {
            notAttendingListFirstName
                .add(notAttendingListFirstNameField.trim());
          }
        }
        List notAttendingListLastName = [];
        var notAttendingListLastNameField =
            fields['Last Name (from Not Attending)'];
        if (notAttendingListLastNameField != null) {
          if (notAttendingListLastNameField is List<dynamic>?) {
            notAttendingListLastName.addAll(
                notAttendingListLastNameField!.map((name) => name.trim()));
          } else if (notAttendingListLastNameField.runtimeType == String) {
            notAttendingListLastName.add(notAttendingListLastNameField.trim());
          }
        }

        for (int i = 0; i < notAttendingListFirstName.length; i++) {
          String fullName =
              '${notAttendingListFirstName[i]} ${notAttendingListLastName[i]}';
          notAttendingList.add(fullName.trim());
        }
// get pending names

        List<String> pendingList = [];

        for (String name in invitedList) {
          if (!attendingList.contains(name) &&
              !notAttendingList.contains(name)) {
            pendingList.add(name);
          }
        }


        final EventModel event = EventModel(   
          eventRecordID: eventData['id'],
          eventName: fields['Event Name'] ?? '',
          eventDescription: fields['Event Description'] ?? '',
          eventType: '',
          eventDate: fields['Event Date'] ?? '',
          eventAddress: fields['Address'] ?? '',
          eventAddress2: fields['Address2'] ?? '',
          eventCountry: fields['Country'] ?? '',
          eventState: fields['State'] ?? '',
          eventZipPostalCode: fields['Zip/Postal Code'] ?? '',
          attachment: fields['Attachment'] ?? '',
          invitedList: invitedList,
          attendingList: attendingList,
          pendingList: pendingList,
          notAttendingList: notAttendingList,
          invited: invitedInt,
          attending: attendingInt,
          pending: pendingInt,
          notAttending: notAttendingInt,
          lists: [],
        );
// First Name (from Attending)

// List? invitedList,
//     List? attendingList,
//     List? pendingList,
//     List? notAttendingList,
//     int? invited,
//     int? attending,
//     int? pending,
//     int? notAttending,

        events.add(event);
        updateEventAttendingDetailInSP(
            eventId,
            invitedList,
            attendingList,
            pendingList,
            notAttendingList,
            invitedInt,
            attendingInt,
            pendingInt,
            notAttendingInt);

        // saveEventsToSP(events);
      } else {
        // Handle error if request was not successful
        print('Failed to fetch event with ID: $eventId');
      }
    }
  } catch (e) {
    return events;

    // Handle error
  }
  return events;
}

// This gets invitations record ids

Future<List<String>> loadInvitationsFromAT(ref, String? userRecordID) async {
  List<String> eventInvitations = [];

  final String airtableApiKey =
      'patS6BGUI9SY8OcFJ.fd3c067a6f9874f1847fddf6a21815d8b54dac5ed1b0340dae533856d0c9437a';

  // Construct the Airtable API endpoint using the userRecordID
  String airtableApiEndpoint =
      'https://api.airtable.com/v0/appRoQJZBl8WC5KWa/Users/$userRecordID';

  try {
    final Uri uri = Uri.parse('$airtableApiEndpoint');

    final http.Response response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $airtableApiKey',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      // Process the user record data
      if (responseData.containsKey('fields') &&
          responseData['fields'] != null) {
        var fields = responseData['fields'];

        if (fields.containsKey('Event Record ID (from Invitations)') &&
            fields['Event Record ID (from Invitations)'] != null) {
          var eventRecordIdField = fields['Event Record ID (from Invitations)'];

          if (eventRecordIdField is List<dynamic>?) {
            eventInvitations
                .addAll(eventRecordIdField!.map((item) => item.toString()));
          } else if (eventRecordIdField.runtimeType == String) {
            eventInvitations.add(eventRecordIdField);
          }
        }
      }

      await getInvitationsData(ref, eventInvitations, userRecordID);
    } else {
      print('Failed to fetch data. Status code: ${response.statusCode}');
      print(response.body);
    }
  } catch (e) {
    print('Error:: $e');
  }

  return eventInvitations;
}

// get invitations data

Future<void> getInvitationsData(
    ref, List<String> eventInvitationIds, userRecordID) async {
  bool? didAccept;

  try {
    final List<EventModel> events = [];
    final String airtableApiKey =
        'patS6BGUI9SY8OcFJ.fd3c067a6f9874f1847fddf6a21815d8b54dac5ed1b0340dae533856d0c9437a';
    final String airtableApiEndpoint =
        'https://api.airtable.com/v0/appRoQJZBl8WC5KWa/Events';

    for (String eventId in eventInvitationIds) {
      // Construct URL to fetch event data for a specific event ID
      final String eventUrl = '$airtableApiEndpoint/$eventId';

      // Make API request to fetch event data
      final response = await http.get(Uri.parse(eventUrl), headers: {
        'Authorization': 'Bearer $airtableApiKey',
      });

      // Check if the request was successful
      if (response.statusCode == 200) {
        // Parse JSON response
        final Map<String, dynamic> eventData = json.decode(response.body);

// this gets all not attending
        var notAttending =
            eventData['fields']['User Record ID (from Not Attending)'];
        if (notAttending != null) {
          if (notAttending is List<dynamic>?) {
            if (notAttending!.contains(userRecordID)) {
              didAccept = false;
            }
          } else {
            if (notAttending.toString() == userRecordID) {
              didAccept = false;
            }
          }
        }

// this gets all attending and search if user is in there

        var currentAttendees =
            eventData['fields']['User Record ID (from Attending)'];
        if (currentAttendees != null) {
          if (currentAttendees is List<dynamic>?) {
            if (currentAttendees!.contains(userRecordID)) {
              didAccept = true;
            }
          } else {
            if (currentAttendees.toString() == userRecordID) {
              didAccept = true;
            }
          }
        }

        // Extract event fields
        final String? eventName = eventData['fields']['Event Name'];
        final String? eventDescription =
            eventData['fields']['Event Description'];
        final List<dynamic> eventType = eventData['fields']['Event Type'];
        final String? eventDate = eventData['fields']['Event Date'];
        final String? eventAddress = eventData['fields']['Address'];
        final String? eventAddress2 = eventData['fields']['Address2'];
        final String? eventCountry = eventData['fields']['Country'];
        final String? eventState = eventData['fields']['State'];
        final String? eventZipPostalCode =
            eventData['fields']['Zip/Postal Code'];
        final List<String>? lists = eventData['fields']['lists'];
        final String eventTypeString = eventType.join(', ');

        // Create EventModel instance and add it to the events list
        final EventModel event = EventModel(
          eventRecordID: eventId,
          eventName: eventName ?? '',
          eventDescription: eventDescription ?? '',
          eventType: eventTypeString,

          // eventType: eventType.toString(),
          eventDate: eventDate ?? '',
          eventAddress: eventAddress ?? '',
          eventAddress2: eventAddress2 ?? '',
          eventCountry: eventCountry ?? '',
          eventState: eventState ?? '',
          eventZipPostalCode: eventZipPostalCode ?? '',
          lists: lists,
          didAccept: didAccept,
        );
        events.add(event);
        String eventIDForProvider =
            '${eventId.toString()}${ref.watch(userRecordIDProvider)}';
        ref.read(attendingChipProvider(eventIDForProvider).notifier).state =
            didAccept == null ? null : (didAccept == true ? 0 : 1);
        didAccept = null;
        // saveEventsToSP(events);
      } else {
        // Handle error if request was not successful
        print('Failed to fetch event with ID: $eventId');
      }
    }
    ref.read(invitationsProvider.notifier).state = events;
    // ref.watch(filteredInvitationsProvider.notifier).state = events;
    // Do something with the populated events list
    // For example, you could pass it to another function or store it in a database
    // print('Fetched ${events.length} events.');
  } catch (e) {
    print('Error fetching events: $e');
    // Handle error
  }
}

/* 
This is a webhook for the events to see whose coming.
Maybe this should be moved to a different file.
*/

void attendingWebhook(String eventRecordID) async {
  final String baseId = 'appRoQJZBl8WC5KWa';
  final String apiKey =
      'patS6BGUI9SY8OcFJ.fd3c067a6f9874f1847fddf6a21815d8b54dac5ed1b0340dae533856d0c9437a';
  final String apiUrl = 'https://api.airtable.com/v0/bases/$baseId/webhooks';

  final Map<String, dynamic> data = {
    "notificationUrl":
        "https://us-central1-tehine-d69bf.cloudfunctions.net/webhook",
    "specification": {
      //     "options": {
      //       "filters": {
      //         "dataTypes": ["tableData"],
      //         "recordChangeScope":
      //             "tbl3yfkrkynV3hw2d" // Adjust this to your table ID
      //       }
      //     }
      //   }
      // };

      "options": {
        "filters": {
          "fromSources": ["client"],
          "dataTypes": ["tableData"],
          // "recordChangeScope": eventRecordID,
          "recordChangeScope": "tbl3yfkrkynV3hw2d",
          "watchDataInFieldIds": [
            "fldWsm3hG3EyhCZe9",
          ]
        }
      }
    }
  };

  final response = await http.post(
    Uri.parse(apiUrl),
    headers: {
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/json',
    },
    body: jsonEncode(data),
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> responseData = jsonDecode(response.body);
    final String webhookId = responseData[
        'id']; // Assuming Airtable API provides the ID upon creation
    print('Webhook created successfully with ID: $webhookId');

    // Save the webhook ID in your database for future reference
    // Example: saveWebhookId(eventRecordID, webhookId);
  } else {
    print('Failed to create webhook: ${response.statusCode}');
    print('Response body: ${response.body}');
  }
}

// test

// List all webhooks

void listWebhooks() async {
  final String baseId = 'appRoQJZBl8WC5KWa';
  final String apiKey =
      'patS6BGUI9SY8OcFJ.fd3c067a6f9874f1847fddf6a21815d8b54dac5ed1b0340dae533856d0c9437a';
  final String apiUrl = 'https://api.airtable.com/v0/bases/$baseId/webhooks';

  final response = await http.get(
    Uri.parse(apiUrl),
    headers: {
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    final dynamic responseData = jsonDecode(response.body);
    // print('response data ${responseData}');
    if (responseData['records'] != null) {
      final List<dynamic> webhooks = responseData['records'];
      for (var webhook in webhooks) {
        final String webhookId = webhook['id'];
        final String url = webhook[
            'notificationUrl']; // or any other information you want to display
        print('Webhook ID: $webhookId, URL: $url');
      }
    } else {
      print('No webhooks found for this base.');
    }
  } else {
    print('Failed to list webhooks: ${response.statusCode}');
    print('Response body: ${response.body}');
  }
}

// delete a webhook

void deleteWebhook(String webhookId) async {
  final String baseId = 'appRoQJZBl8WC5KWa';
  final String apiKey =
      'patS6BGUI9SY8OcFJ.fd3c067a6f9874f1847fddf6a21815d8b54dac5ed1b0340dae533856d0c9437a';
  final String apiUrl =
      'https://api.airtable.com/v0/bases/$baseId/webhooks/$webhookId';

  final response = await http.delete(
    Uri.parse(apiUrl),
    headers: {
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    print('Webhook deleted successfully');
  } else {
    print('Failed to delete webhook: ${response.statusCode}');
    print('Response body: ${response.body}');
  }
}
