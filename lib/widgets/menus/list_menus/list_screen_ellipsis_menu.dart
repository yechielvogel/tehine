import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../api/send/upload_contacts_at.dart';
import '../../../models/contact_model.dart';
import '../../../providers/contact_provider.dart';
import '../../../providers/list_provider.dart';
import '../../../providers/load_data_from_device_on_start.dart';
import '../../../providers/user_info_provider.dart';

void listScreenEllipsisMenu(BuildContext context, ref) {
  final RenderBox overlay =
      Overlay.of(context).context.findRenderObject() as RenderBox;

  List<PopupMenuEntry<dynamic>> notSelectable = [
    PopupMenuItem(
      child: Text('Delete List'),
      value: 1,
    ),
    PopupMenuItem(
      child: Text('Share List'),
      value: 2,
    ),
    PopupMenuItem(
      child: Text('Select Contacts'),
      value: 3,
    ),
  ];

  List<PopupMenuEntry<dynamic>> Selectable = [
    PopupMenuItem(
      child: Text('Delete Selected Contacts'),
      value: 4,
    ),
    PopupMenuItem(
      child: Text('Share Selected Contacts'),
      value: 5,
    ),
    PopupMenuItem(
      child: Text('Add Selected Contacts To List'),
      value: 6,
    ),
  ];
  List<PopupMenuEntry<dynamic>> itemsToShow = [];
  ref.read(isSelectable)
      ? itemsToShow = Selectable
      : itemsToShow = notSelectable;

  showMenu(
    context: context,
    position: RelativeRect.fromRect(
      Rect.fromPoints(
        Offset(0, 0),
        overlay.localToGlobal(overlay.size.bottomLeft(Offset.zero)),
      ),
      Offset.zero & overlay.size,
    ),
    items: itemsToShow,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
    elevation: 8,
    color: Color(0xFFF5F5F5),
  ).then((value) async {
    if (value != null) {
      if (value == 3) {
        String selectedContactPhoneNumber =
            ref.read(selectedContact.notifier).state;

        ref.read(isSelectable.notifier).state = true;
        print(ref.read(isSelectable.notifier).state);
      }
      if (value == 2) {
    
  
      }
      if (value == 6) {
        selectableListScreenEllipsisMenu(context, ref);
      }
    }
  });
}

// This function is for when selectable and want to add selected to a certain list

void selectableListScreenEllipsisMenu(BuildContext context, WidgetRef ref) {
  List<ContactModel> contacts = ref.read(selectedContacts);
  List<ContactModel> processedContacts = [];
  final RenderBox overlay =
      Overlay.of(context).context.findRenderObject() as RenderBox;

  final AsyncValue<List<String>> listOptions =
      ref.watch(listFromSharedPrefranceProvider);

  if (listOptions is AsyncData) {
    final List<String> listItems = listOptions.value ?? [];

    List<String> filteredListItems =
        listItems.where((item) => item != 'All' && item != 'Tehine').toList();

    showMenu(
      context: context,
      position: RelativeRect.fromRect(
        Rect.fromPoints(
          Offset(0, 0),
          overlay.localToGlobal(overlay.size.bottomLeft(Offset.zero)),
        ),
        Offset.zero & overlay.size,
      ),
      items: [
        PopupMenuItem(
          child: Text(
            'Add contacts to list:',
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
        for (ContactModel contact in contacts) {
          ContactModel updatedContact = ContactModel(
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
          ref.read(selectedContacts.notifier).state = [];
          ref.read(isSelectable.notifier).state = false;
          print(updatedContact.lists.toString());
        }
      }
    });
  }
}
