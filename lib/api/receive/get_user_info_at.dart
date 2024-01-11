import 'dart:convert';
import 'package:http/http.dart' as http;

Future<bool> getUserInfoFromAirtable(String? userId) async {
  final String airtableApiKey =
      'patS6BGUI9SY8OcFJ.fd3c067a6f9874f1847fddf6a21815d8b54dac5ed1b0340dae533856d0c9437a';
  final String airtableApiEndpoint =
      'https://api.airtable.com/v0/appRoQJZBl8WC5KWa/Users';
  final Uri uri = Uri.parse(
      '$airtableApiEndpoint?filterByFormula=SEARCH("${Uri.encodeComponent(userId!)}", {UID})');

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
        print('records found for user with ID: $userId');
        return true;
      } else {
        print('No records found for user with ID: $userId');
        return false;
      }
    } else {
      print('Failed to fetch data. Status code: ${response.statusCode}');
      print(response.body);
      return false;
    }
  } catch (e) {
    print('Error: $e');
    return false;
  }
}
