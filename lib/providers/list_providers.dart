import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/contacts/shared_preferences/get_contact_from_shared_preferences.dart';
import '../api/contacts/shared_preferences/save_contacts_to_shared_preferences.dart';
import '../api/events/shared_preferences/get_event_from_shared_preference.dart';
import 'event_providers.dart';

final selectedListProvider = StateProvider<String>(
  (ref) => 'All',
);

// List<PopupMenuEntry<dynamic>> listScreenAddMenuList = [
//   PopupMenuItem(
//     child: Text('My List'),
//     value: 1,
//   ),
//   PopupMenuItem(
//     child: Text('All Tehine'),
//     value: 2,
//   ),
// ];

final listScreenAddMenuProvider = Provider<List<PopupMenuEntry<dynamic>>>(
  (ref) => [
    PopupMenuItem(
      child: Text('Create List'),
      value: 1,
    ),
    PopupMenuItem(
      child: Text('Add Contact'),
      value: 2,
    ),
    PopupMenuItem(
      child: Text('Import Contacts From Device'),
      value: 2,
    ),
    PopupMenuItem(
      child: Text('Import Contacts From CSV File'),
      value: 2,
    ),
  ],
);

final listFromSharedPreferenceProvider = FutureProvider<List<String>>(
  (ref) async {
    return await loadListsFromSP() ??
        [
          'Tehine',
          'All',
          'Wedding List',
          "Shmuel's Bar Mitzvah",
          'Engagement',
        ];
  },
);

final listProvider = StateProvider<List<String>>((ref) {
  final futureList = ref.watch(listFromSharedPreferenceProvider);
  return futureList.value ?? [];
});

// This function loads lists from events from shared preference

final eventListFromSharedPreferenceProvider = FutureProvider<List<String>>(
  (ref) async {
    return await loadEventListsFromSP(ref.read(selectedEventNameProvider)) ?? [];
  },
);

final eventListProvider = StateProvider<List<String>>((ref) {
  final futureList = ref.watch(eventListFromSharedPreferenceProvider);
  return futureList.value ?? [];
});


