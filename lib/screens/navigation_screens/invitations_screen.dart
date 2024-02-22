import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tehine/providers/invitations_providers.dart';
import 'package:tehine/providers/user_providers.dart';
import 'package:tehine/shared/loading.dart';

import '../../backend/api/events/airtable/get_events.dart';
import '../../backend/api/user/shared_preferences/get_user_from_shared_preferences.dart';
import '../../models/event_model.dart';
import '../../providers/general_providers.dart';
import '../../shared/style.dart';
import '../../widgets/tiles/event_tiles/invitation_tile_widget.dart';

// Should move this to a provider file.

class InvitationsScreen extends ConsumerStatefulWidget {
  bool showSearchBar = true;
  InvitationsScreen({
    required this.showSearchBar,
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _HomeState();
}

class _HomeState extends ConsumerState<InvitationsScreen> {
  @override
  void initState() {
    super.initState();
    populateUsersProviderIfDataExists(ref);
    ref.refresh(userFromSharedPrefProvider);
    WidgetsBinding.instance.addPostFrameCallback((_) async {});
  }

  bool _invitationsLoaded = false;


// Should refactor this to clean up
  @override
  Widget build(BuildContext context) {
    final selectedChipIndex =
        ref.read(selectedInvitationScreenChipIndexProvider);

    List<EventModel> events = initializeInvitations(selectedChipIndex);
    if (ref.watch(invitationsProvider).isNotEmpty) {
      ref.read(userProvider)?.userRecordID;
      return buildScaffold(events, selectedChipIndex);
    } else {
      ref.read(userProvider)?.userRecordID;
      if (ref.read(userProvider)?.userRecordID != null) {
      } else
        () {};
      _invitationsLoaded = true;
      return FutureBuilder<void>(
        future: () async {
          await populateUsersProviderIfDataExists(ref);
          await loadInvitationsFromAT(ref, ref.read(userRecordIDProvider));
        }(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Loading(); 
          } else if (snapshot.hasError) {
            return Text(
                'Error: ${snapshot.error}'); 
          } else {
            return buildScaffold(events, selectedChipIndex);
          }
        },
      );
      // } else {
      //   // need to make a error alert for this saying something like no internet
      //   return Text('Error: Failed to load invitations');
      // }
    }
  }

  Widget buildScaffold(List<EventModel> events, int selectedChipIndex) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      body: Consumer(
        builder: (context, watch, child) {
          List<Widget> contactWidgets = [];

          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                widget.showSearchBar
                    ? TextFormField(
                        cursorColor: Colors.grey[850],
                        decoration: InputDecoration(
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              color: Colors.grey[350] ?? Colors.grey,
                              width: 3,
                            ),
                          ),
                          hintText: 'Search',
                          hintStyle: TextStyle(color: Colors.grey[850]),
                          fillColor: Colors.grey[350] ?? Colors.grey,
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              color: Colors.grey[350] ?? Colors.grey,
                              width: 3.0,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              color: Colors.grey[350] ?? Colors.grey,
                              width: 3.0,
                            ),
                          ),
                          errorStyle: TextStyle(color: Colors.grey[850]),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              color: Colors.grey[350] ?? Colors.grey,
                              width: 3.0,
                            ),
                          ),
                        ),
                        style: TextStyle(color: Colors.grey[850]),
                      )
                    : Container(),
                Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: SingleChildScrollView(
                    clipBehavior: Clip.none,
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        for (int index = 0; index < chipLabels.length; index++)
                          Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: ChoiceChip(
                              selectedColor: Colors.grey[850],
                              backgroundColor: selectedChipIndex == index
                                  ? Colors.grey[850]
                                  : lightGrey,
                              // : Color(0xFFF5F5F5),
                              label: Text(
                                chipLabels[index],
                                style: TextStyle(
                                  color: selectedChipIndex == index
                                      ? Color(0xFFF5F5F5)
                                      : Colors.grey[850],
                                ),
                              ),
                              selected: selectedChipIndex == index,
                              onSelected: (selected) async {
                                if (selected) {
                                  ref
                                      .read(
                                          selectedInvitationScreenChipIndexProvider
                                              .state)
                                      .state = index;
                                }
                                await filterInvitations(index);
                                ref.watch(invitationsProvider);
                                ref.watch(filteredInvitationsProvider);
                              },
                            ),
                          ),
                        SizedBox(width: 7),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: events.length,
                  itemBuilder: (BuildContext context, int index) {
                    EventModel event = events[index];
                    return EventInvitationTileWidget(
                      event: event,
                      invited: event.invited,
                      attending: event.attending,
                      pending: event.pending,
                      notAttending: event.notAttending,
                      // didAccept: event.didAccept,
                    );
                  },
                ),
                SizedBox(height: 10),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> selectedChip() async {}
// Filter for the chips
  Future<void> filterInvitations(index) async {
    DateTime currentDate = DateTime.now();

    List<EventModel> _invitations = ref.read(invitationsProvider);
    if (index == 0) {
      ref.watch(filteredInvitationsProvider.notifier).state =
          _invitations.where((invitation) {
        DateTime invitationDate = DateTime.parse(invitation.eventDate);
        return invitationDate.year == currentDate.year &&
            invitationDate.month == currentDate.month &&
            invitationDate.day == currentDate.day;
      }).toList();
    } else if (index == 1) {
      ref.watch(filteredInvitationsProvider.notifier).state =
          ref.watch(invitationsProvider);
    } else if (index == 2) {
      // Check if this works
      ref.watch(filteredInvitationsProvider.notifier).state = _invitations
          .where((invitation) =>
              invitation.didAccept == true && invitation.didAccept != null)
          .toList();
      // going
    } else if (index == 3) {
      ref.watch(filteredInvitationsProvider.notifier).state =
          _invitations.where((invitation) {
        DateTime invitationDate = DateTime.parse(invitation.eventDate);
        DateTime currentDate = DateTime.now();
        return invitationDate.isBefore(currentDate);
      }).toList();
      // Expired
    } else if (index == 4) {
      ref.watch(filteredInvitationsProvider.notifier).state =
          _invitations.where((invitation) {
        DateTime invitationDate = DateTime.parse(invitation.eventDate);
        DateTime currentDate = DateTime.now();
        return !invitationDate.isBefore(currentDate);
      }).toList();
      // Upcoming
    } else if (index == 5) {
      ref.watch(filteredInvitationsProvider.notifier).state = _invitations
          .where((invitation) =>
              invitation.didAccept == false && invitation.didAccept != null)
          .toList();
      // Not attending/declined
    }
  }

  final List<String> chipLabels = [
    'Today',
    'All',
    'Going',
    'Expired',
    'Upcoming',
    'Not Going'
  ];

  List<EventModel> initializeInvitations(int index) {
    List<EventModel> getInitialInvitations = ref.watch(invitationsProvider);
    List<EventModel> getFilteredInvitations =
        ref.watch(filteredInvitationsProvider);
    List<EventModel> invitations = [];

    if (getFilteredInvitations.isEmpty && index == 1) {
      invitations = getInitialInvitations;
    } else {
      for (EventModel invitations in getFilteredInvitations) {
      }
      invitations = getFilteredInvitations;
    }
    return invitations;
  }
}

// rules_version = '2';

// service cloud.firestore {
//   match /databases/{database}/documents {
//     match /{document=**} {
//       allow read, write: if false;
//     }
//   }
// }


