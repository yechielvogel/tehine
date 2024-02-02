import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:tehine/providers/event_providers.dart';
import 'package:tehine/widgets/tiles/event_invitation_tile_widget.dart';

import '../../../models/event_model.dart';
import '../shared_preferences/get_event_from_shared_preference.dart';
import '../shared_preferences/save_event_to_shared_preferences.dart';

// This function uploads all events to airtable

/* Need to add that if there is no internet connection then inform the user 
that the event could not be saved because there is no connection
*/

Future<void> uploadEventsToAt(
  ref,
  String eventName,
  String eventDescription,
  String eventType,
  String eventDate,
  String eventAddress,
  String eventAddress2,
  String eventCountry,
  String eventState,
  // String eventMode,
  String eventZipPostalCode,
  String createdByUser,
) async {
  final String airtableApiKey =
      'patS6BGUI9SY8OcFJ.fd3c067a6f9874f1847fddf6a21815d8b54dac5ed1b0340dae533856d0c9437a';
  final String airtableApiEndpoint =
      'https://api.airtable.com/v0/appRoQJZBl8WC5KWa/Events';

  final Map<String, dynamic> data = {
    'Event Name': eventName,
    'Event Description': eventDescription,
    'Event Type': [eventType],
    'Event Date': eventDate,
    'Address': eventAddress,
    'Address 2': eventAddress2,
    'Country': eventCountry,
    'State': eventState,
    // 'Event Mode': eventMode,
    'Zip/Postal Code': eventZipPostalCode,
    'Created By User': createdByUser,
  };

  final Uri uri = Uri.parse(airtableApiEndpoint);
  final http.Response response = await http.post(
    uri,
    headers: {
      'Authorization': 'Bearer $airtableApiKey',
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'fields': data,
    }),
  );

  if (response.statusCode == 200) {
    print('Data uploaded successfully');
    print(response.body);

    // // Step 2: Save the contact for the user in the "Saved Contacts" table
    final Map<String, dynamic> responseData = jsonDecode(response.body);
    String eventID = responseData['id']; // Access the ID returned by Airtable
    print('eventID from airtable ${eventID}');
    // Below saves the event to shared preferences.
    List<EventModel> processedEvents = [];
    List<EventModel>? loadedEvents = await loadEventsFromSP();
    if (loadedEvents != null) {
      processedEvents.addAll(loadedEvents);
    }
    EventModel event = EventModel(
        eventID: eventID,
        eventName: eventName,
        eventDescription: eventDescription,
        eventType: eventType,
        eventDate: eventDate,
        eventAddress: eventAddress,
        eventAddress2: eventAddress2,
        eventZipPostalCode: eventZipPostalCode,
        eventCountry: eventCountry,
        eventState: eventState,
        invited: 0,
        attending: 0,
        pending: 0,
        notAttending: 0
        // eventMode: true,
        );
    processedEvents.add(event);
    saveEventsToSP(processedEvents);

    //   // Call the function to save the contact for the user in the "Saved Contacts" table
    //   saveContactToSavedTable(contactID, addedByUser!, listsAsString);
  } else {
    print('Failed to upload data. Status code: ${response.statusCode}');
    print(response.body);
  }
}

// This function updates a event lists in AirTable

Future<void> updateEventListsToAt(
  String? eventID,
  List? lists,
) async {
  final String airtableApiKey =
      'patS6BGUI9SY8OcFJ.fd3c067a6f9874f1847fddf6a21815d8b54dac5ed1b0340dae533856d0c9437a';
  final String airtableApiEndpoint =
      'https://api.airtable.com/v0/appRoQJZBl8WC5KWa/Events';
  String listsAsString = lists!.join(', ');
  // print('List to upload ${listsAsString}');
  // print('event ID $eventID');
  try {
    final Uri updateUri = Uri.parse('$airtableApiEndpoint/$eventID');
    final Map<String, dynamic> data = {
      'fields': {
        'Lists': listsAsString,
      },
    };

    final http.Response updateResponse = await http.patch(
      updateUri,
      headers: {
        'Authorization': 'Bearer $airtableApiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );

    if (updateResponse.statusCode == 200) {
      print('Data updated successfully');
      print(updateResponse.body);
    } else {
      print('Failed to update data. Status code: ${updateResponse.statusCode}');
      print(updateResponse.body);
    }
  } catch (error) {
    print('Error: $error');
  }
}

// Edit a Event

Future<void> updateEventToAt(
  String? eventID,
  String? uid,
  String? eventName,
  String? eventDescription,
  String? eventType,
  String? eventDate,
  String? eventAddress,
  String? eventAddress2,
  String? eventCountry,
  String? eventState,
  String? eventZipPostalCode,
) async {
  final String airtableApiKey =
      'patS6BGUI9SY8OcFJ.fd3c067a6f9874f1847fddf6a21815d8b54dac5ed1b0340dae533856d0c9437a';
  final String airtableApiEndpoint =
      'https://api.airtable.com/v0/appRoQJZBl8WC5KWa/Events';

  try {
    final Uri updateUri = Uri.parse('$airtableApiEndpoint/$eventID');
    final Map<String, dynamic> data = {
      'fields': {
        'Event Name': eventName,
        'Event Description': eventDescription,
        'Event Type': [eventType],
        'Event Date': eventDate,
        'Address': eventAddress,
        'Address 2': eventAddress2,
        'Country': eventCountry,
        'State': eventState,
        'Zip/Postal Code': eventZipPostalCode,
      },
    };

    final http.Response updateResponse = await http.patch(
      updateUri,
      headers: {
        'Authorization': 'Bearer $airtableApiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );

    if (updateResponse.statusCode == 200) {
      print('Data updated successfully');
      print(updateResponse.body);
    } else {
      print('Failed to update data. Status code: ${updateResponse.statusCode}');
      print(updateResponse.body);
    }
  } catch (error) {
    print('Error: $error');
  }
}

// Update a Attachment to event

Future<void> updateEventAttachmentToAt(
  String? eventID,
  String attachment,
) async {
  final String airtableApiKey =
      'patS6BGUI9SY8OcFJ.fd3c067a6f9874f1847fddf6a21815d8b54dac5ed1b0340dae533856d0c9437a';
  final String airtableApiEndpoint =
      'https://api.airtable.com/v0/appRoQJZBl8WC5KWa/Events';

  try {
    final Uri updateUri = Uri.parse('$airtableApiEndpoint/$eventID');
    final Map<String, dynamic> data = {
      'fields': {
        'Attachment': attachment,
      },
    };

    final http.Response updateResponse = await http.patch(
      updateUri,
      headers: {
        'Authorization': 'Bearer $airtableApiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );

    if (updateResponse.statusCode == 200) {
      print('Data updated successfully');
      print(updateResponse.body);
    } else {
      print('Failed to update data. Status code: ${updateResponse.statusCode}');
      print(updateResponse.body);
    }
  } catch (error) {
    print('Error: $error');
  }
}

// Delete a event from airtable

Future<void> deleteEventFromUserAccountToAt(
  String? eventID,
) async {
  final String airtableApiKey =
      'patS6BGUI9SY8OcFJ.fd3c067a6f9874f1847fddf6a21815d8b54dac5ed1b0340dae533856d0c9437a';
  final String airtableApiEndpoint =
      'https://api.airtable.com/v0/appRoQJZBl8WC5KWa/Events';
  print(eventID);
  try {
    final Uri updateUri = Uri.parse('$airtableApiEndpoint/$eventID');
    final http.Response deleteResponse = await http.delete(
      updateUri,
      headers: {
        'Authorization': 'Bearer $airtableApiKey',
      },
    );

    if (deleteResponse.statusCode == 200) {
      print('Data deleted successfully');
      print(deleteResponse.body);
    } else {
      print('Failed to delete data. Status code: ${deleteResponse.statusCode}');
      print(deleteResponse.body);
    }
  } catch (error) {
    print('Error: $error');
  }
}
