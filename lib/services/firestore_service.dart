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
  static final _auth = FirebaseAuth.instance;

  /*
  TODO: This function needs be fixed
  TODO: According to fun type it should not return anything but you are returning CollectionReference 
  */
  Future<void> uploadSignUpInfo(UserModel userModel, String id) {
    return _firestore.collection('Users').doc(id).set(userModel.toJson());
  }

  Future<void> postDetailsToFireStore(
    String fName,
    String lName,
    String id,
    String email,
    String photoUrl,
    bool firstTime,
  ) async {
    try {
      //TODO: defined the firestore instance above not need to access it again here
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      User? user = _auth.currentUser;
      //*IMPORTANT: pass values in side the UserModel Constructor
      //*IMPORTANT: not out of the constructor. It is bad practice

      UserModel userModel = UserModel();
      userModel.firstName = fName;
      userModel.lastName = lName;
      userModel.email = email;
      userModel.id = id;
      userModel.photoUrl = photoUrl;
      userModel.firstTime = firstTime;

      await firebaseFirestore
          .collection('Users')
          .doc(user?.uid)
          .set(userModel.toJson());
    } catch (e) {
      log(e.toString());
    }
  }

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
      debugPrint(e.toString());
    }
    return myUser;
  }

  Future<bool> isPresent(String id) async {
    bool isEmpty = false;
    await _firestore
        .collection('Users')
        .doc(id)
        .snapshots()
        .first
        .then((value) {
      isEmpty = false;
      isEmpty = value.exists;
    });
    return isEmpty;
  }

  Future<void> updateData(
    String photoUrl,
    String date,
    int experience,
    int cnic,
    int license,
    String phone,
  ) async {
    try {
      User? user = FirebaseAuthService().firebaseUser;
      String? id;
      if (user == null) {
        final requestData = await FacebookAuth.instance.getUserData();
        id = requestData['id'];
      } else {
        id = user.uid;
      }
      var names =
          await FirebaseFirestore.instance.collection('Users').doc(id).get();
      //*IMPORTANT: pass values in side the UserModel Constructor
      //*IMPORTANT: not out of the constructor. It is bad practice
      UserModel userModel = UserModel();
      userModel.firstName = names.data()?['firstName'];
      userModel.lastName = names.data()?['lastName'];
      userModel.email = names.data()?['email'];
      userModel.id = names.data()?['userId'];
      userModel.photoUrl = names.data()?['photoUrl'];
      userModel.firstTime = false;
      userModel.cnic = cnic;
      userModel.phone = phone;
      userModel.license = license;
      userModel.experience = experience;
      userModel.date = date;

      await _firestore.collection('Users').doc(id).update(userModel.toJson());
    } on FirebaseAuthException catch (e) {
      debugPrint(e.message);
      //TODO: Use Trailing commas here
      throw UnkownFirestoreException(
          'Something went wrong ${e.code} ${e.message}');
    }
  }
}
