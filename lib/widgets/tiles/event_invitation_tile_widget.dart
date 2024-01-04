import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../dividers/divider_horizontal.dart';
import '../dividers/divider_vertical.dart';

class EventInvitationTileWidget extends ConsumerStatefulWidget {
  EventInvitationTileWidget({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<EventInvitationTileWidget> createState() =>
      _EventInvitationTileWidgetState();
}

String name = '';
// int time = 0;
String time = '';
String eventDate = '';
String address = '';
String address2 = '';
String country = '';
String state = '';
String zip_postalCode = '';

class _EventInvitationTileWidgetState
    extends ConsumerState<EventInvitationTileWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 150,
        width: 380,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: Color(0xFFE6D3B3)),
        child: Column(
          children: [
            Row(
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Container(
                              child: Icon(
                            Icons.card_giftcard,
                            size: 40,
                            color: Colors.grey[850],
                          )),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Container(
                              child: Text(
                            "Ari & Leah's Wedding",
                            style: TextStyle(
                                color: Colors.grey[850],
                                fontWeight: FontWeight.bold,
                                fontSize: 25),
                          )),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            )
          ],
        ));
  }
}
