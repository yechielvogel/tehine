class Users {
  String? userRecordID;
  String? uid;
  final String? username;
  String? firstName;
  String? lastName;
  String? email;
  String? phoneNumber;

  Users({
    this.userRecordID,
    this.uid,
    this.username,
    this.firstName,
    this.lastName,
    this.email,
    this.phoneNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': userRecordID,
      'uid': uid,
      'username': username,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phoneNumber': phoneNumber,
    };
  }

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      userRecordID: json['id'],
      uid: json['uid'],
      username: json['username'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
    );
  }
}
