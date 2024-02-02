import 'dart:io';

import 'dart:io';

class EventModel {
  late final String? eventID;
  late final String eventName;
  late final String eventDescription;
  late final String eventType;
  late final String eventDate;
  late final String eventAddress;
  late final String eventAddress2;
  late final String eventCountry;
  late final String eventState;
  late final String eventZipPostalCode;
  late final List<String>? lists;
  late final int invited;
  late final int attending;
  late final int pending;
  late final int notAttending;
  late final String? attachment;

  EventModel({
    this.eventID,
    required this.eventName,
    required this.eventDescription,
    required this.eventType,
    required this.eventDate,
    required this.eventAddress,
    required this.eventAddress2,
    required this.eventCountry,
    required this.eventState,
    required this.eventZipPostalCode,
    this.lists,
    required this.invited,
    required this.attending,
    required this.pending,
    required this.notAttending,
    this.attachment,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      eventID: json['eventID'] ?? '',
      eventName: json['eventName'] ?? '',
      eventDescription: json['eventDescription'] ?? '',
      eventType: json['eventType'] ?? '',
      eventDate: json['eventDate'] ?? '',
      eventAddress: json['eventAddress'] ?? '',
      eventAddress2: json['eventAddress2'] ?? '',
      eventCountry: json['eventCountry'] ?? '',
      eventState: json['eventState'] ?? '',
      eventZipPostalCode: json['eventZipPostalCode'] ?? '',
      lists: json['lists'] != null ? List<String>.from(json['lists']) : [],
      invited: json['invited'] ?? 0,
      attending: json['attending'] ?? 0,
      pending: json['pending'] ?? 0,
      notAttending: json['notAttending'] ?? 0,
attachment: json['attachment'] ?? '',    );
  }

  Map<String, dynamic> toJson() {
    return {
      'eventID': eventID,
      'eventName': eventName,
      'eventDescription': eventDescription,
      'eventType': eventType,
      'eventDate': eventDate,
      'eventAddress': eventAddress,
      'eventAddress2': eventAddress2,
      'eventCountry': eventCountry,
      'eventState': eventState,
      'eventZipPostalCode': eventZipPostalCode,
      'lists': lists,
      'invited': invited,
      'attending': attending,
      'pending': pending,
      'notAttending': notAttending,
      'attachment': attachment,
    };
  }

  EventModel copyWith({
    String? eventID,
    String? eventName,
    String? eventDescription,
    String? eventType,
    String? eventDate,
    String? eventAddress,
    String? eventAddress2,
    String? eventCountry,
    String? eventState,
    String? eventZipPostalCode,
    List<String>? lists,
    String? attachment,
    int? invited,
    int? attending,
    int? pending,
    int? notAttending,
  }) {
    return EventModel(     
      eventID: eventID ?? this.eventID,
      eventName: eventName ?? this.eventName,
      eventDescription: eventDescription ?? this.eventDescription,
      eventType: eventType ?? this.eventType,
      eventDate: eventDate ?? this.eventDate,
      eventAddress: eventAddress ?? this.eventAddress,
      eventAddress2: eventAddress2 ?? this.eventAddress2,
      eventCountry: eventCountry ?? this.eventCountry,
      eventState: eventState ?? this.eventState,
      eventZipPostalCode: eventZipPostalCode ?? this.eventZipPostalCode,
      lists: lists ?? this.lists,
      attachment: attachment ?? this.attachment,
      invited: invited ?? this.invited,
      attending: attending ?? this.attending,
      pending: pending ?? this.pending,
      notAttending: notAttending ?? this.notAttending,
    );
  }
}
