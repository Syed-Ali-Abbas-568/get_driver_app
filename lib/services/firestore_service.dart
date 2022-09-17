// ignore_for_file: non_constant_identifier_names

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get_driver_app/models/user_model.dart';
import 'package:get_driver_app/services/firebase_auth_service.dart';

class UnkownFirestoreException implements Exception {
  final String message;

  UnkownFirestoreException(this.message);
}

class FirestoreService {
  final _firestore = FirebaseFirestore.instance;

  Future<UserModel?> getData() async {
    User? user = FirebaseAuthService().firebaseUser;
    UserModel? myUser;
    String id;
    try {
      if (user == null) {
        final requestData = await FacebookAuth.instance.getUserData();
        id = requestData['id'];
      } else {
        id = user.uid;
      }
      final data = await _firestore.collection('Users').doc(id).get();
      var userInfo = UserModel.fromJson(data.data()!);
      myUser = userInfo;
    } catch (e) {
      log("in firestore service");
      debugPrint(e.toString());
    }
    return myUser;
  }

  Future<void> UpdateData(String photoUrl, String date, int experience,
      int cnic, int license, String phone) async {
    try {
      User? user = FirebaseAuthService().firebaseUser;
      String? id;
      if (user == null) {
        final requestData = await FacebookAuth.instance.getUserData();
        id = requestData['id'];
      } else {
        id = user.uid;
      }
      log(id!);
      var names =
          await FirebaseFirestore.instance.collection('Users').doc(id).get();
      log(names.data()?['firstName']);
      UserModel userModel = UserModel();
      userModel.firstName = names.data()?['firstName'];
      userModel.lastName = names.data()?['lastName'];
      userModel.email = names.data()?['email'];
      userModel.id = names.data()?['userId'];
      userModel.photoUrl = names.data()?['photoUrl'];
      userModel.firstTime = false;
      userModel.CNIC = cnic;
      userModel.phone = phone;
      userModel.license = license;
      userModel.experience = experience;
      userModel.date = date;

      await _firestore.collection('Users').doc(id).update(userModel.toJson());
    } on FirebaseAuthException catch (e) {
      debugPrint(e.message);
      throw UnkownFirestoreException(
          'Something went wrong ${e.code} ${e.message}');
    }
  }
}
