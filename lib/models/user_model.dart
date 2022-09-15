// ignore_for_file: non_constant_identifier_names

class UserModel {
  String? email;
  String? firstName;
  String? lastName;
  String? id;
  String? photoUrl;
  bool? firstTime;
  String? date;
  int? experience;
  int? CNIC;
  int? license;
  int? phone;

  UserModel(
      {this.id,
      this.email,
      this.firstName,
      this.lastName,
      this.photoUrl,
      this.firstTime,
      this.date,
      this.experience,
      this.CNIC,
      this.license,
      this.phone});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      firstName: json['userName'],
      email: json['email'],
      lastName: json['secondName'],
      id: json['userId'],
      photoUrl: json['photoUrl'],
      firstTime: json['firstTime'],
      date: json['date'],
      experience: json['experience'],
      CNIC: json['CNIC'],
      license: json['license'],
      phone: json['phone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'userId': id,
      'photoUrl': photoUrl,
      'firstTime': firstTime,
      'date': date,
      'experience': experience,
      'CNIC': CNIC,
      'license': license,
      'phone': phone,
    };
  }
}
