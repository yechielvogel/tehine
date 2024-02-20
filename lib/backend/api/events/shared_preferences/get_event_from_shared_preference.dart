import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../models/event_model.dart';
import '../../../../providers/event_providers.dart';

// Load lists from events

Future<List<String>?> loadEventListsFromSP(String eventName) async {
  // print('runing this function and here is the name $eventName');
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
      .map((eventJson) => EventModel.fromJson(json.decode(eventJson)))
      .toList();

  // Find the specific event by its name
  EventModel? specificEvent = events.firstWhere(
    (event) => event.eventName == eventName,
    // orElse: () => null,
  );

  if (specificEvent != null) {    
    // Return the 'lists' property of the specific event
    print(specificEvent.lists);
    return specificEvent.lists;
  } else {
    return []; // Return null if the specific event is not found
  }
}

// Load events

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

Future<void> populateEventsProviderIfDataExists(WidgetRef ref) async {
  final List<EventModel>? events = await loadEventsFromSP();
  if (events != null && events.isNotEmpty) {
    ref.read(eventsProviderCheck.notifier).state = events;
  }
}


// this is a test function

Future<void> printEventListsFromSP() async {
  SharedPreferences prefs;
  try {
    prefs = await SharedPreferences.getInstance();
  } catch (e) {
    print('Error accessing SharedPreferences: $e');
    return;
  }

  List<String>? eventsJson = prefs.getStringList('Events');
  if (eventsJson == null) {
    print('No events found in SharedPreferences.');
    return;
  }

  List<EventModel> events = eventsJson
      .map((eventJson) => EventModel.fromJson(json.decode(eventJson)))
      .toList();

  for (EventModel event in events) {
    print('Event: ${event.eventName}');

    // Print the list property of the event
    if (event.lists != null) {
      print('Lists: ${event.lists}');
    } else {
      print('No lists for this event.');
    }
  }
}
