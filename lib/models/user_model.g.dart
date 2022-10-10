// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      id: json['id'] as String?,
      email: json['email'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      photoUrl: json['photoUrl'] as String?,
      dateOfBirth: json['dateOfBirth'] as String?,
      experience: json['experience'] as int?,
      cnic: json['cnic'] as int?,
      licenseNO: json['licenseNO'] as int?,
      phoneNO: json['phoneNO'] as String?,
      userType: json['userType'] as String?,
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'email': instance.email,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'id': instance.id,
      'photoUrl': instance.photoUrl,
      'dateOfBirth': instance.dateOfBirth,
      'experience': instance.experience,
      'cnic': instance.cnic,
      'licenseNO': instance.licenseNO,
      'phoneNO': instance.phoneNO,
      'userType': instance.userType,
    };
