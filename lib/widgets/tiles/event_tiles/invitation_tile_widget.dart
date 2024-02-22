import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:tehine/providers/invitations_providers.dart';
import 'package:tehine/providers/user_providers.dart';

import '../../../backend/api/events/airtable/upload_events.dart';
import '../../../models/event_model.dart';
import '../../../providers/general_providers.dart';
import '../../../screens/expanded_screens/invitation_expanded_screen.dart';
import '../../../shared/style.dart';

class EventInvitationTileWidget extends ConsumerStatefulWidget {
  final EventModel event;
  int? invited;
  int? attending;
  int? pending;
  int? notAttending;
  // bool? didAccept;
  late Offset tapPosition = Offset.zero;

  EventInvitationTileWidget({
    Key? key,
    required this.event,
    required this.invited,
    required this.attending,
    required this.pending,
    required this.notAttending,
  }) : super(key: key);

  @override
  ConsumerState<EventInvitationTileWidget> createState() =>
      _EventInvitationTileWidgetState();
}

class _EventInvitationTileWidgetState
    extends ConsumerState<EventInvitationTileWidget> {
  Icon? icon;

  @override
  void initState() {
    super.initState();
    ref.refresh(userFromSharedPrefProvider);
    // WidgetsBinding.instance?.addPostFrameCallback((_) {

    // });
  }

  @override
  Widget build(BuildContext context) {
    String eventIDForProvider =
        '${widget.event.eventRecordID.toString()}${ref.watch(userRecordIDProvider)}';

    getIcon();
    return GestureDetector(
      onTap: () async {
        // print('Event ID ${widget.event.eventRecordID}');
        // ref.read(selectedEventNameProvider.notifier).state =
        //     widget.event.eventName;
        // ref.read(selectedEventProvider.notifier).state = widget.event;
        // // printEventListsFromSP();
        // await ref.refresh(eventListFromSharedPreferenceProvider);

        // await initializeProviders();
        // ref.read(eventListProvider);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return InvitationExpandedScreenWidget(event: widget.event);
            },
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 200,
          width: 380,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Color(0xFFF5F5F5),
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
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 20,
                        left: 20,
                      ),
                      child: Container(
                        child: Text(
                          widget.event.eventName,
                          style: TextStyle(
                              color: Colors.grey[850],
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(
                          top: 20,
                          right: 20,
                        ),
                        child: icon),
                  ],
                ),
                SizedBox(height: 25),
                Row(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 0, left: 20, bottom: 0),
                      child: Container(child: Text(widget.event.eventAddress)),
                    )
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 0, left: 20, bottom: 0),
                      child: Container(
                          child: Text(DateFormat('MM/dd/yyyy').format(
                              DateTime.parse(
                                  widget.event.eventDate.toString())))),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 30),
                  child: Container(
                    child: Row(
                      children: [
                        for (int index = 0; index < chipLabels.length; index++)
                          Container(
                            width: 83,
                            child: ElevatedButton(
                              onPressed: () async {
                                HapticFeedback.heavyImpact();
                                setState(() {
                                  acceptOrDeclineInvitationLogic(index);
                                });
                                // await updateAttendingInProvider(
                                //     widget.event, widget.event.didAccept);
                                ref.read(invitationsProvider);
                              },
                              style: ElevatedButton.styleFrom(
                                side: BorderSide(
                                  color: creamWhite,
                                  width: 1,
                                ),
                                elevation: 0,
                                backgroundColor: ref
                                            .watch(attendingChipProvider(eventIDForProvider
                                                    .toString())
                                                .notifier)
                                            .state ==
                                        index
                                    ? Colors.grey[850]
                                    : lightGrey,
                                shape: RoundedRectangleBorder(
                                  borderRadius: index == 0
                                      ? BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          bottomLeft: Radius.circular(20),
                                        ) as BorderRadiusGeometry
                                      : (index == chipLabels.length - 1
                                          ? BorderRadius.only(
                                              topRight: Radius.circular(20),
                                              bottomRight: Radius.circular(20),
                                            ) as BorderRadiusGeometry
                                          : BorderRadius.zero),
                                ),
                              ),
                              child: Text(
                                chipLabels[index],
                                style: TextStyle(
                                  color: ref
                                              .watch(attendingChipProvider(
                                                      eventIDForProvider
                                                          .toString())
                                                  .notifier)
                                              .state ==
                                          index
                                      ? Color(0xFFF5F5F5)
                                      : Colors.grey[850],
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> acceptOrDeclineInvitationLogic(index) async {
    String eventIDForProvider =
        '${widget.event.eventRecordID.toString()}${ref.watch(userRecordIDProvider)}';

    if (ref
            .watch(attendingChipProvider(eventIDForProvider)
                .notifier)
            .state ==
        index) {
      if (ref
              .watch(
                  attendingChipProvider(eventIDForProvider)
                      .notifier)
              .state ==
          0) {
        unAcceptInvitationToAt(
            widget.event.eventRecordID, ref.read(userRecordIDProvider));
      } else if (ref
              .watch(
                  attendingChipProvider(eventIDForProvider)
                      .notifier)
              .state ==
          1) {
        unDeclineInvitationToAt(
            widget.event.eventRecordID, ref.read(userRecordIDProvider));
      }
      ref
          .watch(attendingChipProvider(eventIDForProvider)
              .notifier)
          .state = null;
      widget.event.didAccept = null;
    } else
      ref
          .watch(attendingChipProvider(eventIDForProvider)
              .notifier)
          .state = index;
    if (ref
            .watch(attendingChipProvider(eventIDForProvider)
                .notifier)
            .state ==
        0) {
      acceptInvitationToAt(
          widget.event.eventRecordID, ref.read(userRecordIDProvider));
      unDeclineInvitationToAt(
          widget.event.eventRecordID, ref.read(userRecordIDProvider));
      widget.event.didAccept = true;
      // Not sure why the below was there.
      // widget.event.didAccept = null;
    } else if (ref
            .watch(attendingChipProvider(eventIDForProvider)
                .notifier)
            .state ==
        1) {
      declineInvitationToAt(
          widget.event.eventRecordID, ref.read(userRecordIDProvider));
      unAcceptInvitationToAt(
          widget.event.eventRecordID, ref.read(userRecordIDProvider));
      widget.event.didAccept = false;
    }
  }

  Future<void> updateAttendingInProvider(
      EventModel event, bool? didAccept) async {
    List<EventModel> tempList = [];
    List<EventModel> events = ref.read(invitationsProvider);
    for (var invitation in ref.read(invitationsProvider)) {
      if (invitation.eventRecordID == event.eventRecordID) {
        EventModel updatedEvent = invitation.copyWith(didAccept: didAccept);
        tempList.add(updatedEvent);
      }
      tempList.add(invitation);
    }
  }

  Future<void> getIcon() async {
    if (widget.event.eventType == 'Wedding') {
      icon = Icon(
        FontAwesomeIcons.gift,
        color: Colors.grey[850],
        size: 24,
      );
    } else if (widget.event.eventType == 'Birthday Party') {
      icon = Icon(
        FontAwesomeIcons.birthdayCake,
        color: Colors.grey[850],
        size: 24,
      );
    } else if (widget.event.eventType == 'Bar Mitzvah') {
      icon = Icon(
        FontAwesomeIcons.moneyBill,
        color: Colors.grey[850],
        size: 24,
      );
    } else if (widget.event.eventType == 'Engagement') {
      icon = Icon(
        FontAwesomeIcons.ring,
        color: Colors.grey[850],
        size: 24,
      );
    }
  }

  Future<void> initializeProviders() async {}
  final List<String> chipLabels = [
    'Accept',
    'Decline',
  ];
}

// accept/decline old chips
// Row(
//                     children: [
//                       for (int index = 0; index < chipLabels.length; index++)
//                         Padding(
//                           padding: const EdgeInsets.only(right: 5),
//                           child: ChoiceChip(
//                             selectedColor: Colors.grey[850],
//                             backgroundColor: ref
//                                         .watch(
//                                             selectedChipIndexForInvitationTileProvider(
//                                                     widget.event.eventRecordID
//                                                         .toString())
//                                                 .notifier)
//                                         .state ==
//                                     index
//                                 ? Colors.grey[850]
//                                 : lightGrey,
//                             // : Color(0xFFF5F5F5),
//                             label: Text(
//                               chipLabels[index],
//                               style: TextStyle(
//                                 color: ref
//                                             .watch(
//                                                 selectedChipIndexForInvitationTileProvider(
//                                                         widget
//                                                             .event.eventRecordID
//                                                             .toString())
//                                                     .notifier)
//                                             .state ==
//                                         index
//                                     ? Color(0xFFF5F5F5)
//                                     : Colors.grey[850],
//                               ),
//                             ),
//                             selected: ref
//                                     .watch(
//                                         selectedChipIndexForInvitationTileProvider(
//                                                 widget.event.eventRecordID
//                                                     .toString())
//                                             .notifier)
//                                     .state ==
//                                 index,
//                             onSelected: (selected) {
//                               HapticFeedback.heavyImpact();

//                               setState(() {
//                                 if (ref
//                                         .watch(
//                                             selectedChipIndexForInvitationTileProvider(
//                                                     widget.event.eventRecordID
//                                                         .toString())
//                                                 .notifier)
//                                         .state ==
//                                     index) {
//                                   if (ref
//                                           .watch(
//                                               selectedChipIndexForInvitationTileProvider(
//                                                       widget.event.eventRecordID
//                                                           .toString())
//                                                   .notifier)
//                                           .state ==
//                                       0) {
//                                     unAcceptInvitationToAt(
//                                         widget.event.eventRecordID,
//                                         ref.read(userRecordIDProvider));
//                                   } else if (ref
//                                           .watch(
//                                               selectedChipIndexForInvitationTileProvider(
//                                                       widget.event.eventRecordID
//                                                           .toString())
//                                                   .notifier)
//                                           .state ==
//                                       1) {
//                                     unDeclineInvitationToAt(
//                                         widget.event.eventRecordID,
//                                         ref.read(userRecordIDProvider));
//                                   }
//                                   ref
//                                       .watch(
//                                           selectedChipIndexForInvitationTileProvider(
//                                                   widget.event.eventRecordID
//                                                       .toString())
//                                               .notifier)
//                                       .state = null;
//                                 } else
//                                   ref
//                                       .watch(
//                                           selectedChipIndexForInvitationTileProvider(
//                                                   widget.event.eventRecordID
//                                                       .toString())
//                                               .notifier)
//                                       .state = index;
//                                 if (ref
//                                         .watch(
//                                             selectedChipIndexForInvitationTileProvider(
//                                                     widget.event.eventRecordID
//                                                         .toString())
//                                                 .notifier)
//                                         .state ==
//                                     0) {
//                                   acceptInvitationToAt(
//                                       widget.event.eventRecordID,
//                                       ref.read(userRecordIDProvider));

//                                   widget.event.didAccept = true;

//                                   unDeclineInvitationToAt(
//                                       widget.event.eventRecordID,
//                                       ref.read(userRecordIDProvider));

//                                   widget.event.didAccept = null;
//                                 } else if (ref
//                                         .watch(
//                                             selectedChipIndexForInvitationTileProvider(
//                                                     widget.event.eventRecordID
//                                                         .toString())
//                                                 .notifier)
//                                         .state ==
//                                     1) {
//                                   declineInvitationToAt(
//                                       widget.event.eventRecordID,
//                                       ref.read(userRecordIDProvider));
//                                   unAcceptInvitationToAt(
//                                       widget.event.eventRecordID,
//                                       ref.read(userRecordIDProvider));

//                                   widget.event.didAccept = false;
//                                 }
//                                 // selectedChipIndex = selected ? 0 : null;
//                               });
//                             },
//                           ),
//                         ),
//                       SizedBox(width: 8),
//                     ],
//                   ),
