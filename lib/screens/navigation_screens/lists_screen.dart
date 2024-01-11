import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/contact_model.dart';
import '../../providers/contact_provider.dart';
import '../../providers/list_provider.dart';
import '../../widgets/tiles/contact_tiles/contact_tile_widget.dart';
import '../../widgets/tiles/contact_tiles/select_contact_tile_widget.dart';

final selectedListScreenChipIndexProvider = StateProvider<int>((ref) => 0);

class ListsScreen extends ConsumerStatefulWidget {
  ListsScreen({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<ListsScreen> createState() => _ListsScreenState();
}

class _ListsScreenState extends ConsumerState<ListsScreen> {
  @override
  Widget build(BuildContext context) {
    print(
        'Widget rebuilt. isSelectable: ${ref.watch(isSelectable.notifier).state}');
    final contactsList = ref.watch(contactsProvider);
    contactsList.forEach((contact) {
      print('${contact.firstName} ${contact.lastName} ${contact.lists}');
    });
    final selectedChipIndex =
        ref.watch(listProvider).indexOf(ref.watch(selectedListProvider));

    List<ContactModel> filteredContacts = ref
        .read(contactsProvider)
        .where((contact) =>
            contact.lists.contains('All') &&
            contact.lists.contains(ref.watch(listProvider)[selectedChipIndex]))
        .toList();

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
        // SelectContactTileWidget(
        //   contact: contact,
        //   isChecked: true,
        // );
      } else {
        contactWidget = ContactTileWidget(contact: contact);
      }
      bool isChecked = false;

      contactWidgets.add(Padding(
        padding: const EdgeInsets.only(top: 6, bottom: 6,),
        child: contactWidget,
      ));
    }
    print('in list screen ${ref.read(isSelectable.notifier).state}');

    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      body: SingleChildScrollView(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8, left: 8, bottom: 8),
            child: TextFormField(
              cursorColor: Theme.of(context).colorScheme.background,
              decoration: InputDecoration(
                focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.background,
                    )),
                hintText: 'Search ${ref.read(selectedListProvider)}',
                hintStyle: TextStyle(color: Colors.grey[850]),
                fillColor: Color(0xFFF5F5F5),
                filled: true,
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                        color: Colors.grey[850] ?? Colors.grey, width: 3.0)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                        color: Colors.grey[850] ?? Colors.grey, width: 3.0)),
                errorStyle: TextStyle(
                  color: Colors.grey[850],
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                      color: Colors.grey[850] ?? Colors.grey, width: 3.0),
                ),
              ),
              style: TextStyle(color: Colors.grey[850]),
              // validator: (val) =>
              //     val!.isEmpty ? 'Enter Name' : null,
              // onChanged: (val) {
              //   {
              //     // setState(() => name = val);
              //     // setState(() {
              //     //   // globals.tempuesname = name;
              //     // });
              //   }
              // },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: SingleChildScrollView(
              clipBehavior: Clip.none,
              scrollDirection: Axis.horizontal,
              child: Row(
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
                          ref.watch(listProvider)[index],
                      onSelected: (selected) {
                        if (selected) {
                          ref.read(selectedListProvider.notifier).state =
                              ref.watch(listProvider)[index];
                          ref
                              .watch(selectedListScreenChipIndexProvider.state)
                              .state = index;
                          print(ref.read(selectedListProvider));
                        }
                      },
                    ),
                  SizedBox(width: 7),
                ],
              ),
            ),
          ),
          Column(
            children: [
              SizedBox(height: 10),
              ListView.builder(
                key: ValueKey(ref.watch(isSelectable)),
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: filteredContacts.length,
                itemBuilder: (BuildContext context, int index) {
                  return AnimatedSwitcher(
                    key: ValueKey<bool>(ref.watch(isSelectable.notifier).state),
                    duration: Duration(milliseconds: 1000),
                    child: contactWidgets[index],
                    transitionBuilder: (child, animation) {
                      return ScaleTransition(
                        scale: animation,
                        child: child,
                      );
                    },
                  );
                },
              )
            ],
          )
        ],
      )),
    );
  }
}

// AnimatedSwitcher(
//                     duration: Duration(milliseconds: 1000),
//                     child: ref.watch(isSelectable)
//                         ? ListView.builder(
//                             physics: NeverScrollableScrollPhysics(),
//                             shrinkWrap: true,
//                             itemCount: filteredContacts.length,
//                             itemBuilder: (BuildContext context, int index) {
//                               ContactModel contact = filteredContacts[index];
//                               bool isChecked =
//                                   false; // Declare isChecked for each contact

//                               return Row(
//                                 children: [
//                                   Checkbox(
//                                     checkColor: Colors.white,
//                                     fillColor:
//                                         MaterialStateProperty.resolveWith(
//                                             getColor),
//                                     value: isChecked,
//                                     onChanged: (bool? value) {
//                                       setState(() {
//                                         ref
//                                             .read(selectedContact.notifier)
//                                             .state = contact.phoneNumber;
//                                         isChecked = value!;
//                                       });
//                                     },
//                                   ),
//                                   Hero(
//                                     tag:
//                                         'contactHeroTag_${contact.phoneNumber}',
//                                     child: Padding(
//                                       padding: const EdgeInsets.only(
//                                           top: 6, bottom: 6, right: 8, left: 8),
//                                       child: SelectContactTileWidget(
//                                         contact: contact,
//                                         isChecked: isChecked,
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               );
//                             },
//                           )
//                         : ListView.builder(
//                             physics: NeverScrollableScrollPhysics(),
//                             shrinkWrap: true,
//                             itemCount: filteredContacts.length,
//                             itemBuilder: (BuildContext context, int index) {
//                               ContactModel contact = filteredContacts[index];

//                               return Hero(
//                                 tag:
//                                     'contactHeroTag_${contact.phoneNumber}', // Unique tag for each contact
//                                 child: Padding(
//                                   padding: const EdgeInsets.only(
//                                       top: 6, bottom: 6, right: 8, left: 8),
//                                   child: ContactTileWidget(contact: contact),
//                                 ),
//                               );
//                             },
//                           ))
