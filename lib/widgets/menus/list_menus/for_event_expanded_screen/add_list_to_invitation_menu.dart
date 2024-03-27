import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tehine/providers/event_providers.dart';

import '../../../../backend/api/contacts/airtable/upload_contacts.dart';
import '../../../../backend/api/events/airtable/upload_events.dart';
import '../../../../backend/api/events/shared_preferences/save_event_to_shared_preferences.dart';
import '../../../../models/event_model.dart';
import '../../../../providers/list_providers.dart';
import '../../../../providers/user_providers.dart';
import '../../../../shared/style.dart';

void addListToInvitationMenu(BuildContext context, WidgetRef ref) {
  EventModel event = ref.read(selectedEventProvider);
  List<EventModel> processedEvents = [];
  final RenderBox overlay =
      Overlay.of(context).context.findRenderObject() as RenderBox;

  final AsyncValue<List<String>> listOptions =
      ref.watch(listFromSharedPreferenceProvider);

  if (listOptions is AsyncData) {
    final List<String> listItems = listOptions.value ?? [];

    List<String> filteredListItems =
        listItems.where((item) => item != 'Tehine').toList();

    showMenu(
      context: context,
      position: RelativeRect.fromRect(
        Rect.fromPoints(
          Offset(0, 0),
          overlay.localToGlobal(overlay.size.bottomLeft(Offset.zero)),
        ),
        Offset.zero & overlay.size,
      ),
      items: [
        PopupMenuItem(
          child: Text(
            'Invite list to event:',
            style:
                TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[850]),
          ),
          enabled: false,
        ),
        ...filteredListItems.map((String listItem) {
          return PopupMenuItem(
            child: Text(listItem),
            value: listItem,
          );
        }),
      ],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8,
      color: seaSault,
    ).then(
      (value) {
        if (value != null) {
          // EventModel selectedEvent = ref.watch(selectedEventProvider.notifier).state;

          List<EventModel> updatedEvents =
              ref.read(eventsProvider).map((events) {
            if (events.eventName == event.eventName) {
              // This is the selected event, update it
              List<String> updatedLists = List<String>.from(events.lists ?? []);
              updatedLists.add(value);

              return EventModel(
                eventRecordID: events.eventRecordID,
                eventName: events.eventName,
                eventDescription: events.eventDescription,
                eventType: events.eventType,
                eventDate: events.eventDate,
                eventAddress: events.eventAddress,
                eventAddress2: events.eventAddress2,
                eventCountry: events.eventCountry,
                eventState: events.eventState,
                eventZipPostalCode: events.eventZipPostalCode,
                attachment: events.attachment,
                invited: events.invited,
                attending: events.attending,
                pending: events.pending,
                notAttending: events.notAttending,
                lists: updatedLists,
              );
            } else {
              // This is not the selected event, keep it unchanged
              return events;
            }
          }).toList();

          // Update the processed events list
          processedEvents = updatedEvents;

          // Save the updated events to SharedPreferences
          saveEventsToSP(processedEvents);

          // Add a way to get the event id then could edit the event by searching the event id
          // so there won't ever be a mistake editing the wrong event
          updateEventListsToAt(
            ref.read(eventRecordIDProvider),
            updatedEvents
                .firstWhere((e) => e.eventName == event.eventName)
                .lists,
          );
          // Refresh the provider that reads from SharedPreferences
          ref.refresh(eventListFromSharedPreferenceProvider);
          ref.refresh(eventsFromSharedPrefProvider);
        }
      },
    );
  }
}
