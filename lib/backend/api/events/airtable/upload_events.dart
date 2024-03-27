import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:tehine/providers/event_providers.dart';
import 'package:tehine/widgets/tiles/event_invitation_tile_widget.dart';

import '../../../../models/event_model.dart';
import '../shared_preferences/get_event_from_shared_preference.dart';
import '../shared_preferences/save_event_to_shared_preferences.dart';
import 'get_events.dart';

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
    String eventRecordID =
        responseData['id']; // Access the ID returned by Airtable
    print('eventRecordID from airtable ${eventRecordID}');
    // Below saves the event to shared preferences.
    List<EventModel> processedEvents = [];
    List<EventModel>? loadedEvents = await loadEventsFromSP();
    if (loadedEvents != null) {
      processedEvents.addAll(loadedEvents);
    }
    EventModel event = EventModel(
        eventRecordID: eventRecordID,
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
    // this will make a webhook for the event
    attendingWebhook(eventRecordID);
    saveEventsToSP(processedEvents);

    //   // Call the function to save the contact for the user in the "Saved Contacts" table
    //   saveContactToSavedTable(contactRecordID, addedByUser!, listsAsString);
  } else {
    print('Failed to upload data. Status code: ${response.statusCode}');
    print(response.body);
  }
}

// This function updates a event lists in AirTable

Future<void> updateEventListsToAt(
  String? eventRecordID,
  List? lists,
) async {
  final String airtableApiKey =
      'patS6BGUI9SY8OcFJ.fd3c067a6f9874f1847fddf6a21815d8b54dac5ed1b0340dae533856d0c9437a';
  final String airtableApiEndpoint =
      'https://api.airtable.com/v0/appRoQJZBl8WC5KWa/Events';
  String listsAsString = lists!.join(', ');
  // print('List to upload ${listsAsString}');
  // print('event ID $eventRecordID');
  try {
    final Uri updateUri = Uri.parse('$airtableApiEndpoint/$eventRecordID');
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
  String? eventRecordID,
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
    final Uri updateUri = Uri.parse('$airtableApiEndpoint/$eventRecordID');
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
  String? eventRecordID,
  String attachment,
) async {
  final String airtableApiKey =
      'patS6BGUI9SY8OcFJ.fd3c067a6f9874f1847fddf6a21815d8b54dac5ed1b0340dae533856d0c9437a';
  final String airtableApiEndpoint =
      'https://api.airtable.com/v0/appRoQJZBl8WC5KWa/Events';

  try {
    final Uri updateUri = Uri.parse('$airtableApiEndpoint/$eventRecordID');
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
  String? eventRecordID,
) async {
  final String airtableApiKey =
      'patS6BGUI9SY8OcFJ.fd3c067a6f9874f1847fddf6a21815d8b54dac5ed1b0340dae533856d0c9437a';
  final String airtableApiEndpoint =
      'https://api.airtable.com/v0/appRoQJZBl8WC5KWa/Events';
  print(eventRecordID);
  try {
    final Uri updateUri = Uri.parse('$airtableApiEndpoint/$eventRecordID');
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

/*
This is for inviting someone who is on the app 
*/


Future<void> inviteTehineUserToEventToAt(
  String? eventRecordID,
  List<String> userRecordIds, // Ensure userRecordIds is a List of Strings
) async {
  final String airtableApiKey =
      'patS6BGUI9SY8OcFJ.fd3c067a6f9874f1847fddf6a21815d8b54dac5ed1b0340dae533856d0c9437a';
  final String airtableApiEndpoint =
      'https://api.airtable.com/v0/appRoQJZBl8WC5KWa/Events/$eventRecordID';

  // Fetch the current list of invited user IDs from the Airtable API
  final http.Response currentResponse = await http.get(
    Uri.parse(airtableApiEndpoint),
    headers: {
      'Authorization': 'Bearer $airtableApiKey',
    },
  );

  if (currentResponse.statusCode == 200) {
    // Parse the current response body to extract the existing invited user IDs
    final Map<String, dynamic> currentData = jsonDecode(currentResponse.body);
    List<dynamic> currentInvited = currentData['fields']['Invited'] ?? [];

    // Append the new user IDs to the existing list
    currentInvited.addAll(userRecordIds);

    // Filter out empty strings from the list
    currentInvited = currentInvited.where((id) => id.isNotEmpty).toList();

    print('Inviting $userRecordIds');
    print('All record IDs $currentInvited');
    
    // Prepare the request data with the updated list of invited user IDs
    final Map<String, dynamic> requestData = {
      'fields': {
        'Invited': currentInvited,
      },
    };

    // Update the "Invited" field with the updated list of invited user IDs
    final http.Response response = await http.patch(
      Uri.parse(airtableApiEndpoint),
      headers: {
        'Authorization': 'Bearer $airtableApiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(requestData),
    );

    if (response.statusCode == 200) {
      print('Invitation sent successfully.');
      print(response.body);
    } else {
      print('Failed to send invitation.');
      print(response.body);
    }
  } else {
    print('Failed to fetch current data from Airtable.');
    print(currentResponse.body);
  }
}

// Accept a invitation

Future<void> acceptInvitationToAt(
    String? eventRecordID, String? userRecordID) async {
  final String airtableApiKey =
      'patS6BGUI9SY8OcFJ.fd3c067a6f9874f1847fddf6a21815d8b54dac5ed1b0340dae533856d0c9437a';
  final String airtableApiEndpoint =
      'https://api.airtable.com/v0/appRoQJZBl8WC5KWa/Events';

  try {
    final Uri getUri = Uri.parse('$airtableApiEndpoint/$eventRecordID');
    final http.Response getResponse = await http.get(
      getUri,
      headers: {'Authorization': 'Bearer $airtableApiKey'},
    );

    if (getResponse.statusCode == 200) {
      final Map<String, dynamic> eventData = jsonDecode(getResponse.body);
      List<dynamic>? currentAttendees = eventData['fields']['Attending'];
      if (currentAttendees == null) {
        currentAttendees = [];
      }

      if (!currentAttendees.contains(userRecordID)) {
        currentAttendees.add(userRecordID);
      }

      final Uri updateUri = Uri.parse('$airtableApiEndpoint/$eventRecordID');
      final Map<String, dynamic> data = {
        'fields': {
          'Attending': currentAttendees,
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
        print(
            'Failed to update data. Status code: ${updateResponse.statusCode}');
        print(updateResponse.body);
      }
    } else {
      print(
          'Failed to fetch event data. Status code: ${getResponse.statusCode}');
      print(getResponse.body);
    }
  } catch (error) {
    print('Error: $error');
  }
}

// Unaccepted a invitation

Future<void> unAcceptInvitationToAt(
    String? eventRecordID, String? userRecordID) async {
  final String airtableApiKey =
      'patS6BGUI9SY8OcFJ.fd3c067a6f9874f1847fddf6a21815d8b54dac5ed1b0340dae533856d0c9437a';
  final String airtableApiEndpoint =
      'https://api.airtable.com/v0/appRoQJZBl8WC5KWa/Events';

  try {
    final Uri getUri = Uri.parse('$airtableApiEndpoint/$eventRecordID');
    final http.Response getResponse = await http.get(
      getUri,
      headers: {'Authorization': 'Bearer $airtableApiKey'},
    );

    if (getResponse.statusCode == 200) {
      final Map<String, dynamic> eventData = jsonDecode(getResponse.body);
      List<dynamic>? currentAttendees = eventData['fields']['Attending'];
      if (currentAttendees == null) {
        currentAttendees = [];
      }

      currentAttendees.remove(userRecordID);

      final Uri updateUri = Uri.parse('$airtableApiEndpoint/$eventRecordID');
      final Map<String, dynamic> data = {
        'fields': {
          'Attending': currentAttendees,
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
        print('User removed from attending list successfully');
        print(updateResponse.body);
      } else {
        print(
            'Failed to remove user from attending list. Status code: ${updateResponse.statusCode}');
        print(updateResponse.body);
      }
    } else {
      print(
          'Failed to fetch event data. Status code: ${getResponse.statusCode}');
      print(getResponse.body);
    }
  } catch (error) {
    print('Error: $error');
  }
}

// Decline a invitation

Future<void> declineInvitationToAt(
    String? eventRecordID, String? userRecordID) async {
  final String airtableApiKey =
      'patS6BGUI9SY8OcFJ.fd3c067a6f9874f1847fddf6a21815d8b54dac5ed1b0340dae533856d0c9437a';
  final String airtableApiEndpoint =
      'https://api.airtable.com/v0/appRoQJZBl8WC5KWa/Events';

  try {
    final Uri getUri = Uri.parse('$airtableApiEndpoint/$eventRecordID');
    final http.Response getResponse = await http.get(
      getUri,
      headers: {'Authorization': 'Bearer $airtableApiKey'},
    );

    if (getResponse.statusCode == 200) {
      final Map<String, dynamic> eventData = jsonDecode(getResponse.body);
      List<dynamic>? currentAttendees = eventData['fields']['Not Attending'];
      if (currentAttendees == null) {
        currentAttendees = [];
      }

      if (!currentAttendees.contains(userRecordID)) {
        currentAttendees.add(userRecordID);
      }

      final Uri updateUri = Uri.parse('$airtableApiEndpoint/$eventRecordID');
      final Map<String, dynamic> data = {
        'fields': {
          'Not Attending': currentAttendees,
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
        print(
            'Failed to update data. Status code: ${updateResponse.statusCode}');
        print(updateResponse.body);
      }
    } else {
      print(
          'Failed to fetch event data. Status code: ${getResponse.statusCode}');
      print(getResponse.body);
    }
  } catch (error) {
    print('Error: $error');
  }
}

// Un decline a invitation

Future<void> unDeclineInvitationToAt(
    String? eventRecordID, String? userRecordID) async {
  final String airtableApiKey =
      'patS6BGUI9SY8OcFJ.fd3c067a6f9874f1847fddf6a21815d8b54dac5ed1b0340dae533856d0c9437a';
  final String airtableApiEndpoint =
      'https://api.airtable.com/v0/appRoQJZBl8WC5KWa/Events';

  try {
    final Uri getUri = Uri.parse('$airtableApiEndpoint/$eventRecordID');
    final http.Response getResponse = await http.get(
      getUri,
      headers: {'Authorization': 'Bearer $airtableApiKey'},
    );

    if (getResponse.statusCode == 200) {
      final Map<String, dynamic> eventData = jsonDecode(getResponse.body);
      List<dynamic>? currentAttendees = eventData['fields']['Not Attending'];
      if (currentAttendees == null) {
        currentAttendees = [];
      }

      currentAttendees.remove(userRecordID);

      final Uri updateUri = Uri.parse('$airtableApiEndpoint/$eventRecordID');
      final Map<String, dynamic> data = {
        'fields': {
          'Not Attending': currentAttendees,
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
        print('User removed from attending list successfully');
        print(updateResponse.body);
      } else {
        print(
            'Failed to remove user from attending list. Status code: ${updateResponse.statusCode}');
        print(updateResponse.body);
      }
    } else {
      print(
          'Failed to fetch event data. Status code: ${getResponse.statusCode}');
      print(getResponse.body);
    }
  } catch (error) {
    print('Error: $error');
  }
}
