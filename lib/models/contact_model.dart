
// Contacts Model
class ContactModel {
  String firstName;
  String lastName;
  String email;
  String phoneNumber;
  List<String> lists;

  ContactModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.lists,
  });

  factory ContactModel.fromJson(Map<String, dynamic> json) {
    return ContactModel(
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      lists: json['lists'] != null
          ? List<String>.from(json['lists'])
          : [], 
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phoneNumber': phoneNumber,     
      'lists': lists,
    };
  }

  ContactModel copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? phoneNumber,
    List<String>? lists,
  }) {
    return ContactModel(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      lists: lists ?? this.lists,
    );
  }
  
}    
