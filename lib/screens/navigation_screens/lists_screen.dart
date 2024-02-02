import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tehine/shared/loading.dart';

import '../../api/contacts/airtable/get_contacts.dart';
import '../../models/contact_model.dart';
import '../../providers/contact_providers.dart';
import '../../providers/general_providers.dart';
import '../../providers/list_providers.dart';
import '../../widgets/tiles/contact_tiles/contact_tile_widget.dart';
import '../../widgets/tiles/contact_tiles/select_contact_tile_widget.dart';

class ListsScreen extends ConsumerStatefulWidget {
  ListsScreen({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<ListsScreen> createState() => _ListsScreenState();
}

Future<void> performSearch(String query, ref) async {
// fix search for tehine

  if (ref.watch(selectedListProvider) == 'Tehine') {
    await searchTehineContacts(ref, query);
  }
  if (ref.watch(selectedListProvider) == 'Tehine' && query.isEmpty) {
    ref.read(offsetProvider.notifier).state = '';
    // Maybe show a loading here while its refreshing
    getAllContactsFromAT(ref);
    ref.refresh(filteredContactsProvider);
  }

  // Update the state or filter your contact list based on the search query
  List<ContactModel> searchResults = filterContacts(query, ref);

  // Update the state or provider with the search results
  ref.read(filteredContactsProvider.notifier).state = searchResults;
}

List<ContactModel> filterContacts(String query, ref) {
  if (query.isEmpty) {
    // ref.read(offsetProvider.notifier).state = '';
    // getAllContactsFromAT(ref);
    // If the query is empty, return all contacts
    return ref.read(filteredContactsProvider);
  }
  // Filter contacts based on the search query
  return ref
      .read(filteredContactsProvider)
      .where((contact) =>
              contact.firstName.toLowerCase().contains(query.toLowerCase()) ||
              contact.lastName.toLowerCase().contains(query.toLowerCase()) ||
              // Add additional fields for searching if needed
              contact.phoneNumber.toLowerCase().contains(query.toLowerCase())
          // contact.email.toLowerCase().contains(query.toLowerCase()) ||
          )
      .toList();
}

class _ListsScreenState extends ConsumerState<ListsScreen> {
  final ScrollController _scrollController = ScrollController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8, left: 8, bottom: 8),
              child: TextFormField(
                onChanged: (query) {
                  print("onChanged: $query");
                  // Handle search query changes

                  performSearch(query, ref);
                  ref.read(filteredContactsProvider.notifier);
                  if (query.isEmpty) {
                    // If the query is empty, reset the list of filtered contacts

                    ref.read(filteredContactsProvider.notifier).state =
                        ref.read(contactsProvider);
                  }
                },
                onSaved: (query) {
                  // Perform search when the user removes a letter (backspace)
                  performSearch(query!, ref);
                },
                onFieldSubmitted: (query) => performSearch(query, ref),
                // cursorColor: Theme.of(context).colorScheme.background,
                cursorColor: Colors.grey[850],
                decoration: InputDecoration(
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.background,
                    ),
                  ),
                  hintText: 'Search ${ref.read(selectedListProvider)}',
                  hintStyle: TextStyle(color: Colors.grey[850]),
                  fillColor: Colors.grey[350],
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                      color: Colors.grey[350] ?? Colors.grey,
                      width: 3.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                      color: Colors.grey[350] ?? Colors.grey,
                      width: 3.0,
                    ),
                  ),
                  errorStyle: TextStyle(
                    color: Colors.grey[350],
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                      color: Colors.grey[350] ?? Colors.grey,
                      width: 3.0,
                    ),
                  ),
                ),
                style: TextStyle(color: Colors.grey[850]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5.0, top: 8),
              child: SizedBox(
                height: 50, // specify the desired height,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    for (int index = 0;
                        index < ref.watch(listProvider).length;
                        index++)
                      ChoiceChip(
                        selectedColor: Color(0xFFE6D3B3),
                        backgroundColor: ref.watch(selectedListProvider) ==
                                ref.watch(listProvider)[index]
                            ? Color(0xFFE6D3B3)
                            : Color(0xFFF5F5F5),
                        label: Text(
                          ref.watch(listProvider)[index],
                          style: TextStyle(
                            color: ref.watch(selectedListProvider) ==
                                    ref.watch(listProvider)[index]
                                ? Colors.grey[850]
                                : Colors.grey[850],
                          ),
                        ),
                        selected: ref.watch(selectedListProvider) ==
                            (ref.watch(listProvider)[index] == -1
                                ? ref.watch(listProvider).first
                                : ref.watch(listProvider)[index]),
                        onSelected: (selected) async {
                          if (selected) {
                            ref.read(selectedListProvider.notifier).state =
                                ref.watch(listProvider)[index];
                            ref
                                .watch(
                                    selectedListScreenChipIndexProvider.state)
                                .state = index;
                            print(ref.read(selectedListProvider));
                          }
                          if (ref.watch(selectedListProvider) == 'Tehine') {
                            // await getAllContactsFromAT(ref);
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return Center(
                                  child: LoadingTransparent(),
                                );
                              },
                            );
                            try {
                              // Await the getAllContactsFromAT function
                              // ref
                              //     .read(filteredContactsProvider.notifier)
                              //     .state = [];
                              await getAllContactsFromAT(ref);
                            } finally {
                              // Close loading indicator
                              Navigator.of(context).pop();
                            }

                            print('Tehine selected');
                          } else {
                            ref.read(offsetProvider.notifier).state = '';
                          }
                        },
                      ),
                    SizedBox(width: 7),
                  ],
                ),
              ),
            ),
            Consumer(
              builder: (context, watch, child) {
                final filteredContacts = ref.watch(filteredContactsProvider);
                List<Widget> contactWidgets = [];

                for (int index = 0; index < filteredContacts.length; index++) {
                  ContactModel contact = filteredContacts[index];
                  var contactWidget;
                  if (ref.watch(isSelectable.notifier).state == true) {
                    contactWidget = Hero(
                      tag: 'contactHeroTag_${contact.phoneNumber}',
                      child: SelectContactTileWidget(
                        contact: contact,
                      ),
                    );
                    print(contactWidget.toString());
                  } else {
                    contactWidget = ContactTileWidget(contact: contact);
                  }

                  contactWidgets.add(Padding(
                    padding: const EdgeInsets.only(
                      top: 6,
                      bottom: 6,
                    ),
                    child: contactWidget,
                  ));
                }

                return Column(
                  children: [
                    SizedBox(height: 10),
                    Listener(
                      onPointerMove: (event) async {
                        if (ref.watch(selectedListProvider) == 'Tehine' &&
                            _scrollController.position.pixels ==
                                _scrollController.position.maxScrollExtent) {
                          // User reached the bottom, trigger refresh
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return Center(
                                child: LoadingTransparent(),
                              );
                            },
                          );
                          try {
                            // Await the getAllContactsFromAT function
                            await getAllContactsFromAT(ref);
                          } finally {
                            // Close loading indicator
                            Navigator.of(context).pop();
                          }
                          // await getAllContactsFromAT(ref);
                          // ref.refresh(filteredContactsProvider);
                        }
                      },
                      child: ListView.builder(
                        key: ValueKey(ref.watch(isSelectable)),
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: filteredContacts.length,
                        itemBuilder: (BuildContext context, int index) {
                          return contactWidgets[index];
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import '../../api/contacts/airtable/get_contacts.dart';
// import '../../models/contact_model.dart';
// import '../../providers/contact_providers.dart';
// import '../../providers/general_providers.dart';
// import '../../providers/list_providers.dart';
// import '../../widgets/tiles/contact_tiles/contact_tile_widget.dart';
// import '../../widgets/tiles/contact_tiles/select_contact_tile_widget.dart';

// class ListsScreen extends ConsumerStatefulWidget {
//   ListsScreen({
//     Key? key,
//   }) : super(key: key);

//   @override
//   ConsumerState<ListsScreen> createState() => _ListsScreenState();
// }

// void performSearch(String query, ref) {
//   // Update the state or filter your contact list based on the search query
//   List<ContactModel> searchResults = filterContacts(query, ref);

//   // Update the state or provider with the search results
//   ref.read(filteredContactsProvider.notifier).state = searchResults;
// }

// List<ContactModel> filterContacts(String query, ref) {
//   if (query.isEmpty) {
//     // If the query is empty, return all contacts
//     return ref.read(filteredContactsProvider);
//   }
//   // Filter contacts based on the search query
//   return ref
//       .read(filteredContactsProvider)
//       .where((contact) =>
//               contact.firstName.toLowerCase().contains(query.toLowerCase()) ||
//               contact.lastName.toLowerCase().contains(query.toLowerCase()) ||
//               // Add additional fields for searching if needed
//               contact.phoneNumber.toLowerCase().contains(query.toLowerCase())
//           // contact.email.toLowerCase().contains(query.toLowerCase()) ||
//           )
//       .toList();
// }

// class _ListsScreenState extends ConsumerState<ListsScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFFF5F5F5),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(right: 8, left: 8, bottom: 8),
//               child: TextFormField(
//                 onChanged: (query) {
//                   print("onChanged: $query");
//                   // Handle search query changes
//                   performSearch(query, ref);
//                   ref.read(filteredContactsProvider.notifier);
//                   if (query.isEmpty) {
//                     // If the query is empty, reset the list of filtered contacts
//                     ref.read(filteredContactsProvider.notifier).state =
//                         ref.read(contactsProvider);
//                   }
//                 },
//                 onSaved: (query) {
//                   // Perform search when the user removes a letter (backspace)
//                   performSearch(query!, ref);
//                 },
//                 onFieldSubmitted: (query) => performSearch(query, ref),
//                 // cursorColor: Theme.of(context).colorScheme.background,
//                 cursorColor: Colors.grey[850],
//                 decoration: InputDecoration(
//                   focusedErrorBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(20),
//                     borderSide: BorderSide(
//                       color: Theme.of(context).colorScheme.background,
//                     ),
//                   ),
//                   hintText: 'Search ${ref.read(selectedListProvider)}',
//                   hintStyle: TextStyle(color: Colors.grey[850]),
//                   fillColor: Color(0xFFF5F5F5),
//                   filled: true,
//                   enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(20),
//                     borderSide: BorderSide(
//                       color: Colors.grey[850] ?? Colors.grey,
//                       width: 3.0,
//                     ),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(20),
//                     borderSide: BorderSide(
//                       color: Colors.grey[850] ?? Colors.grey,
//                       width: 3.0,
//                     ),
//                   ),
//                   errorStyle: TextStyle(
//                     color: Colors.grey[850],
//                   ),
//                   errorBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(20),
//                     borderSide: BorderSide(
//                       color: Colors.grey[850] ?? Colors.grey,
//                       width: 3.0,
//                     ),
//                   ),
//                 ),
//                 style: TextStyle(color: Colors.grey[850]),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(left: 5.0),
//               child: SingleChildScrollView(
//                 clipBehavior: Clip.none,
//                 scrollDirection: Axis.horizontal,
//                 child: Row(
//                   children: [
//                     for (int index = 0;
//                         index < ref.watch(listProvider).length;
//                         index++)
//                       ChoiceChip(
//                         selectedColor: Color(0xFFE6D3B3),
//                         backgroundColor: ref.watch(selectedListProvider) ==
//                                 ref.watch(listProvider)[index]
//                             ? Color(0xFFE6D3B3)
//                             : Color(0xFFF5F5F5),
//                         label: Text(
//                           ref.watch(listProvider)[index],
//                           style: TextStyle(
//                             color: ref.watch(selectedListProvider) ==
//                                     ref.watch(listProvider)[index]
//                                 ? Colors.grey[850]
//                                 : Colors.grey[850],
//                           ),
//                         ),
//                         selected: ref.watch(selectedListProvider) ==
//                             (ref.watch(listProvider)[index] == -1
//                                 ? ref.watch(listProvider).first
//                                 : ref.watch(listProvider)[index]),
//                         onSelected: (selected) async {
//                           if (selected) {
//                             ref.read(selectedListProvider.notifier).state =
//                                 ref.watch(listProvider)[index];
//                             ref
//                                 .watch(
//                                     selectedListScreenChipIndexProvider.state)
//                                 .state = index;
//                             print(ref.read(selectedListProvider));
//                           }
//                           if (ref.watch(selectedListProvider) == 'Tehine') {
//                             await getAllContactsFromAT(ref);
//                             print('tehine selected');
//                           }
//                         },
//                       ),
//                     SizedBox(width: 7),
//                   ],
//                 ),
//               ),
//             ),
//             Consumer(
//               builder: (context, watch, child) {
//                 final filteredContacts = ref.watch(filteredContactsProvider);
//                 List<Widget> contactWidgets = [];

//                 for (int index = 0; index < filteredContacts.length; index++) {
//                   ContactModel contact = filteredContacts[index];
//                   var contactWidget;
//                   if (ref.watch(isSelectable.notifier).state == true) {
//                     contactWidget = Hero(
//                       tag: 'contactHeroTag_${contact.phoneNumber}',
//                       child: SelectContactTileWidget(
//                         contact: contact,
//                       ),
//                     );
//                   } else {
//                     contactWidget = ContactTileWidget(contact: contact);
//                   }

//                   contactWidgets.add(Padding(
//                     padding: const EdgeInsets.only(
//                       top: 6,
//                       bottom: 6,
//                     ),
//                     child: contactWidget,
//                   ));
//                 }

//                 return Column(
//                   children: [
//                     SizedBox(height: 10),
//                     ListView.builder(
//                       key: ValueKey(ref.watch(isSelectable)),
//                       physics: NeverScrollableScrollPhysics(),
//                       shrinkWrap: true,
//                       itemCount: filteredContacts.length,
//                       itemBuilder: (BuildContext context, int index) {
//                         return contactWidgets[index];
//                       },
//                     ),
//                   ],
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
