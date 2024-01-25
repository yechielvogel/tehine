import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../api/contacts/airtable/upload_contacts.dart';
import '../../../models/contact_model.dart';

import '../../../providers/contact_providers.dart';
import '../../../api/contacts/shared_preferences/save_contacts_to_shared_preferences.dart';
import '../../../providers/user_providers.dart';

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
    return GestureDetector(
      onLongPress: () {},
      child: Padding(
        padding: const EdgeInsets.only(right: 8.0, left: 8.0),
        child: Container(
          // width: 380,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Color(0xFFF5F5F5),
          ),

          // Changed this line in dismissible.
          // clipper: _DismissibleClipper(
          //   axis: _directionIsXAxis ? Axis.horizontal : Axis.vertical,
          //   moveAnimation: _moveAnimation,
          // ),
          child: Dismissible(
            direction: DismissDirection.endToStart,
            key: Key(widget.contact.firstName),
            onDismissed: (direction) async {
              if (direction == DismissDirection.endToStart) {
                deleteContactFromSP(widget.contact);
                deleteContactsFromUserAccountToAt(
                    ref.read(userStreamProvider).value!.uid,
                    widget.contact.firstName,
                    widget.contact.lastName,
                    widget.contact.phoneNumber,
                    widget.contact.email,
                    widget.contact.lists,
                    '');
                ref.refresh(contactsFromSharedPrefProvider);
                ref.read(contactsProvider);
              }
            },
            background: Container(
              alignment: Alignment.centerRight,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
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
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 3,
                    offset: Offset(0, 3),
                  ),
                ],
                borderRadius: BorderRadius.circular(20),
                color: Color(0xFFF5F5F5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Container(
                      child: const Icon(
                        Icons.account_circle_rounded,
                        size: 50,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 15, left: 20, bottom: 35),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
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
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.only(
                  //     right: 8.0,
                  //   ),
                  //   child: SizedBox(
                  //     width: 30,
                  //     height: 30,
                  //     child: InkWell(
                  //       onTapDown: (TapDownDetails details) {
                  //         setState(() {
                  //           widget.tapPosition = details.globalPosition;
                  //         });
                  //         print('tap position${widget.tapPosition}');
                  //       },
                  //       child: Container(
                  //         width: 25,
                  //         height: 25,
                  //         decoration: BoxDecoration(
                  //           shape: BoxShape.circle,
                  //           color: Colors.grey[850],
                  //         ),
                  //         child: IconButton(
                  //           icon: Icon(
                  //             CupertinoIcons.ellipsis,
                  //             color: Colors.white,
                  //             size: 15,
                  //           ),
                  //           onPressed: () async {
                  //             contactTileEllipsisMenu(context, ref,
                  //                 widget.contact, widget.tapPosition);
                  //             // Handle ellipsis button tap
                  //             // ref.refresh(listFromSharedPrefranceProvider.future);
                  //             // ref.read(listProvider);
                  //           },
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
