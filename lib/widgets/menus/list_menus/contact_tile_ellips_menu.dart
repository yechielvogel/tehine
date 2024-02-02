import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../api/contacts/airtable/upload_contacts.dart';
import '../../../models/contact_model.dart';
import '../../../providers/contact_providers.dart';
import '../../../providers/list_providers.dart';
import '../../../api/contacts/shared_preferences/save_contacts_to_shared_preferences.dart';
import '../../../providers/user_providers.dart';   

void contactTileEllipsisMenu(BuildContext context, WidgetRef ref,
    ContactModel contact, Offset tapPosition) {
  final RenderBox overlay =    
      Overlay.of(context).context.findRenderObject() as RenderBox;
  List<ContactModel> processedContacts = [];

  final AsyncValue<List<String>> listOptions =
      ref.watch(listFromSharedPreferenceProvider);

  if (listOptions is AsyncData) {
    final List<String> listItems = listOptions.value ?? [];

    // Exclude "All" and "Tehine" from the list
    List<String> filteredListItems =
        listItems.where((item) => item != 'All' && item != 'Tehine').toList();

    showMenu(
      context: context,
      position: RelativeRect.fromRect(
        Rect.fromPoints(
          tapPosition, 
          overlay.localToGlobal(overlay.size.bottomLeft(Offset.zero)),
        ),
        Offset.zero & overlay.size,
      ),
      items: [
        PopupMenuItem(
          child: Text(
            'Add contact to list:',
            style:
                TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[850]),
          ),
          enabled: false, 
        ),
        ...filteredListItems.map((String listItem) {
          return PopupMenuItem(
            child: Text(listItem),
            value: listItem,
          );
        }),
      ],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8,
      color: Color(0xFFF5F5F5),      
    ).then((value) {   
      if (value != null) {
        ContactModel updatedContact = ContactModel(
          contactID: contact.contactID,
          firstName: contact.firstName,
          lastName: contact.lastName,
          email: contact.email,
          phoneNumber: contact.phoneNumber,    
          lists: [...contact.lists, value],
        );

        processedContacts = ref.read(contactsProvider);
        processedContacts.add(updatedContact);
        saveContactsToSP(processedContacts);
        updateContactsListsToAt(
          ref.read(userStreamProvider).value!.uid,
          '',
          updatedContact.firstName,
          updatedContact.lastName,
          updatedContact.phoneNumber,
          updatedContact.email,
          updatedContact.lists,
          ref.read(userStreamProvider).value!.uid,
        );
        ref.refresh(contactsFromSharedPrefProvider);
        print(updatedContact.lists.toString());
      }
    });
  }
}
