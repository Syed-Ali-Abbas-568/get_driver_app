import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  String? email;
  String? firstName;
  String? lastName;
  String? id;
  String? photoUrl;
  String? dateOfBirth;
  int? experience;
  int? cnic;
  int? licenseNO;
  String? phoneNO;
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
    this.licenseNO,
    this.phoneNO,
    this.userType,
  });

  factory UserModel.fromJson(
      Map<String, dynamic> json,
      ) => _$UserModelFromJson(json);

  Map<String, dynamic> toJson()=> _$UserModelToJson(this);
}
