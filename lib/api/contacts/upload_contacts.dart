import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:contacts_service/contacts_service.dart';

import '../../models/contact_model.dart';
import '../../providers/contact_provider.dart';
import '../../providers/load_data_from_device_on_start.dart';

// This function gets all contacts from phone

Future<void> uploadContactsFromDevice(String? uid, ref) async {
  Iterable<Contact> contacts = await ContactsService.getContacts(
    withThumbnails: true,
  );
  List<Contact> contactList = contacts.toList();
  List<ContactModel> processedContacts = [];
  for (var contact in contactList) {
    String firstName = contact.givenName ?? '';
    String lastName = contact.familyName ?? '';
    String email = '';
    Object address = contact.postalAddresses ?? '';
    List lists = ['All'];
    String phoneNumber = '';

    if (contact.phones != null && contact.phones!.isNotEmpty) {
      phoneNumber = contact.phones!.first.value ?? '';
    }

    if (contact.emails != null && contact.emails!.isNotEmpty) {
      email = contact.emails!.first.value ?? '';
    }

    String? contactProfilePic;
    if (contact.avatar != null && contact.avatar!.isNotEmpty) {
      contactProfilePic = base64Encode(contact.avatar!);
    }

    processedContacts.add(
      ContactModel(
        firstName: firstName,
        lastName: lastName,
        email: email,
        phoneNumber: phoneNumber,
        lists: ['All'],
      ),
    );
    saveContactsToSP(processedContacts);
    await uploadContactsToAt(
      null,
      firstName,
      lastName,
      phoneNumber,
      email,
      // address,
      // contactProfilePic,
      lists,
      uid,
    );
    await ref.refresh(contactsFromSharedPrefProvider);
  }
}

// This function uploads all contacts to airtable

Future<void> uploadContactsToAt(
    String? title,
    String? firstName,
    String? lastName,
    String phoneNumber,
    String email,
    // Object address,
    List? lists,
    String? addedByUser) async {
  final String airtableApiKey =
      'patS6BGUI9SY8OcFJ.fd3c067a6f9874f1847fddf6a21815d8b54dac5ed1b0340dae533856d0c9437a';
  final String airtableApiEndpoint =
      'https://api.airtable.com/v0/appRoQJZBl8WC5KWa/Contacts';
  String listsAsString = lists!.join(', ');
  final Map<String, dynamic> data = {
    // 'Title': title,
    'First Name': firstName,
    'Last Name': lastName,
    'Phone': phoneNumber,
    'Email': email,
    // 'Address': address,
    "Lists": listsAsString,
    'Added By User': addedByUser,
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

// This function updates a contacts lists in AirTable

Future<void> updateContactsListsToAt(
    String? uid,
    String? title,
    String? firstName,
    String? lastName,
    String phoneNumber,
    String email,
    // Object address,
    List? lists,
    String? addedByUser) async {
  final String airtableApiKey =
      'patS6BGUI9SY8OcFJ.fd3c067a6f9874f1847fddf6a21815d8b54dac5ed1b0340dae533856d0c9437a';
  final String airtableApiEndpoint =
      'https://api.airtable.com/v0/appRoQJZBl8WC5KWa/Contacts';

  try {
    final Uri uri = Uri.parse(
        '$airtableApiEndpoint?filterByFormula=AND({Added By User}="${uid}", {Phone}="$phoneNumber", {Email}="$email", {First Name}="$firstName", {Last Name}="$lastName")');
    final http.Response queryResponse = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $airtableApiKey',
        'Content-Type': 'application/json',
      },
    );

    if (queryResponse.statusCode == 200) {
      String listsAsString = lists!.join(', ');
      final List<dynamic> records = jsonDecode(queryResponse.body)['records'];

      if (records.isNotEmpty) {
        final String recordId = records[0]['id'];

        final Uri updateUri = Uri.parse('$airtableApiEndpoint/$recordId');
        final Map<String, dynamic> data = {
          'fields': {
            "Lists": listsAsString,
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

// This function deletes contacts from the users account in airtable

// This need refactoring don't need the uid twice.

Future<void> deleteContactsFromUserAccountToAt(
    String? uid,
    // String? title,
    String? firstName,
    String? lastName,
    String phoneNumber,
    String email,
    // Object address,
    List? lists,
    String? addedByUser) async {
  final String airtableApiKey =
      'patS6BGUI9SY8OcFJ.fd3c067a6f9874f1847fddf6a21815d8b54dac5ed1b0340dae533856d0c9437a';
  final String airtableApiEndpoint =
      'https://api.airtable.com/v0/appRoQJZBl8WC5KWa/Contacts';

  try {
    final Uri uri = Uri.parse(
        '$airtableApiEndpoint?filterByFormula=AND({Added By User}="${uid}", {Phone}="$phoneNumber", {Email}="$email", {First Name}="$firstName", {Last Name}="$lastName")');
    final http.Response queryResponse = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $airtableApiKey',
        'Content-Type': 'application/json',
      },
    );

    if (queryResponse.statusCode == 200) {
      String listsAsString = lists!.join(', ');
      final List<dynamic> records = jsonDecode(queryResponse.body)['records'];

      if (records.isNotEmpty) {
        final String recordId = records[0]['id'];

        final Uri updateUri = Uri.parse('$airtableApiEndpoint/$recordId');
        final Map<String, dynamic> data = {
          'fields': {
            "Added By User": addedByUser,
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
  } 
  
  
  catch (error) {
    print('Error: $error');
  }
  
}
