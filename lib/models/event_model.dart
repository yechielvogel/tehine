class EventModel {
  final String name;
  final String eventType;
  final String eventDate;
  final String address;
  final String address2;
  final String country;
  final String state;
  final String zip_postalCode;
  final bool eventMode;
  EventModel(
      {required this.name,
      required this.eventType,
      required this.eventDate,
      required this.address,
      required this.address2,
      required this.country,
      required this.state,
      required this.zip_postalCode,
      required this.eventMode});
}
