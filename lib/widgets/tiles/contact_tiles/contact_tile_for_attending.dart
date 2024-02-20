import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../backend/api/contacts/airtable/upload_contacts.dart';
import '../../../models/contact_model.dart';

import '../../../providers/contact_providers.dart';
import '../../../backend/api/contacts/shared_preferences/save_contacts_to_shared_preferences.dart';
import '../../../providers/user_providers.dart';

import '../../../screens/expanded_screens/contact_expanded_screen.dart';

class ContactTileForAttendingWidget extends ConsumerStatefulWidget {
  // final ContactModel contact;
  final String contactName;
  late Offset tapPosition = Offset.zero;

  ContactTileForAttendingWidget(
      {Key? key,
      // required this.contact,
      required this.contactName})
      : super(key: key);

  @override
  ConsumerState<ContactTileForAttendingWidget> createState() =>
      _ContactTileForAttendingWidgetState();
}

class _ContactTileForAttendingWidgetState
    extends ConsumerState<ContactTileForAttendingWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onTap: () {
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) {
      //         return ContactExpandedScreenWidget(
      //             contact: widget
      //                 .contact); // Replace YourNextScreen with the actual widget for the next screen
      //       },
      //     ),
      //   );
      // },
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 25, left: 20, bottom: 10),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            child: Text(
                              widget.contactName,
                              style: TextStyle(
                                color: Colors.grey[850],
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: 12,
                          left: 20,
                        ),
                      )
                    ],
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
    );
  }
}
