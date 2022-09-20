class UserInfoModel {
  String? date;
  int? experience;
  int? CNIC;
  int? license;
  int? phone;

  UserInfoModel(
      {this.phone, this.date, this.CNIC, this.experience, this.license});

//TODO: naming Convention not followed and Trailing commas not added :(

  factory UserInfoModel.fromMap(map) {
    return UserInfoModel(
      phone: map['phone'],
      date: map['date'],
      CNIC: map['CNIC'],
      experience: map['experience'],
      license: map['license'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'license': license,
      'experience': experience,
      'CNIC': CNIC,
      'date': date,
      'phone': phone,
    };
  }
}
