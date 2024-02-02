import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../../../api/contacts/airtable/upload_contacts.dart';
import '../../../api/events/shared_preferences/get_event_from_shared_preference.dart';
import '../../../models/contact_model.dart';

import '../../../models/event_model.dart';
import '../../../providers/contact_providers.dart';
import '../../../api/contacts/shared_preferences/save_contacts_to_shared_preferences.dart';
import '../../../providers/event_providers.dart';
import '../../../providers/list_providers.dart';
import '../../../providers/user_providers.dart';

import '../../../screens/expanded_screens/event_expanded_screen.dart';
import '../../bottom_sheet_widgets/attending_info_bottom_sheet_widget.dart';
import '../../dividers/divider_horizontal.dart';
import '../../dividers/divider_vertical.dart';
import '../../menus/list_menus/contact_tile_ellips_menu.dart';

class EventTileWidget extends ConsumerStatefulWidget {
  final EventModel event;
  final int invited;
  final int attending;
  final int pending;
  final int notAttending;
  late Offset tapPosition = Offset.zero;

  EventTileWidget({
    Key? key,
    required this.event,
    required this.invited,
    required this.attending,
    required this.pending,
    required this.notAttending,
  }) : super(key: key);

  @override
  ConsumerState<EventTileWidget> createState() => _EventTileWidgetState();
}

class _EventTileWidgetState extends ConsumerState<EventTileWidget> {
  Icon? icon;
  @override
  Widget build(BuildContext context) {
    getIcon();
    List<EventModel> events = [];
    // contactToDelete.add(widget.contact);
    return GestureDetector(
      onTap: () async {
        print('Event ID ${widget.event.eventID}');
        ref.read(selectedEventNameProvider.notifier).state =
            widget.event.eventName;
        ref.read(selectedEventProvider.notifier).state = widget.event;
        // printEventListsFromSP();
        await ref.refresh(eventListFromSharedPreferenceProvider);

        await initializeProviders();
        // ref.read(eventListProvider);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return EventExpandedScreenWidget(
                  // event: widget
                  //     .event
                  ); // Replace YourNextScreen with the actual widget for the next screen
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
                          right: 20, // Adjust the right padding as needed
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
                          child: Text(DateFormat('MM/dd/yyyy')
                              .format(DateTime.parse(widget.event.eventDate)))),
                    )
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 50, left: 20, bottom: 0),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20),
                                  ),
                                ),
                                context: context,
                                builder: (context) =>
                                    AttendingInfoWidget(event: widget.event),
                              );
                            },
                            child: Icon(
                              Icons.mail_outline, // Envelope icon
                              color: Colors.grey[850],
                              size: 20,
                            ),
                          ),
                          SizedBox(
                              width:
                                  5), // Add some spacing between icon and count
                          Text(
                            '0', // Replace with your attendance count
                            style: TextStyle(
                              color: Colors.grey[850],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 50, left: 20, bottom: 0),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            color: Colors.grey[850],
                            size: 20,
                          ),
                          SizedBox(width: 5),
                          Text(
                            '0',
                            style: TextStyle(
                              color: Colors.grey[850],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 50, left: 20, bottom: 0),
                      child: Row(
                        children: [
                          Icon(
                            Icons.schedule, // Envelope icon
                            color: Colors.grey[850],
                            size: 20,
                          ),
                          SizedBox(
                              width:
                                  5), // Add some spacing between icon and count
                          Text(
                            '0', // Replace with your attendance count
                            style: TextStyle(
                              color: Colors.grey[850],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 50, left: 20, bottom: 0),
                      child: Row(
                        children: [
                          Icon(
                            Icons.cancel_outlined, // Envelope icon
                            color: Colors.grey[850],
                            size: 20,
                          ),
                          SizedBox(
                              width:
                                  5), // Add some spacing between icon and count
                          Text(
                            '0', // Replace with your attendance count
                            style: TextStyle(
                              color: Colors.grey[850],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> getIcon() async {
    if (widget.event.eventType == 'Wedding') {
      icon = Icon(
        FontAwesomeIcons.gift, // Replace with the desired icon
        color: Colors.grey[850],
        size: 24,
      );
    } else if (widget.event.eventType == 'Birthday Party') {
      icon = Icon(
        FontAwesomeIcons.birthdayCake, // Replace with the desired icon
        color: Colors.grey[850],
        size: 24,
      );
    } else if (widget.event.eventType == 'Bar Mitzvah') {
      icon = Icon(
        FontAwesomeIcons.moneyBill, // Replace with the desired icon
        color: Colors.grey[850],
        size: 24,
      );
    } else if (widget.event.eventType == 'Engagement') {
      icon = Icon(
        FontAwesomeIcons.ring, // Replace with the desired icon
        color: Colors.grey[850],
        size: 24,
      );
    }
  }

  Future<void> initializeProviders() async {
    ref.read(eventIDProvider.notifier).state = widget.event.eventID;
    // print('ref ID ${ref.read(eventIDProvider)}');
    ref.read(eventNameProvider.notifier).state = widget.event.eventName;
    ref.read(eventDescriptionProvider.notifier).state =
        widget.event.eventDescription;
    ref.read(eventTypeProvider.notifier).state = widget.event.eventType;
    ref.read(eventDateProvider.notifier).state = widget.event.eventDate;
    ref.read(eventAddressProvider.notifier).state = widget.event.eventAddress;
    ref.read(eventAddress2Provider.notifier).state = widget.event.eventAddress2;
    ref.read(eventCountryProvider.notifier).state = widget.event.eventCountry;
    ref.read(eventStateProvider.notifier).state = widget.event.eventState;
    ref.read(eventZipPostalCodeProvider.notifier).state =
        widget.event.eventZipPostalCode;
    // ref.read(eventListsProvider.notifier).state = widget.event.lists;
    ref.read(eventInvitedProvider.notifier).state = widget.event.invited;
    ref.read(eventAttendingProvider.notifier).state = widget.event.attending;
    ref.read(eventPendingProvider.notifier).state = widget.event.pending;
    ref.read(eventNotAttendingProvider.notifier).state =
        widget.event.notAttending;
    ref.read(eventAttachmentProvider.notifier).state = widget.event.attachment;
  }
}
