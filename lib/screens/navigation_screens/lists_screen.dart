import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tehine/shared/loading.dart';

import '../../backend/api/contacts/airtable/get_contacts.dart';
import '../../models/contact_model.dart';
import '../../providers/contact_providers.dart';
import '../../providers/general_providers.dart';
import '../../providers/list_providers.dart';
import '../../shared/style.dart';
import '../../widgets/tiles/contact_tiles/contact_tile_widget.dart';
import '../../widgets/tiles/contact_tiles/select_contact_tile_widget.dart';

class ListsScreen extends ConsumerStatefulWidget {
  ListsScreen({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<ListsScreen> createState() => _ListsScreenState();
}

class _ListsScreenState extends ConsumerState<ListsScreen> {
  final ScrollController _scrollController = ScrollController();
  bool isLoading = false;
  bool isScrolling = false;

  @override
  void initState() {
    super.initState();
    /*
    The following is called to check if there is any contacts on device
    if not it will call a function to check airtable and download contacts
    */
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (ref.watch(contactsProviderCheck).isEmpty) {
        await initializeChip();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: creamWhite,
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8, left: 8, bottom: 8),
              child: TextFormField(
                // onTap: () {
                //   FocusScope.of(context).dispose();
                // },
                enabled: !isScrolling,
                textInputAction: TextInputAction.done,
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
                cursorColor: darkGrey,
                decoration: InputDecoration(
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                      // Have to fix this
                      color: Theme.of(context).colorScheme.background,
                    ),
                  ),
                  hintText: 'Search ${ref.read(selectedListProvider)}',
                  hintStyle: TextStyle(color: darkGrey),
                  fillColor: lightGrey,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                      color: lightGrey,
                      width: 3.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                      color: lightGrey,
                      width: 3.0,
                    ),
                  ),
                  errorStyle: TextStyle(
                    color: lightGrey,
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                      color: lightGrey,
                      width: 3.0,
                    ),
                  ),
                ),
                style: TextStyle(color: darkGrey),
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
                      Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: ChoiceChip(
                          selectedColor: darkGrey,
                          // selectedColor: Color(0xFFE6D3B3),
                          backgroundColor: ref.watch(selectedListProvider) ==
                                  ref.watch(listProvider)[index]
                              ? darkGrey
                              : lightGrey,
                          // : creamWhite,
                          // ? Color(0xFFE6D3B3)
                          // : Color(0xFFF5F5F5),
                          label: Text(
                            ref.watch(listProvider)[index],
                            style: TextStyle(
                              color: ref.watch(selectedListProvider) ==
                                      ref.watch(listProvider)[index]
                                  ? creamWhite
                                  : darkGrey,
                              // ? Colors.grey[850]
                              // : Colors.grey[850],
                            ),
                          ),
                          selected: ref.watch(selectedListProvider) ==
                              (ref.watch(listProvider)[index] == -1
                                  ? ref.watch(listProvider).first
                                  : ref.watch(listProvider)[index]),
                          onSelected: (selected) async {
                            // if (selected == 'All'){

                            // }else
                            await selectedChip(index, selected);
                          },
                        ),
                      ),
                    const SizedBox(width: 7),
                  ],
                ),
              ),
            ),
            regularConsumer()
          ],
        ),
      ),
    );
  }

  Widget regularConsumer() {
    return Consumer(
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
                loadMore();
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
    );
  }

  

// Function for search
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
      return ref.read(filteredContactsProvider);
    } else {
      List<ContactModel> searchResults = filterContacts(query, ref);

      ref.read(filteredContactsProvider.notifier).state = searchResults;
    }
  }

  List<ContactModel> filterContacts(String query, ref) {
    if (query.isEmpty) {
      return ref.read(filteredContactsProvider);
    }
    return ref
        .read(filteredContactsProvider)
        .where((contact) =>
            contact.firstName.toLowerCase().contains(query.toLowerCase()) ||
            contact.lastName.toLowerCase().contains(query.toLowerCase()) ||
            contact.phoneNumber.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  Future<void> finishedSearching() async {
    _scrollController.position.pixels ==
        _scrollController.position.isScrollingNotifier;
    isScrolling = true;
    print(isScrolling);
    // print('scrolling is true');
  }

  Future<void> loadMore() async {
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
  }

// Function for selecting chip
  Future<void> selectedChip(index, selected) async {
    // print('onselected runing');
    // Reset
    ref.read(contactsProvider.notifier).state = [];
    // Refresh
    ref.refresh(contactsFromSharedPrefProvider);
    // Filter
    ref.read(filteredContactsProvider);

    if (selected) {
      ref.read(selectedListProvider.notifier).state =    
      ref.watch(listProvider)[index];
      ref.watch(selectedListScreenChipIndexProvider.state).state = index;
      print(ref.read(selectedListProvider));
    }

    if (ref.watch(contactsProvider).isEmpty) {
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
        await getAllContactsDataFromAtOnStart(context);
      } finally {
        Navigator.of(context).pop();
      }
    }

    if (ref.watch(selectedListProvider) == 'Tehine') {
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
        await getAllContactsFromAT(ref);
      } finally {
        Navigator.of(context).pop();
      }
    } else {
      ref.read(offsetProvider.notifier).state = '';
    }
  }

// Function for default chip (All)
  Future<void> initializeChip() async {
    // Reset
    // ref.read(contactsProvider.notifier).state = [];
    // // Refresh
    // ref.refresh(contactsFromSharedPrefProvider);
    // // Filter
    // ref.read(filteredContactsProvider);

    ref.read(selectedListProvider.notifier).state = 'All';
    ref.watch(selectedListScreenChipIndexProvider.state).state = 1;
    print(ref.read(selectedListProvider));

    if (ref.watch(contactsProvider).isEmpty) {
      // Refresh
      ref.refresh(contactsFromSharedPrefProvider);
      // Filter
      ref.read(filteredContactsProvider);
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
        await getAllContactsDataFromAtOnStart(context);
      } finally {
        Navigator.of(context).pop();
      }
    }

    if (ref.watch(selectedListProvider) == 'Tehine') {
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
        await getAllContactsFromAT(ref);
      } finally {
        Navigator.of(context).pop();
      }
    } else {
      ref.read(offsetProvider.notifier).state = '';
    }
  }
}
