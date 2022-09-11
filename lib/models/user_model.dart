class UserModel {
  String? email;
  String? firstName;
  String? lastName;
  String? id;

  UserModel({this.id, this.email, this.firstName, this.lastName});

  factory UserModel.fromMap(map) {
    return UserModel(
        firstName: map['userName'],
        email: map['email'],
        id: map['userId'],
        lastName: map['secondName']);
  }

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'userId': id,
    };
  }
}
