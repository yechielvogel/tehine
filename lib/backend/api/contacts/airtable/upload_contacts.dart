import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:contacts_service/contacts_service.dart';

import '../../../../models/contact_model.dart';
import '../../../../providers/contact_providers.dart';
import '../shared_preferences/save_contacts_to_shared_preferences.dart';

// This function gets all contacts from phone

Future<void> uploadContactsFromDevice(String? uid, ref, bool shouldSave) async {
  Iterable<Contact> contacts = await ContactsService.getContacts(
    withThumbnails: true,
  );
  List<Contact> contactList = contacts.toList();
  List<ContactModel> allContacts = ref.read(contactsProvider);
  List<ContactModel> processedContacts = allContacts;

  for (var contact in contactList) {
    String firstName = contact.givenName ?? '';
    String lastName = contact.familyName ?? '';
    if (firstName.isEmpty && lastName.isEmpty) {
      continue;
    }
    String email = '';
    List<PostalAddress>? postalAddresses = contact.postalAddresses;

    String? street = '';
    String? city = '';
    String? state = '';
    String? zip = '';
    String? country = '';

    if (postalAddresses != null) {
      for (PostalAddress address in postalAddresses) {
        street = address.street;
        city = address.city;
        state = address.region;
        zip = address.postcode;
        country = address.country;
        // Do something with the street...
      }
    }

    String? fullAddress =
        postalAddresses.toString().replaceAll(RegExp(r'[\[\]]'), '');

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
        contactRecordID: '',
        firstName: firstName,
        lastName: lastName,
        email: email,
        phoneNumber: phoneNumber,
        lists: ['All'],
        address: fullAddress,
        addressStreet: street,
        addressCity: city,
        addressState: state,
        addressZip: zip,
        addressCountry: country,
      ),
    );
    if (shouldSave == true) {
      saveContactsToSP(processedContacts);
      await uploadContactsToAt(
        null,
        firstName,
        lastName,
        phoneNumber,
        email,
        fullAddress,
        street,
        city,
        state,
        zip,
        country,
        // address,
        // contactProfilePic,
        lists,
        uid,
      );
      await ref.refresh(contactsFromSharedPrefProvider);
    } else {
      Map<String, ContactModel> uniqueContactsMap = {};
      for (ContactModel contact in processedContacts) {
        uniqueContactsMap[contact.phoneNumber] = contact;
      }
      processedContacts = uniqueContactsMap.values.toList();
      ref.read(allContactsForAddingProvider.notifier).state = processedContacts;
    }
  }
}

// This function uploads all contacts to airtable

Future<void> uploadContactsToAt(
    String? title,
    String? firstName,
    String? lastName,
    String phoneNumber,
    String email,
    String? fullAddress,
    String? street,
    String? city,
    String? state,
    String? zip,
    String? country,
    List? lists,
    // Should change this to user recordId. basically firebase uid is only for auth
    String? addedByUser) async {
  final String airtableApiKey =
      'patS6BGUI9SY8OcFJ.fd3c067a6f9874f1847fddf6a21815d8b54dac5ed1b0340dae533856d0c9437a';
  final String airtableApiEndpoint =
      'https://api.airtable.com/v0/appRoQJZBl8WC5KWa/Contacts';
  String listsAsString = lists!.join(', ');
  final Map<String, dynamic> data = {
    'First Name': firstName,
    'Last Name': lastName,
    'Phone Number': phoneNumber,
    'Email': email,
    'Address': fullAddress,
    'Address Street': street,
    'Address City': city,
    'Address State': state,
    'Address Zip': zip,
    'Address Country': country,
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

    // Step 2: Save the contact for the user in the "Saved Contacts" table
    final Map<String, dynamic> responseData = jsonDecode(response.body);
    String contactRecordID =
        responseData['id']; // Access the ID returned by Airtable

    // Call the function to save the contact for the user in the "Saved Contacts" table

    // Call this function when not using the airtable automation to add saved contacts from contacts table

    /*
    Refactor this to make a link in the users saved contacts field in the users 
    table
    */
    // saveContactsToUsersLink();
    saveContactToSavedTable(contactRecordID, addedByUser!, listsAsString);
  } else {
    print('Failed to upload data. Status code: ${response.statusCode}');
    print(response.body);
  }
}

// This function saves contacts to saved contacts in airtable

Future<void> saveContactToSavedTable(
    String contactRecordID, String? savedByID, lists) async {
  final String airtableApiKey =
      'patS6BGUI9SY8OcFJ.fd3c067a6f9874f1847fddf6a21815d8b54dac5ed1b0340dae533856d0c9437a';
  final String airtableApiEndpoint =
      'https://api.airtable.com/v0/appRoQJZBl8WC5KWa/Saved%20Contacts';

  final Map<String, dynamic> requestData = {
    'fields': {
      'Contact Link': [contactRecordID],
      'Saved By User': savedByID,
      'Lists': lists,
    },
  };

  final Uri uri = Uri.parse(airtableApiEndpoint);
  final http.Response response = await http.post(
    uri,
    headers: {
      'Authorization': 'Bearer $airtableApiKey',
      'Content-Type': 'application/json',
    },
    body: jsonEncode(requestData),
  );

  if (response.statusCode == 200) {
    print('Contact saved in "Saved Contacts" table successfully');
    print(response.body);
  } else {
    print('Failed to save contact. Status code: ${response.statusCode}');
    print(response.body);
  }
}

/* 
This function is a refactor of the saveContactToSavedTable
Just one problem not sure what to do about the lists. have to figure it out.

*/
// Future<void> saveContactsToUsers(
// String userRecordID,
// String contactRecordID,
// ) async {
//   final String airtableApiKey =
//       'patS6BGUI9SY8OcFJ.fd3c067a6f9874f1847fddf6a21815d8b54dac5ed1b0340dae533856d0c9437a';
//   final String airtableApiEndpoint =
//       'https://api.airtable.com/v0/appRoQJZBl8WC5KWa/Users/$userRecordID';

//  final Map<String, dynamic> requestData = {
//     'fields': {
//       'Saved Contacts': [contactRecordID],

//       'Lists': lists,
//     },
//   };

//   final Uri uri = Uri.parse(airtableApiEndpoint);
//   final http.Response response = await http.post(
//     uri,
//     headers: {
//       'Authorization': 'Bearer $airtableApiKey',
//       'Content-Type': 'application/json',
//     },
//     body: jsonEncode(requestData),
//   );

//   if (response.statusCode == 200) {
//     print('Contact saved in "Saved Contacts" table successfully');
//     print(response.body);
//   } else {
//     print('Failed to save contact. Status code: ${response.statusCode}');
//     print(response.body);
//   }
// }
// This function updates a contacts lists in AirTable

Future<void> updateContactsListsToAt(
    String? uid,
    String? title,
    String? firstName,
    String? lastName,
    String phoneNumber,
    String email,
    List? lists,
    String? addedByUser) async {
  final String airtableApiKey =
      'patS6BGUI9SY8OcFJ.fd3c067a6f9874f1847fddf6a21815d8b54dac5ed1b0340dae533856d0c9437a';
  final String airtableApiEndpoint =
      'https://api.airtable.com/v0/appRoQJZBl8WC5KWa/Saved%20Contacts';

  try {
    final Uri uri = Uri.parse(
        '$airtableApiEndpoint?filterByFormula=AND({Saved By User}="${uid}", {First Name (from Contact Link)}="$firstName", {Last Name (from Contact Link)}="$lastName", {Phone (from Contact Link)}="$phoneNumber")');

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
    String? firstName,
    String? lastName,
    String phoneNumber,
    String email,
    List<String>? lists,
    String? addedByUser) async {
  final String airtableApiKey =
      'patS6BGUI9SY8OcFJ.fd3c067a6f9874f1847fddf6a21815d8b54dac5ed1b0340dae533856d0c9437a';
  final String airtableApiEndpoint =
      'https://api.airtable.com/v0/appRoQJZBl8WC5KWa/Saved%20Contacts';

  try {
    final Uri uri = Uri.parse(
        '$airtableApiEndpoint?filterByFormula=AND({Saved By User}="${uid}", {Phone (from Contact Link)}="$phoneNumber", {Email (from Contact Link)}="$email", {First Name (from Contact Link)}="$firstName", {Last Name (from Contact Link)}="$lastName")');
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

        final Uri deleteUri = Uri.parse('$airtableApiEndpoint/$recordId');
        final http.Response deleteResponse = await http.delete(
          deleteUri,
          headers: {
            'Authorization': 'Bearer $airtableApiKey',
          },
        );

        if (deleteResponse.statusCode == 200) {
          print('Data deleted successfully');
          print(deleteResponse.body);
        } else {
          print(
              'Failed to delete data. Status code: ${deleteResponse.statusCode}');
          print(deleteResponse.body);
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
