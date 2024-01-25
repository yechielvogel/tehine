import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tehine/widgets/tiles/event_invitation_tile_widget.dart';

// This function uploads all contacts to airtable

Future<void> uploadEventsToAt(
  String? eventName,
  String? eventDescription,
  String? eventType,
  String eventDate,
  String eventAddress,
  String? eventAddress2,
  String? eventCountry,
  String eventState,
  // String eventMode,
  String eventZipPostalCode,
  String createdByUser,
) async {
  final String airtableApiKey =
      'patS6BGUI9SY8OcFJ.fd3c067a6f9874f1847fddf6a21815d8b54dac5ed1b0340dae533856d0c9437a';
  final String airtableApiEndpoint =
      'https://api.airtable.com/v0/appRoQJZBl8WC5KWa/Invitations';

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
    //   final Map<String, dynamic> responseData = jsonDecode(response.body);
    //   String contactID = responseData['id']; // Access the ID returned by Airtable

    //   // Call the function to save the contact for the user in the "Saved Contacts" table
    //   saveContactToSavedTable(contactID, addedByUser!, listsAsString);
  } else {
    print('Failed to upload data. Status code: ${response.statusCode}');
    print(response.body);
  }
}
