import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../../../models/users_model.dart';
import '../shared_preferences/get_user_from_shared_preferences.dart';
import '../shared_preferences/save_user_to_shared_preferences.dart';

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
    'Firebase UID': uid,
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
    final Map<String, dynamic> responseData = jsonDecode(response.body);
    String id = responseData['id']; // Access the ID returned by Airtable
    Users user = Users();
    user.uid = uid;
    user.userRecordID = id;
    user.firstName = firstName;
    user.lastName = lastName;
    user.email = email;
    user.phoneNumber = phoneNumber;
    saveUserToSP(user);
    Users? userInfo = await loadUserFromSP();

    await createUserContactToAt(
        userInfo?.userRecordID,
        userInfo?.uid,
        userInfo?.firstName,
        userInfo?.lastName,
        userInfo?.email,
        userInfo?.phoneNumber);
  } else {
    print('Failed to upload data. Status code: ${response.statusCode}');
    print(response.body);
  }
}

// This function is to create a contact for the user who just registered

Future<void> createUserContactToAt(
  String? userRecordID,
  String? uid,
  String? firstName,
  String? lastName,
  String? email,
  String? phoneNumber,
) async {
  final String airtableApiKey =
      'patS6BGUI9SY8OcFJ.fd3c067a6f9874f1847fddf6a21815d8b54dac5ed1b0340dae533856d0c9437a';
  final String airtableApiEndpoint =
      'https://api.airtable.com/v0/appRoQJZBl8WC5KWa/Contacts';
  final Map<String, dynamic> data = {
    // 'UID': uid,
    'First Name': firstName,
    'Last Name': lastName,
    // 'username': username,
    'Phone Number': phoneNumber,
    'Email': email,
    'Added By User': uid,
    'Users Link': [userRecordID],
    'Status': ['On App'],

    // 'Location': location,
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

Future<void> updateUserDeviceInfoToAt(
  String? uid,
  // String? firstName,
  // String? lastName,
  // String? email,
  // String? phoneNumber,
  String device,
) async {
  final String airtableApiKey =
      'patS6BGUI9SY8OcFJ.fd3c067a6f9874f1847fddf6a21815d8b54dac5ed1b0340dae533856d0c9437a';
  final String airtableApiEndpoint =
      'https://api.airtable.com/v0/appRoQJZBl8WC5KWa/Users';

  try {
    final Uri uri = Uri.parse(
        '$airtableApiEndpoint?filterByFormula=AND({Firebase UID}="${uid}")');
    final http.Response queryResponse = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $airtableApiKey',
        'Content-Type': 'application/json',
      },
    );

    if (queryResponse.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(queryResponse.body);
      final List<dynamic> records = responseData['records'];
      if (records.isNotEmpty) {
        final Map<String, dynamic> fields = records[0]['fields'];
        String userRecordID = fields['User Record ID'];
        String firstName = fields['First Name'];
        String lastName = fields['Last Name'];
        String email = fields['Email'];
        String phoneNumber = fields['Phone Number'];

        Users user = Users();
        user.uid = uid;
        user.userRecordID = userRecordID;
        user.firstName = firstName;
        user.lastName = lastName;
        user.email = email;
        user.phoneNumber = phoneNumber;
        saveUserToSP(user);
        print('user rec id from updateUserDeviceInfoToAt ${userRecordID}');
        print('user name from updateUserDeviceInfoToAt ${firstName}');
      }
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
          // print('Data updated successfully');
          // print(updateResponse.body);
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
    // print('Data uploaded successfully');
    // print(response.body);
  } else {
    print('Failed to upload data. Status code: ${response.statusCode}');
    print(response.body);
  }
}
