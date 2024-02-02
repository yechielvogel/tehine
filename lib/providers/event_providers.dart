import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/events/shared_preferences/get_event_from_shared_preference.dart';
import '../models/event_model.dart';



// final selectedDateProvider = StateProvider<DateTime?>(
//   (ref) => null, 
// );

final selectedCountryProvider =
    StateProvider<String>((ref) => 'Select Country');

final selectedStateProvider = StateProvider<String>((ref) => 'Select State');

final selectedEventTypeProvider = StateProvider<String>((ref) => '');


// For creating a event 

final createEventNameProvider = StateProvider<String>((ref) => '');

final createEventDescriptionProvider = StateProvider<String>((ref) => '');

final createEventAddressProvider = StateProvider<String>((ref) => '');

final createEventAddress2Provider = StateProvider<String>((ref) => '');

final createEventZipPostalCodeProvider = StateProvider<String>((ref) => '');

 

final eventsFromSharedPrefProvider =
    FutureProvider<List<EventModel>>((ref) async {
  return await loadEventsFromSP() ?? [];
});

final eventsProvider = StateProvider<List<EventModel>>((ref) {
  final futureEvents = ref.watch(eventsFromSharedPrefProvider);
  return futureEvents.value ?? [];
});

final selectedEventNameProvider = StateProvider<String>(
  (ref) => '',
);



final selectedEventProvider = StateProvider<EventModel>(
  (ref) => EventModel(eventID: 'eventID', eventName: 'eventName', eventDescription: 'eventDescription', eventType: 'eventType', eventDate: 'eventDate', eventAddress: 'eventAddress', eventAddress2: 'eventAddress2', eventCountry: 'eventCountry', eventState: 'eventState', eventZipPostalCode: 'eventZipPostalCode', invited: 0, attending: 0, pending: 0, notAttending: 0),
);

final eventIDProvider = StateProvider<String?>(
  (ref) => '',
);

final eventNameProvider = StateProvider<String>((ref) => '');

final eventDescriptionProvider = StateProvider<String>((ref) => '');

final eventTypeProvider = StateProvider<String>((ref) => '');

final eventDateProvider = StateProvider<String>((ref) => '');

final eventAddressProvider = StateProvider<String>((ref) => '');

final eventAddress2Provider = StateProvider<String>((ref) => '');

final eventCountryProvider = StateProvider<String>((ref) => '');

final eventStateProvider = StateProvider<String>((ref) => '');

final eventZipPostalCodeProvider = StateProvider<String>((ref) => '');

final eventListsProvider = StateProvider<List<String>?>((ref) => []);

final eventInvitedProvider = StateProvider<int>((ref) => 0);

final eventAttendingProvider = StateProvider<int>((ref) => 0);

final eventPendingProvider = StateProvider<int>((ref) => 0);

final eventNotAttendingProvider = StateProvider<int>((ref) => 0);

final eventAttachmentProvider = StateProvider<String?>(
      (ref) => ''
);

