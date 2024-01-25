import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/event_model.dart';

Future<List<EventModel>?> loadEventsFromSP() async {
  SharedPreferences prefs;
  try {
    prefs = await SharedPreferences.getInstance();
  } catch (e) {
    return null;
  }

  List<String>? eventsJson = prefs.getStringList('Events');
  if (eventsJson == null) {
    return null;
  }

  List<EventModel> events = eventsJson
      .map((contactJson) => EventModel.fromJson(
          Map<String, dynamic>.from(json.decode(contactJson))))
      .toList();

  return events;
}