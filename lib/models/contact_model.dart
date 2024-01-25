// Contacts Model
class ContactModel {
  String contactID;
  String firstName;
  String lastName;
  String email;
  String phoneNumber;
  List<String> lists;

  ContactModel({
    required this.contactID,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.lists,
  });

  factory ContactModel.fromJson(Map<String, dynamic> json) {
    return ContactModel(
      contactID: json['contactID']?.toString() ??
          '', // Ensure contactID is treated as String
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      lists: json['lists'] != null ? List<String>.from(json['lists']) : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'contactID': contactID,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phoneNumber': phoneNumber,
      'lists': lists,
    };
  }

  ContactModel copyWith({
    String? contactID,
    String? firstName,
    String? lastName,
    String? email,
    String? phoneNumber,
    List<String>? lists,
  }) {
    return ContactModel(
      contactID: contactID ?? this.contactID,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      lists: lists ?? this.lists,
    );
  }
}
