class UserModel {
  String? email;
  String? firstName;
  String? lastName;
  String? id;
  String? photoUrl;
  bool? firstTime;

  UserModel(
      {this.id,
      this.email,
      this.firstName,
      this.lastName,
      this.photoUrl,
      this.firstTime});

  factory UserModel.fromMap(map) {
    return UserModel(
      firstName: map['userName'],
      email: map['email'],
      id: map['userId'],
      lastName: map['secondName'],
      photoUrl: map['photoUrl'],
      firstTime: map['firstTime'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'userId': id,
      'photoUrl': photoUrl,
      'firstTime': firstTime,
    };
  }
}
