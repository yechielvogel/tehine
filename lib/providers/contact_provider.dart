import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/contacts/get_contacts.dart';
import '../models/contact_model.dart';
import 'list_provider.dart';
import 'load_data_from_device_on_start.dart';

final contactsFromSharedPrefProvider =
    FutureProvider<List<ContactModel>>((ref) async {
  return await loadContactsFromSP() ?? [];
});

final contactsProvider = StateProvider<List<ContactModel>>((ref) {
  final futureContacts = ref.watch(contactsFromSharedPrefProvider);
  return futureContacts.value ?? [];
});

final selectedContact = StateProvider<String>(
  (ref) => '',
);

// not sure this belongs here should find a better place

final isSelectable = StateProvider<bool>(
  (ref) => false,
);

final selectedContacts = StateProvider<List<ContactModel>>(
  (ref) => [],
);

final filteredContactsProvider = StateProvider<List<ContactModel>>((ref) {
  // ref.refresh(contactsFromSharedPrefProvider);
  final selectedList = ref.watch(selectedListProvider);
  final selectedChipIndex = ref.watch(listProvider).indexOf(selectedList);

  List<ContactModel> contacts = ref.watch(contactsProvider);
  List<ContactModel> filteredContacts = contacts
      .where((contact) =>
          contact.lists.contains('All') &&
          contact.lists.contains(ref.watch(listProvider)[selectedChipIndex]))
      .toList();
  filteredContacts.sort((a, b) => a.lastName.compareTo(b.lastName));

  if (selectedList == 'Tehine') {
    getAllContactsFromAT(ref);
    filteredContacts.sort((a, b) => a.lastName.compareTo(b.lastName));
  }

  return filteredContacts;
});

final contactWidgetsProvider = StateProvider<List<Widget>>((ref) => []);
