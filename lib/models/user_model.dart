class UserModel {
  String? email;
  String? firstName;
  String? lastName;
  String? id;
  String? photoUrl;
  bool? firstTime;
  String? date;
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
    this.date,
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
      date: json['date'],
      experience: json['experience'],
      cnic: json['CNIC'],
      license: json['license'],
      phone: json['phone'],
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
      'date': date,
      'experience': experience,
      'CNIC': cnic,
      'license': license,
      'phone': phone,
      'userType': userType,
    };
  }
}
