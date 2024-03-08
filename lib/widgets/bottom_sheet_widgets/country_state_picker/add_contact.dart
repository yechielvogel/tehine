import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tehine/shared/style.dart';

import '../../../backend/api/contacts/airtable/upload_contacts.dart';
import '../../../backend/api/contacts/shared_preferences/save_contacts_to_shared_preferences.dart';
import '../../../models/contact_model.dart';
import '../../../models/country_model.dart';
import '../../../providers/contact_providers.dart';
import '../../../providers/event_providers.dart';
import '../../../providers/list_providers.dart';
import '../../../providers/user_providers.dart';
import '../../tiles/contact_tiles/contact_tile_widget.dart';
import '../../tiles/contact_tiles/select_contact_tile_widget.dart';

class AddContactWidget extends ConsumerStatefulWidget {
  AddContactWidget({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<AddContactWidget> createState() => _AddContactWidgetState();
}

class _AddContactWidgetState extends ConsumerState<AddContactWidget> {
  // @override
  // void initState() {
  //   super.initState();
  //   _getCountry();
  // }

  @override
  Widget build(BuildContext context) {
    List<ContactModel> allContacts = ref.read(allContactsForAddingProvider);

    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (overscroll) {
        if (overscroll.leading) {
          // Scroll down to dismiss the keyboard
          FocusScope.of(context).unfocus(); // Close the keyboard
          return true; // Consume the notification
        }
        return false; // Allow normal overscroll behavior
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20), topLeft: Radius.circular(20)),
          color: Color(0xFFF5F5F5),
        ),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(right: 10, left: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Add Contacts",
                    style: TextStyle(
                        color: Colors.grey[850],
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 30,
                          height: 30,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              width: 25,
                              height: 25,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey[850],
                              ),
                              child: IconButton(
                                icon: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 15,
                                ),
                                onPressed: () async {
                                  // Add contacts to sp and at
                                  await saveContacts();
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 5),
                        SizedBox(
                          width: 30,
                          height: 30,
                          child: InkWell(
                            child: Container(
                              width: 25,
                              height: 25,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey[850],
                              ),
                              child: IconButton(
                                icon: Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 15,
                                ),
                                onPressed: () async {
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding:
                  const EdgeInsets.only(right: 12.0, left: 12.0, bottom: 10),
              child: TextFormField(
                cursorColor: Colors.grey[850],
                decoration: InputDecoration(
                  focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                          color: Colors.grey[350] ?? Colors.grey, width: 3)),
                  hintText: 'Search',
                  hintStyle: TextStyle(color: Colors.grey[850]),
                  fillColor: Colors.grey[350] ?? Colors.grey,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                          color: Colors.grey[350] ?? Colors.grey, width: 3.0)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                          color: Colors.grey[350] ?? Colors.grey, width: 3.0)),
                  errorStyle: TextStyle(
                    color: Colors.grey[850],
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                        color: Colors.grey[350] ?? Colors.grey, width: 3.0),
                  ),
                ),
                style: TextStyle(color: Colors.grey[850]),
                onChanged: (value) {},
              ),
            ),
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: allContacts.length,
              itemBuilder: (BuildContext context, int index) {
                ContactModel contact = allContacts[index];
                return
                    // SelectContactTileWidget(contact: contact,

                    Hero(
                  tag: 'contactHeroTag_${contact.phoneNumber}',
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10, right: 5),
                    child: SelectContactTileWidget(
                      contact: contact,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> saveContacts() async {
    List<ContactModel> contacts = ref.read(selectedContacts);
    List<ContactModel> processedContacts = [];

    for (ContactModel contact in contacts) {
      ContactModel newContact = ContactModel(
        userRecordID: contact.userRecordID,
        contactRecordID: '',
        firstName: contact.firstName,
        lastName: contact.lastName,
        email: contact.email,
        phoneNumber: contact.phoneNumber,
        addressStreet: contact.addressStreet,
        addressCity: contact.addressCity,
        addressState: contact.addressState,
        addressCountry: contact.addressCountry,
        addressZip: contact.addressZip,   
        // Need to add addresses
        lists: ['All'],
      );
      String listsAsString = newContact.lists!.join(', ');
      processedContacts = ref.read(contactsProvider);
      processedContacts.add(newContact);
      // Some reason not saveing addresses to sp
      saveContactsToSP(processedContacts);
      uploadContactsToAt(
          null,
          newContact.firstName,
          newContact.lastName,
          newContact.phoneNumber,
          newContact.email,
          newContact.address,
          newContact.addressStreet,
          newContact.addressCity,
          newContact.addressState,
          newContact.addressZip,
          newContact.addressCountry,
          newContact.lists,
          // This should be changed to userRecordID so we could relate in at.
          ref.read(userStreamProvider).value?.uid);
      ref.refresh(contactsFromSharedPrefProvider);
      ref.read(selectedContacts.notifier).state = [];
      ref.read(isSelectable.notifier).state = false;
    }
  }
}
