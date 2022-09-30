class UserModel {
  String? email;
  String? firstName;
  String? lastName;
  String? id;
  String? photoUrl;
  String? dateOfBirth;
  int? experience;
  int? cnic;
  int? license;
  String? phone;
  String? userType;

  UserModel({
    this.id,
    this.email,
    this.firstName,
    this.lastName,
    this.photoUrl,
    this.dateOfBirth,
    this.experience,
    this.cnic,
    this.license,
    this.phone,
    this.userType,
  });

  factory UserModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return UserModel(
      firstName: json['firstName'],
      email: json['email'],
      lastName: json['lastName'],
      id: json['userId'],
      photoUrl: json['photoUrl'],
      dateOfBirth: json['dateOfBirth'],
      experience: json['experience'],
      cnic: json['cnic'],
      license: json['licenseNO'],
      phone: json['phoneNO'],
      userType: json['userType'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'userId': id,
      'photoUrl': photoUrl,
      'dateOfBirth': dateOfBirth,
      'experience': experience,
      'cnic': cnic,
      'licenseNO': license,
      'phoneNO': phone,
      'userType': userType,
    };
  }
}
