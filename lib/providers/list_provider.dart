import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'load_data_from_device_on_start.dart';

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

final listScreenAddMenuProvider =
    Provider<List<PopupMenuEntry<dynamic>>>((ref) => [
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
        ]);

        

final listFromSharedPrefranceProvider = FutureProvider<List<String>>(
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
  final futureList = ref.watch(listFromSharedPrefranceProvider);
  return futureList.value ?? [];
});
