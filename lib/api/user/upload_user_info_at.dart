import 'dart:convert';
import 'package:http/http.dart' as http;


// This function is to upload all user info when signing up

Future<void> uploadUserInfoToAt(
    String? uid,
    String? firstName,
    String? lastName,
    String? email,
    String? phoneNumber,
    String dateCreated,
    String device,
    String version) async {
  final String airtableApiKey =
      'patS6BGUI9SY8OcFJ.fd3c067a6f9874f1847fddf6a21815d8b54dac5ed1b0340dae533856d0c9437a';
  final String airtableApiEndpoint =
      'https://api.airtable.com/v0/appRoQJZBl8WC5KWa/Users';
  final Map<String, dynamic> data = {
    'UID': uid,
    'First Name': firstName,
    'Last Name': lastName,
    // 'username': username,
    'Email': email,
    'Phone Number': phoneNumber,
    'Date Created': dateCreated,
    'Device': device,
    // 'Location': location,
    'Version': version,
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
  } else {
    print('Failed to upload data. Status code: ${response.statusCode}');
    print(response.body);
  }
}

// This function is to update the device field when a user signs in

Future<void> updateUserDeviceInfoToAt(String? uid, String device) async {
  final String airtableApiKey =
      'patS6BGUI9SY8OcFJ.fd3c067a6f9874f1847fddf6a21815d8b54dac5ed1b0340dae533856d0c9437a';
  final String airtableApiEndpoint =
      'https://api.airtable.com/v0/appRoQJZBl8WC5KWa/Users';

  try {
    final Uri uri =
        Uri.parse('$airtableApiEndpoint?filterByFormula=AND({UID}="${uid}")');
    final http.Response queryResponse = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $airtableApiKey',
        'Content-Type': 'application/json',
      },
    );

    if (queryResponse.statusCode == 200) {
      final List<dynamic> records = jsonDecode(queryResponse.body)['records'];

      if (records.isNotEmpty) {
        final String recordId = records[0]['id'];

        final Uri updateUri = Uri.parse('$airtableApiEndpoint/$recordId');
        final Map<String, dynamic> data = {
          'fields': {
            'Device': device,
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
        print('Record with UID $uid not found.');
      }
    } else {
      print('Failed to query data. Status code: ${queryResponse.statusCode}');
      print(queryResponse.body);
    }
  } catch (error) {
    print('Error: $error');
  }
}

// This function uploads login records

Future<void> uploadUserLoginRecordsToAt(String? uid, String? email,
    String? name, String time, String device, String version) async {
  final String airtableApiKey =
      'patS6BGUI9SY8OcFJ.fd3c067a6f9874f1847fddf6a21815d8b54dac5ed1b0340dae533856d0c9437a';
  final String airtableApiEndpoint =
      'https://api.airtable.com/v0/appRoQJZBl8WC5KWa/Login%20Records';
  final Map<String, dynamic> data = {
    'UID': uid,
    'Email': email,
    'Name': name,
    'Time': time,
    'Device': device,
    'Version': version,
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
  } else {
    print('Failed to upload data. Status code: ${response.statusCode}');
    print(response.body);
  }
}
