// Contacts Model
class ContactModel {
  String contactRecordID;
  String? userRecordID;
  String firstName;
  String lastName;
  String email;
  String phoneNumber;
  List<String> lists;
  String? address;
  String? addressStreet;
  String? addressCity;
  String? addressState;
  String? addressZip;
  String? addressCountry;
  String? address2;
  bool isOnApp;

  ContactModel({
    required this.contactRecordID,
    this.userRecordID,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.lists,
    this.address,
    this.addressStreet,
    this.addressCity,
    this.addressState,
    this.addressZip,
    this.addressCountry,
    this.address2,
    this.isOnApp = false,
  });

  factory ContactModel.fromJson(Map<String, dynamic> json) {
    return ContactModel(
      contactRecordID: json['contactRecordID']?.toString() ?? '',
      userRecordID: json['userRecordID']?.toString() ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      address: json['address'],
      address2: json['address2'],
      addressStreet: json['addressStreet'],
      addressCity: json['addressCity'],
      addressState: json['addressState'],
      addressZip: json['addressZip'],
      addressCountry: json['addressCountry'],
      lists: json['lists'] != null ? List<String>.from(json['lists']) : [],
      isOnApp: json['isOnApp'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'contactRecordID': contactRecordID,
      'userRecordID': userRecordID,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phoneNumber': phoneNumber,
      'address': address,
      'address2': address2,
      'addressStreet': addressStreet,
      'addressCity': addressCity,
      'addressState': addressState,
      'addressZip': addressZip,
      'addressCountry': addressCountry,
      'lists': lists,
      'isOnApp': isOnApp,
    };
  }

  ContactModel copyWith({
    String? contactRecordID,
    String? userRecordID,
    String? firstName,
    String? lastName,
    String? email,
    String? phoneNumber,
    String? address,
    String? address2,
    String? addressStreet,
    String? addressCity,
    String? addressState,
    String? addressZip,
    String? addressCountry,
    List<String>? lists,
    bool? isOnApp,
  }) {
    return ContactModel(
      contactRecordID: contactRecordID ?? this.contactRecordID,
      userRecordID: userRecordID ?? this.userRecordID,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      address2: address2 ?? this.address2,
      addressStreet: addressStreet ?? this.addressStreet,
      addressCity: addressCity ?? this.addressCity,
      addressState: addressState ?? this.addressState,
      addressZip: addressZip ?? this.addressZip,
      addressCountry: addressCountry ?? this.addressCountry,
      lists: lists ?? this.lists,
      isOnApp: isOnApp ?? this.isOnApp,
    );
  }
}

