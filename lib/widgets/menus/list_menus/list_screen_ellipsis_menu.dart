import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../api/contacts/airtable/upload_contacts.dart';
import '../../../models/contact_model.dart';
import '../../../providers/contact_providers.dart';
import '../../../providers/list_providers.dart';
import '../../../api/contacts/shared_preferences/save_contacts_to_shared_preferences.dart';
import '../../../providers/user_providers.dart';
import 'clone_list_menu.dart';

// Need to refactor the code here make functions for the items at the bottom of the page.

void listScreenEllipsisMenu(BuildContext context, ref) {
  List<ContactModel> contacts = ref.read(selectedContacts);
  List<ContactModel> contactsInList = ref.read(contactsProvider);
  List<ContactModel> contactsCopy = List.from(contactsInList);
  List<ContactModel> processedContacts = [];
  List<ContactModel> unchangedContacts = [];

  final RenderBox overlay =
      Overlay.of(context).context.findRenderObject() as RenderBox;

  List<PopupMenuEntry<dynamic>> notSelectable = [
    if (ref.read(selectedListProvider) != 'All' &&
        ref.read(selectedListProvider) != 'Tehine')
      PopupMenuItem(
        child: Text('Delete List'),
        value: 1,
      ),
    if (ref.read(selectedListProvider) != 'Tehine')
      PopupMenuItem(
        child: Text('Share List'),
        value: 2,
      ),
    if (ref.read(selectedListProvider) != 'Tehine')
      PopupMenuItem(
        child: Text('Clone List'),
        value: 3,
      ),
    PopupMenuItem(
      child: Text('Select Contacts'),
      value: 4,
    ),
  ];

  List<PopupMenuEntry<dynamic>> selectable = [
    if (ref.read(selectedListProvider) == 'All') // Check the condition
      PopupMenuItem(
        child: Text('Delete'),
        value: 5,
      ),
    if (ref.read(selectedListProvider) != 'Tehine' &&
        ref.read(selectedListProvider) != 'All')
      PopupMenuItem(
        child: Text('Remove'),
        value: 8,
      ),
    PopupMenuItem(
      child: Text('Share'),
      value: 6,
    ),
    PopupMenuItem(
      child: Text('Add To List'),
      value: 7,
    ),
  ];

  // List<PopupMenuEntry<dynamic>> selectableSingleSelected = [
  //   if (ref.read(selectedListProvider) != 'Tehine') // Check the condition
  //     PopupMenuItem(
  //       child: Text('Delete Selected Contact'),
  //       value: 5,
  //     ),
  //   PopupMenuItem(
  //     child: Text('Share Selected Contact'),
  //     value: 6,
  //   ),
  //   PopupMenuItem(
  //     child: Text('Add Selected Contact To List'),
  //     value: 7,
  //   ),
  // ];

  List<PopupMenuEntry<dynamic>> itemsToShow = [];

  if (ref.read(isSelectable)) {
    // if (ref.read(selectedContacts.notifier).state.length > 1) {
    itemsToShow = selectable;
    // } else {
    //   itemsToShow = selectableSingleSelected;
    // }
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
      if (value == 1) {
        for (ContactModel contact in contactsCopy) {
          // Check if the lists have been modified
          if (contact.lists.contains('${ref.read(selectedListProvider)}')) {
            ContactModel updatedContact = ContactModel(
              contactID: '',
              firstName: contact.firstName,
              lastName: contact.lastName,
              email: contact.email,
              phoneNumber: contact.phoneNumber,
              lists: [...contact.lists]
                ..remove('${ref.read(selectedListProvider)}'),
            );

            processedContacts.add(updatedContact);
            await updateContactsListsToAt(
              ref.read(userStreamProvider).value!.uid,
              '',
              updatedContact.firstName,
              updatedContact.lastName,
              updatedContact.phoneNumber,
              updatedContact.email,
              updatedContact.lists,
              ref.read(userStreamProvider).value!.uid,
            );

            print(updatedContact.lists.toString());
          } else {
            unchangedContacts.add(contact);
          }
        }
        List<ContactModel> allContacts = [
          ...processedContacts,
          ...unchangedContacts
        ];
        await saveContactsToSP(allContacts);

        // ref.read(selectedListProvider.notifier).state = 'All';
        List<String> currentList = ref.read(listProvider.notifier).state;
        String selectedList = ref.read(selectedListProvider);

        // Check if the selected list exists before removing
        if (currentList.contains(selectedList)) {
          currentList.remove(selectedList);

          // Update the selected list to a valid state
          ref.read(selectedListProvider.notifier).state =
              currentList.isNotEmpty ? currentList[1] : null;

          ref.read(listProvider.notifier).state = currentList;
          removeListFromSP(selectedList, ref);
          ref.refresh(listFromSharedPrefranceProvider);
          ref.refresh(contactsFromSharedPrefProvider);
          ref.read(selectedContacts.notifier).state = <ContactModel>[];
        }
      }
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
        for (ContactModel contact in contacts) {
          print('Type of contact.lists: ${contacts.runtimeType}');
          ContactModel contactsToDelete = ContactModel(
            contactID: '',
            firstName: contact.firstName,
            lastName: contact.lastName,
            email: contact.email,
            phoneNumber: contact.phoneNumber,
            lists: contact.lists,
          );
          print('this is the type${contacts.runtimeType}');
          await deleteContactsFromUserAccountToAt(
              ref.read(userStreamProvider).value.uid,
              contactsToDelete.firstName,
              contactsToDelete.lastName,
              contactsToDelete.phoneNumber,
              contactsToDelete.email,
              contactsToDelete.lists,
              '');
          await deleteContactFromSP(contact);
        }
        ref.refresh(contactsFromSharedPrefProvider);
        ref.read(selectedContacts.notifier).state = <ContactModel>[];
        ref.read(isSelectable.notifier).state = false;
      }
      if (value == 8) {
        for (ContactModel contact in contacts) {
          ContactModel updatedContact = ContactModel(
            contactID: '',
            firstName: contact.firstName,
            lastName: contact.lastName,
            email: contact.email,
            phoneNumber: contact.phoneNumber,
            lists: [...contact.lists]
              ..remove('${ref.read(selectedListProvider)}'),
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
          ref.read(selectedContacts.notifier).state = <ContactModel>[];
          ref.read(isSelectable.notifier).state = false;
          print(updatedContact.lists.toString());
        }
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
          List<String> updatedLists = List<String>.from(contact.lists);

          // Check if 'All' is already present
          if (!updatedLists.contains('All')) {
            updatedLists.add('All');
          }
          ContactModel updatedContact = ContactModel(
            contactID: contact.contactID,
            firstName: contact.firstName,
            lastName: contact.lastName,
            email: contact.email,
            phoneNumber: contact.phoneNumber,
            lists: [...updatedLists, value],
          );
          print(updatedContact.lists);
          String listsAsString = updatedContact.lists!.join(', ');
          processedContacts = ref.read(contactsProvider);
          processedContacts.add(updatedContact);
          saveContactsToSP(processedContacts);
          if (ref.read(selectedListProvider) == 'Tehine') {
            saveContactToSavedTable(updatedContact.contactID,
                ref.read(userStreamProvider).value!.uid, listsAsString);
          } else {
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
          }

          ref.refresh(contactsFromSharedPrefProvider);
          ref.read(selectedContacts.notifier).state = [];
          ref.read(isSelectable.notifier).state = false;
          print(updatedContact.lists.toString());
        }
      }
    });
  }
}
