import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../backend/api/contacts/airtable/upload_contacts.dart';
import '../../../models/contact_model.dart';
import '../../../providers/contact_providers.dart';

import '../../../backend/api/contacts/shared_preferences/save_contacts_to_shared_preferences.dart';
import '../../../providers/user_providers.dart';
import '../../../shared/style.dart';

class SelectContactTileWidget extends ConsumerStatefulWidget {
  final ContactModel contact;

  late Offset tapPosition = Offset.zero;

  SelectContactTileWidget({Key? key, required this.contact}) : super(key: key);

  @override
  ConsumerState<SelectContactTileWidget> createState() =>
      _SelectContactTileWidgetState();
}

class _SelectContactTileWidgetState
    extends ConsumerState<SelectContactTileWidget> {
  @override
  Widget build(BuildContext context) {
    List<ContactModel> localSelectedContacts =
        ref.watch(selectedContacts.notifier).state;
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.grey[850] ?? Colors.grey;
    }

    return GestureDetector(
      onTap: () {
        // Handle tap to check/uncheck checkbox
        bool isChecked = ref.read(selectedContacts).contains(widget.contact);
        setState(() {
          if (!isChecked) {
            // If checkbox is unchecked, check it
            ref.read(selectedContacts).add(widget.contact);
            print(ref.read(selectedContacts).length);
          } else {
            // If checkbox is checked, uncheck it
            ref.read(selectedContacts).remove(widget.contact);
          }
          ref.read(selectedContact.notifier).state = widget.contact.phoneNumber;
        });
      },
      child: Row(children: [
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Checkbox(
            shape: CircleBorder(),
            checkColor: seaSault,
            fillColor: MaterialStateProperty.resolveWith(getColor),
            value: ref.read(selectedContacts).contains(widget.contact),
            onChanged: (bool? value) {
              setState(() {
                if (value!) {
                  // If checkbox is checked, add contact to the list
                  ref.read(selectedContacts).add(widget.contact);
                  print(ref.read(selectedContacts).length);
                } else {
                  // If checkbox is unchecked, remove contact from the list
                  ref.read(selectedContacts).remove(widget.contact);
                }
                ref.read(selectedContact.notifier).state =
                    widget.contact.phoneNumber;
              });
            },
          ),
        ),
        Expanded(
          // Wrap the Container with Expanded
          child: GestureDetector(
            onLongPress: () {
              // Handle long press
              // contactTileEllipsisMenu(context, ref, widget.contact);
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 8, right: 8, left: 8),
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    // BoxShadow(
                    //   color: Colors.grey.withOpacity(0.5),
                    //   spreadRadius: 5,
                    //   blurRadius: 3,
                    //   offset: Offset(0, 4),
                    // ),
                  ],
                  color: seaSault,
                ),

                // Changed this line in dismissible.
                // clipper: _DismissibleClipper(
                //   axis: _directionIsXAxis ? Axis.horizontal : Axis.vertical,
                //   moveAnimation: _moveAnimation,
                // ),
                child: Container(
                  decoration: BoxDecoration(
                    // boxShadow: [
                    //   BoxShadow(
                    //     color: Colors.grey.withOpacity(0.5),
                    //     spreadRadius: 2,
                    //     blurRadius: 3,
                    //     offset: Offset(0, 3),
                    //   ),
                    // ],
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
                            // SizedBox(
                            //   height: 3,
                            // ),
                            Padding(
                              padding: const EdgeInsets.only(
                                // bottom: 12,
                                left: 20,
                              ),
                              child: Container(
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
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          right: 8.0,
                        ),
                        child: SizedBox(
                          width: 30,
                          height: 30,
                          child: InkWell(
                            onTapDown: (TapDownDetails details) {
                              setState(() {
                                widget.tapPosition = details.globalPosition;
                              });
                              print('tap position${widget.tapPosition}');
                            },
                            // child: Container(
                            //   width: 25,
                            //   height: 25,
                            //   decoration: BoxDecoration(
                            //     shape: BoxShape.circle,
                            //     color: Colors.grey[850],
                            //   ),
                            //   child: IconButton(
                            //     icon: Icon(
                            //       CupertinoIcons.ellipsis,
                            //       color: seaSault,
                            //       size: 15,
                            //     ),
                            //     onPressed: () async {
                            //       contactTileEllipsisMenu(context, ref,
                            //           widget.contact, widget.tapPosition);
                            //       // Handle ellipsis button tap
                            //       // ref.refresh(listFromSharedPrefranceProvider.future);
                            //       // ref.read(listProvider);
                            //     },
                            //   ),
                            // ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
