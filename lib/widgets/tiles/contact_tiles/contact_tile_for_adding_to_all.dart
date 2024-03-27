import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tehine/providers/contact_providers.dart';
import 'package:tehine/providers/list_providers.dart';
import 'package:tehine/providers/user_providers.dart';

import '../../../backend/api/contacts/airtable/upload_contacts.dart';
import '../../../backend/api/contacts/shared_preferences/save_contacts_to_shared_preferences.dart';
import '../../../models/contact_model.dart';
import '../../../screens/expanded_screens/contact_expanded_screen.dart';
import '../../../shared/style.dart';

class ContactTileForAddingToAllWidget extends ConsumerStatefulWidget {
  final String contactName;
  final ContactModel contact;
  late Offset tapPosition = Offset.zero;

  ContactTileForAddingToAllWidget(
      {Key? key,
      // required this.contact,
      required this.contact,
      required this.contactName})
      : super(key: key);

  @override
  ConsumerState<ContactTileForAddingToAllWidget> createState() =>
      _ContactTileForAddingToAllWidgetState();
}

class _ContactTileForAddingToAllWidgetState
    extends ConsumerState<ContactTileForAddingToAllWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return ContactExpandedScreenWidget(contact: widget.contact);
              },
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            // border: Border(
            //   bottom: BorderSide(
            //     color: Colors.black,
            //     width: 0.08,
            //   ),
            // ),
            color: seaSault,
          ),

          // Change this line in dismissible to make it rounded.
          // clipper: _DismissibleClipper(
          //   axis: _directionIsXAxis ? Axis.horizontal : Axis.vertical,
          //   moveAnimation: _moveAnimation,
          // ),
          child: Dismissible(
            direction: DismissDirection.endToStart,
            key: Key(widget.contact.firstName),
            onDismissed: (direction) async {
              if (direction == DismissDirection.endToStart) {
                ref.read(filteredForAddingContacts).remove(widget.contact);
                await addContact(widget.contact);
              }
            },
            background: Container(
              alignment: Alignment.centerRight,
              decoration: BoxDecoration(
                // Maybe change this to a bit more rounded
                borderRadius: BorderRadius.circular(0),
                color: Colors.green[400],
              ),
              child: Padding(
                padding: EdgeInsets.only(right: 20),
                child: Icon(
                  Icons.add,
                  color: Colors.grey[850],
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: seaSault,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Container(
                        child: const Icon(Icons.account_circle_rounded,
                            size: 50, color: Color(0xFFBDBDBD)),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 20,
                            ),
                            child: ClipRRect(
                              child: Container(
                                child: Text(
                                  widget.contact.firstName +
                                      ' ' +
                                      widget.contact.lastName,
                                  style: TextStyle(
                                    color: Colors.grey[850],
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // SizedBox(
                          //   height: 3,
                          // ),
                          Padding(
                            padding: const EdgeInsets.only(
                              // bottom: 12,
                              left: 20,
                            ),
                            child: Container(
                              // height: 15,
                              child: widget.contact.addressStreet != null
                                  ? Text(
                                      widget.contact.addressStreet!,
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 13,
                                      ),
                                    )
                                  : Container(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> addContact(ContactModel contact) async {
    List<ContactModel> allContacts = ref.read(contactsProvider);
    List<ContactModel> processedContacts = allContacts;
    List<String> contactsOriginalList = widget.contact.lists;
    List<String> contactsListsToAdd = ['All'];
    List<String> allLists = contactsOriginalList + contactsListsToAdd;
    processedContacts.add(ContactModel(
      contactRecordID: widget.contact.contactRecordID,
      firstName: widget.contact.firstName,
      lastName: widget.contact.lastName,
      email: widget.contact.email,
      phoneNumber: widget.contact.phoneNumber,
      lists: allLists,
      // add the current list to be added to,
      address: widget.contact.address,
      addressStreet: widget.contact.addressStreet,
      addressCity: widget.contact.addressCity,
      addressState: widget.contact.addressState,
      addressZip: widget.contact.addressZip,
      addressCountry: widget.contact.addressCountry,
    ));
    saveContactsToSP(processedContacts);
    // Still need to test this.
    await uploadContactsToAt(
      null,
      widget.contact.firstName,
      widget.contact.lastName,
      widget.contact.phoneNumber,
      widget.contact.email,
      widget.contact.address,
      widget.contact.addressStreet,
      widget.contact.addressCity,
      widget.contact.addressState,
      widget.contact.addressZip,
      widget.contact.addressCountry,
      // address,
      // contactProfilePic,
      widget.contact.lists,
      ref.read(userStreamProvider).value?.uid,
    );
    await ref.refresh(contactsFromSharedPrefProvider);
  }
}
