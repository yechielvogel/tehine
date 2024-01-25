class EventModel {
  late final String eventName;
  late final String eventDescription;
  late final String eventType;
  late final String eventDate;
  late final String eventAddress;
  late final String eventAddress2;
  late final String eventCountry;
  late final String eventState;
  late final String eventZipPostalCode;
  late final int invited;
  late final int attending;
  late final int pending;
  late final int notAttending;
  // bool eventMode; // Uncomment and adjust if eventMode is a boolean

  EventModel({
    required this.eventName,
    required this.eventDescription,
    required this.eventType,
    required this.eventDate,
    required this.eventAddress,
    required this.eventAddress2,
    required this.eventCountry,
    required this.eventState,
    required this.eventZipPostalCode,
    required this.invited,
    required this.attending,
    required this.pending,
    required this.notAttending,
    // this.eventMode = false, // Uncomment and adjust if eventMode is a boolean
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      eventName: json['eventName'] ?? '',
      eventDescription: json['eventDescription'] ?? '',
      eventType: json['eventType'] ?? '',
      eventDate: json['eventDate'] ?? '',
      eventAddress: json['eventAddress'] ?? '',
      eventAddress2: json['eventAddress2'] ?? '',
      eventCountry: json['eventCountry'] ?? '',
      eventState: json['eventState'] ?? '',
      eventZipPostalCode: json['eventZipPostalCode'] ?? '',
      invited: json['invited'] ?? 0,
      attending: json['attending'] ?? 0,
      pending: json['pending'] ?? 0,
      notAttending: json['notAttending'] ?? 0,
      // eventMode: json['eventMode'] ?? false, // Uncomment and adjust if eventMode is a boolean
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'eventName': eventName,
      'eventDescription': eventDescription,
      'eventType': eventType,
      'eventDate': eventDate,
      'eventAddress': eventAddress,
      'eventAddress2': eventAddress2,
      'eventCountry': eventCountry,
      'eventState': eventState,
      'eventZipPostalCode': eventZipPostalCode,
      'invited': invited,
      'attending': attending,
      'pending': pending,
      'notAttending': notAttending,
      // 'eventMode': eventMode, // Uncomment and adjust if eventMode is a boolean
    };
  }

  EventModel copyWith({
    String? eventName,
    String? eventDescription,
    String? eventType,
    String? eventDate,
    String? eventAddress,
    String? eventAddress2,
    String? eventCountry,
    String? eventState,
    String? eventZipPostalCode,
    bool? eventMode,
    int? invited,
    int? attending,
    int? pending,
    int? notAttending,
  }) {
    return EventModel(
      eventName: eventName ?? this.eventName,
      eventDescription: eventDescription ?? this.eventDescription,
      eventType: eventType ?? this.eventType,
      eventDate: eventDate ?? this.eventDate,
      eventAddress: eventAddress ?? this.eventAddress,
      eventAddress2: eventAddress2 ?? this.eventAddress2,
      eventCountry: eventCountry ?? this.eventCountry,
      eventState: eventState ?? this.eventState,
      eventZipPostalCode: eventZipPostalCode ?? this.eventZipPostalCode,
      // eventMode: eventMode ?? this.eventMode,
      invited: invited ?? this.invited,
      attending: attending ?? this.attending,
      pending: pending ?? this.pending,
      notAttending: notAttending ?? this.notAttending,
    );
  }
}
