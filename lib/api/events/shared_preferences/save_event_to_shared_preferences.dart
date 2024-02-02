// Save event to SharedPreferences
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/event_model.dart';

// Save a event to shared preference

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

// Edit a event in shared preference

Future<void> editEventInSP(
    String? eventID,
    String eventName,
    String eventDescription,
    String? eventType,
    String eventDate,
    String eventAddress,
    String eventAddress2,
    String eventCountry,
    String eventState,
    String zip_postalCode) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  List<String>? eventsJson = prefs.getStringList('Events');

  if (eventsJson == null) {
    return;
  }

  List<EventModel> existingEvents = eventsJson
      .map((jsonString) => EventModel.fromJson(json.decode(jsonString)))
      .toList();

  int indexToUpdate =
      existingEvents.indexWhere((event) => event.eventID == eventID);

  if (indexToUpdate != -1) {
    // Update the specified fields in the existing event
    existingEvents[indexToUpdate] = existingEvents[indexToUpdate].copyWith(
      // Add the fields you want to update
      // eventID: eventID ?? existingEvents[indexToUpdate].eventID,
      eventName: eventName ?? existingEvents[indexToUpdate].eventName,
      eventDescription:
          eventDescription ?? existingEvents[indexToUpdate].eventDescription,
      eventType: eventType ?? existingEvents[indexToUpdate].eventType,
      eventDate: eventDate ?? existingEvents[indexToUpdate].eventDate,
      eventAddress: eventAddress ?? existingEvents[indexToUpdate].eventAddress,
      eventAddress2:
          eventAddress2 ?? existingEvents[indexToUpdate].eventAddress2,
      eventCountry: eventCountry ?? existingEvents[indexToUpdate].eventCountry,
      eventState: eventState ?? existingEvents[indexToUpdate].eventState,
      eventZipPostalCode:
          zip_postalCode ?? existingEvents[indexToUpdate].eventZipPostalCode,

      // Add more fields as needed
    );

    List<String> updatedEventsJson =
        existingEvents.map((event) => json.encode(event.toJson())).toList();

    prefs.setStringList('Events', updatedEventsJson);
  }
}

// add a attachment to a event

Future<void> updateEventAttachmentInSP(
  String? eventID,
  // Eventually this will change to File
  String eventAttachment,
) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  List<String>? eventsJson = prefs.getStringList('Events');

  if (eventsJson == null) {
    return;
  }

  List<EventModel> existingEvents = eventsJson
      .map((jsonString) => EventModel.fromJson(json.decode(jsonString)))
      .toList();

  int indexToUpdate =
      existingEvents.indexWhere((event) => event.eventID == eventID);

  if (indexToUpdate != -1) {
    // Update the specified fields in the existing event
    existingEvents[indexToUpdate] = existingEvents[indexToUpdate].copyWith(
      // Add the fields you want to update
      // eventID: eventID ?? existingEvents[indexToUpdate].eventID,
      attachment: eventAttachment ?? existingEvents[indexToUpdate].attachment,
      // Add more fields as needed
    );

    List<String> updatedEventsJson =
        existingEvents.map((event) => json.encode(event.toJson())).toList();

    prefs.setStringList('Events', updatedEventsJson);
  }
}

// Delete a event in shared preferences

Future<void> deleteEventFromSP(EventModel event) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  List<String>? eventsJsonList = prefs.getStringList('Events');
  List<EventModel> events = eventsJsonList
          ?.map((jsonString) => EventModel.fromJson(json.decode(jsonString)))
          .toList() as List<EventModel>? ??
      [];

  // Remove the event from the list
  events.removeWhere(
    (existingEvent) => existingEvent.eventID == event.eventID,
  );

  // Save the updated list back to shared preferences
  List<String> updatedEventsJson =
      events.map((event) => json.encode(event.toJson())).toList();
  prefs.setStringList('Events', updatedEventsJson);
}
