import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/events/shared_preferences/get_event_from_shared_preference.dart';
import '../models/event_model.dart';

final eventsFromSharedPrefProvider =
    FutureProvider<List<EventModel>>((ref) async {
  return await loadEventsFromSP() ?? [];
});

final eventsProvider = StateProvider<List<EventModel>>((ref) {
  final futureEvents = ref.watch(eventsFromSharedPrefProvider);
  return futureEvents.value ?? [];
});
