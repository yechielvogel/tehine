
// Save event to SharedPreferences
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/event_model.dart';

Future<void> saveEventsToSP(List<EventModel> event) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // Remove duplicates based on phone number
  Map<String, EventModel> uniqueEventMap = {};
  for (EventModel event in event) {
    uniqueEventMap[event.eventName] = event;
  }

  List<EventModel> uniqueEvent = uniqueEventMap.values.toList();

  List<String> contactsJson =
      uniqueEvent.map((event) => json.encode(event.toJson())).toList();

  prefs.setStringList('Events', contactsJson);
}