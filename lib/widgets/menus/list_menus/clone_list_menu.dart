import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../api/send/upload_contacts_at.dart';
import '../../../models/contact_model.dart';
import '../../../providers/contact_provider.dart';
import '../../../providers/list_provider.dart';
import '../../../providers/load_data_from_device_on_start.dart';
import '../../../providers/user_info_provider.dart';
import '../../forms/list_screen_add_list_pop_up_form.dart';

void cloneListMenu(BuildContext context, WidgetRef ref) {
  final RenderBox overlay =
      Overlay.of(context).context.findRenderObject() as RenderBox;

  final AsyncValue<List<String>> listOptions =
      ref.read(listFromSharedPrefranceProvider);

  if (listOptions is AsyncData) {
    String savedNameFromCreatedList = '';

    final List<String> listItems = listOptions.value ?? [];

    // Exclude "All" and "Tehine" from the list
    List<String> filteredListItems =
        listItems.where((item) => item != 'All' && item != 'Tehine').toList();

    List<PopupMenuEntry<dynamic>> itemsToShow = [
      PopupMenuItem(
        child: Text(
          'Clone List:',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey[850],
          ),
        ),
        enabled: false,
      ),
      PopupMenuItem(
        child: Text('Create New List'),
        value: 1,
      ),
      ...filteredListItems.map((String listItem) {
        return PopupMenuItem(
          child: Text(listItem),
          value: listItem,
        );
      }),
    ];

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
      if (value != null && value != 2 && value != 1) {

        await cloneContactsToList(value, ref);
      }
      if (value == 1) {
        await showDialog(
            context: context,
            builder: (BuildContext context) {
              return ListScreenAddListPopUpForm(onSave: (String savedName) {
                // Handle the saved name here, if needed
                savedNameFromCreatedList = savedName;
              });
            });

        await cloneContactsToList(savedNameFromCreatedList, ref);
      }

      if (value == 2) {
        String selectedContactPhoneNumber =
            ref.read(selectedContact.notifier).state;

        ref.read(isSelectable.notifier).state = true;
        print(ref.read(isSelectable.notifier).state);
      }
    });
  }
}

Future<void> cloneContactsToList(String lists, ref) async {
  final AsyncValue<List<ContactModel>> contactsAsyncValue =
      ref.watch(contactsFromSharedPrefProvider);

  if (contactsAsyncValue is AsyncData) {
    final List<ContactModel> allContacts = contactsAsyncValue.value ?? [];
    final String selectedList = ref.read(selectedListProvider.notifier).state;

    List<ContactModel> existingContacts = allContacts
        .where((contact) => !contact.lists.contains(selectedList))
        .toList();

    List<ContactModel> selectedContacts = allContacts
        .where((contact) => contact.lists.contains(selectedList))
        .toList();

    List<ContactModel> updatedContacts = selectedContacts.map((contact) {
      List<String> updatedLists = [...contact.lists, lists];
      return ContactModel(
        firstName: contact.firstName,
        lastName: contact.lastName,
        email: contact.email,
        phoneNumber: contact.phoneNumber,
        lists: updatedLists,
      );
    }).toList();

    List<ContactModel> allUpdatedContacts = [
      ...existingContacts,
      ...updatedContacts,
    ];

    ref.read(contactsProvider.notifier).state = allUpdatedContacts;

    await saveContactsToSP(allUpdatedContacts);

    allUpdatedContacts.forEach((updatedContact) {
      updateContactsListsToAt(
        ref.read(userStreamProvider).value?.uid,
        '',
        updatedContact.firstName,
        updatedContact.lastName,
        updatedContact.phoneNumber,
        updatedContact.email,
        updatedContact.lists,
        ref.read(userStreamProvider).value?.uid,
      );
    });


    allUpdatedContacts.forEach((updatedContact) {
      print(updatedContact.lists.toString());
      ref.refresh(contactsFromSharedPrefProvider);
      ref.refresh(listFromSharedPrefranceProvider);
      ref.read(listProvider);
    });
  }
}
