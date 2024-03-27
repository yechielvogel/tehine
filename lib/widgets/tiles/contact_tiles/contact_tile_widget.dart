import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tehine/providers/list_providers.dart';

import '../../../backend/api/contacts/airtable/upload_contacts.dart';
import '../../../models/contact_model.dart';

import '../../../providers/contact_providers.dart';
import '../../../backend/api/contacts/shared_preferences/save_contacts_to_shared_preferences.dart';
import '../../../providers/user_providers.dart';

import '../../../screens/expanded_screens/contact_expanded_screen.dart';
import '../../../shared/style.dart';
import '../../dividers/divider_horizontal.dart';
import '../../menus/list_menus/contact_tile_ellips_menu.dart';

class ContactTileWidget extends ConsumerStatefulWidget {
  final ContactModel contact;
  late Offset tapPosition = Offset.zero;

  ContactTileWidget({
    Key? key,
    required this.contact,
  }) : super(key: key);

  @override
  ConsumerState<ContactTileWidget> createState() => _ContactTileWidgetState();
}

class _ContactTileWidgetState extends ConsumerState<ContactTileWidget> {
  @override
  Widget build(BuildContext context) {
    List<ContactModel> contactToDelete = [];
    contactToDelete.add(widget.contact);
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

          child: ref.watch(selectedListProvider) != 'Tehine'
              ? Dismissible(
                  direction: DismissDirection.endToStart,
                  key: Key(widget.contact.firstName),
                  onDismissed: (direction) async {
                    if (direction == DismissDirection.endToStart) {
                      await deleteContactsFromUserAccountToAt(
                          ref.read(userStreamProvider).value!.uid,
                          widget.contact.firstName,
                          widget.contact.lastName,
                          widget.contact.phoneNumber,
                          widget.contact.email,
                          widget.contact.lists,
                          '');
                      await deleteContactFromSP(widget.contact);
                      ref.refresh(contactsFromSharedPrefProvider);
                      ref.read(contactsProvider);
                    }
                  },
                  background: Container(
                    alignment: Alignment.centerRight,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(0),
                      color: Colors.red,
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(right: 20),
                      child: Icon(
                        Icons.delete,
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
                )
              : Padding(
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
    );
  }
}
