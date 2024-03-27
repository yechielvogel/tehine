class EventModel {
  String? eventRecordID;
  String? eventName;
  String? eventDescription;
  String? eventType;
  String? eventDate;
  String? eventAddress;
  String? eventAddress2;
  String? eventCountry;
  String? eventState;
  String? eventZipPostalCode;
  List<String>? lists;
  List? invitedList;
  List? attendingList;
  List? notAttendingList;
  List? pendingList;
  int? invited;
  int? attending;
  int? pending;
  int? notAttending;
  String? attachment;
  bool? didAccept;

  EventModel({
    this.eventRecordID,
    this.eventName,
    this.eventDescription,
    this.eventType,
    this.eventDate,
    this.eventAddress,
    this.eventAddress2,
    this.eventCountry,
    this.eventState,
    this.eventZipPostalCode,
    this.invitedList,
    this.attendingList,
    this.notAttendingList,
    this.pendingList,
    this.lists,
    this.invited,
    this.attending,
    this.pending,
    this.notAttending,
    this.attachment,
    this.didAccept,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      eventRecordID: json['eventRecordID'] ?? '',
      eventName: json['eventName'] ?? '',
      eventDescription: json['eventDescription'] ?? '',
      eventType: json['eventType'] ?? '',
      eventDate: json['eventDate'] ?? '',
      eventAddress: json['eventAddress'] ?? '',
      eventAddress2: json['eventAddress2'] ?? '',
      eventCountry: json['eventCountry'] ?? '',
      eventState: json['eventState'] ?? '',
      eventZipPostalCode: json['eventZipPostalCode'] ?? '',
      lists: json['lists'] != null ? List?.from(json['lists']) : [],
      invitedList:
          json['invitedList'] != null ? List?.from(json['invitedList']) : [],
      attendingList: json['attendingList'] != null
          ? List?.from(json['attendingList'])
          : [],
      notAttendingList: json['notAttendingList'] != null
          ? List?.from(json['notAttendingList'])
          : [],
      pendingList:
          json['pendingList'] != null ? List?.from(json['pendingList']) : [],
      invited: json['invited'] ?? 0,
      attending: json['attending'] ?? 0,
      pending: json['pending'] ?? 0,
      notAttending: json['notAttending'] ?? 0,
      attachment: json['attachment'] ?? '',
      didAccept: json['didAccept'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'eventRecordID': eventRecordID,
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
      'invitedList': invitedList,
      'attendingList': attendingList,
      'pendingList': pendingList,
      'notAttendingList': notAttendingList,
      'invited': invited,
      'attending': attending,
      'pending': pending,
      'notAttending': notAttending,
      'attachment': attachment,
      'didAccept': didAccept,
    };
  }

  EventModel copyWith({
    String? eventRecordID,
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
    List? invitedList,
    List? attendingList,
    List? pendingList,
    List? notAttendingList,
    String? attachment,
    int? invited,
    int? attending,
    int? pending,
    int? notAttending,
    bool? didAccept,
  }) {
    return EventModel(
      eventRecordID: eventRecordID ?? this.eventRecordID,
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
      invitedList: invitedList ?? this.invitedList,
      attendingList: attendingList ?? this.attendingList,
      pendingList: pendingList ?? this.pendingList,
      notAttendingList: notAttendingList ?? this.notAttendingList,
      attachment: attachment ?? this.attachment,
      invited: invited ?? this.invited,
      attending: attending ?? this.attending,
      pending: pending ?? this.pending,
      notAttending: notAttending ?? this.notAttending,
      didAccept: didAccept ?? this.didAccept,
    );
  }
}
