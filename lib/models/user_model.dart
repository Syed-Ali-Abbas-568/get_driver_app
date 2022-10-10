import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? id;
  final String? photoUrl;
  final String? dateOfBirth;
  final int? experience;
  final int? cnic;
  final int? licenseNO;
  final String? phoneNO;
  final String? userType;

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
