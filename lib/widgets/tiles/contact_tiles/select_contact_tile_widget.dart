import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../api/contacts/upload_contacts.dart';
import '../../../models/contact_model.dart';
import '../../../providers/contact_provider.dart';

import '../../../providers/load_data_from_device_on_start.dart';
import '../../../providers/user_provider.dart';

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

    return Row(children: [
      Checkbox(
        shape: CircleBorder(),
        checkColor: Color(0xFFF5F5F5),
        fillColor: MaterialStateProperty.resolveWith(getColor),
        value: ref.read(selectedContacts).contains(widget.contact),
        onChanged: (bool? value) {
          setState(() {
            if (value!) {
              // If checkbox is checked, add contact to the list
              //could be a problem
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
      // Hero(
      //   tag: 'contactHeroTag_${widget.contact.phoneNumber}',
      //   child: Padding(
      //     padding: const EdgeInsets.only(top: 6, bottom: 6, right: 8, left: 8),
      //     child: SelectContactTileWidget(
      //       contact: widget.contact,
      //       isChecked: widget.isChecked,
      //     ),
      //   ),
      // ),
      GestureDetector(
        onLongPress: () {
          // contactTileEllipsisMenu(context, ref, widget.contact);
        },
        child: Container(
          width: 338.5,
          decoration: BoxDecoration(
            boxShadow: [
              // BoxShadow(
              //   color: Colors.grey.withOpacity(0.5),
              //   spreadRadius: 5,
              //   blurRadius: 3,
              //   offset: Offset(0, 4),
              // ),
            ],
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
                      //       color: Color(0xFFF5F5F5),
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
    ]);
  }
}
