import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tehine/shared/globals.dart' as globals;

import '../../../../models/users_model.dart';
import '../../../../providers/user_providers.dart';
import '../shared_preferences/get_user_from_shared_preferences.dart';
import '../shared_preferences/save_user_to_shared_preferences.dart';

// This gets the user record id when a user logs in on a device

Future<String> getUserRecordIDFromAT(
  ref,
  String? userFirebaseUID,
) async {
  final String airtableApiKey =
      'patS6BGUI9SY8OcFJ.fd3c067a6f9874f1847fddf6a21815d8b54dac5ed1b0340dae533856d0c9437a';
  final String airtableApiEndpoint =
      'https://api.airtable.com/v0/appRoQJZBl8WC5KWa/Users?filterByFormula={Firebase UID}="${userFirebaseUID}"';
  String _userRecordId = '';
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
      print('Data uploaded successfully');
      print(response.body);
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final List<dynamic> records = responseData['records'];
      for (final record in records) {
        final Map<String, dynamic> fields = record['fields'];
        String userRecordID = record['id'];
        Users user = Users(
          userRecordID: userRecordID,
          uid: userFirebaseUID,
          firstName: fields['First Name'] ?? '',
          lastName: fields['Last Name'] ?? '',
          email: fields['Email'] ?? '',
          phoneNumber: fields['Phone Number'] ?? '',
        );
        _userRecordId = userRecordID;
        await saveUserToSP(user);
        // could only call this if calling this function from the invitations tab.
        ref.read(userRecordIDProvider.notifier).state = userRecordID;
        print('User Record id ${userRecordID}');
        print('User First Name ${fields['First Name']}');
      }
    }
  } catch (e) {
    print('Error:: $e');
  }
  return _userRecordId;
}
