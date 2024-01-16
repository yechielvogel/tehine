import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../api/contacts/upload_contacts.dart';
import '../../../models/contact_model.dart';
import '../../../providers/contact_provider.dart';
import '../../../providers/list_provider.dart';
import '../../../providers/load_data_from_device_on_start.dart';
import '../../../providers/user_provider.dart';
import 'clone_list_menu.dart';

void listScreenEllipsisMenu(BuildContext context, ref) {
  List<ContactModel> contacts = ref.read(selectedContacts);

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
      child: Text('Clone List'),
      value: 3,
    ),
    PopupMenuItem(
      child: Text('Select Contacts'),
      value: 4,
    ),
  ];

  List<PopupMenuEntry<dynamic>> SelectableMultipleSelected = [
    PopupMenuItem(
      child: Text('Delete Selected Contacts'),
      value: 5,
    ),
    PopupMenuItem(
      child: Text('Share Selected Contacts'),
      value: 6,
    ),
    PopupMenuItem(
      child: Text('Add Selected Contacts To List'),
      value: 7,
    ),
  ];
     
  List<PopupMenuEntry<dynamic>> SelectableSingleSelected = [
    PopupMenuItem(
      child: Text('Delete Selected Contact'),
      value: 5,
    ),
    PopupMenuItem(
      child: Text('Share Selected Contact'),
      value: 6,
    ),
    PopupMenuItem(
      child: Text('Add Selected Contact To List'),
      value: 7,
    ),
  ];

  List<PopupMenuEntry<dynamic>> itemsToShow = [];

  if (ref.read(isSelectable)) {
    if (ref.read(selectedContacts.notifier).state.length > 1) {
      itemsToShow = SelectableMultipleSelected;
    } else {
      itemsToShow = SelectableSingleSelected;
    }
  } else {
    itemsToShow = notSelectable;
  }

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
      if (value == 4) {
        String selectedContactPhoneNumber =
            ref.read(selectedContact.notifier).state;

        ref.read(isSelectable.notifier).state = true;
        print(ref.read(isSelectable.notifier).state);
      }
      if (value == 3) {
        cloneListMenu(context, ref);
      }

      if (value == 7) {
        selectableListScreenEllipsisMenu(context, ref);
      }
      if (value == 5) {
        // await deleteContactFromSP(contacts);    

        for (ContactModel contact in contacts) {
          await deleteContactsFromUserAccountToAt(
              ref.read(userStreamProvider).value.uid,
              contact.firstName,
              contact.lastName,
              contact.phoneNumber,
              contact.email,
              contact.lists,
              '');
        }
        ref.refresh(contactsFromSharedPrefProvider);
        ref.read(selectedContacts.notifier).state = [];
        ref.read(isSelectable.notifier).state = false;
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
