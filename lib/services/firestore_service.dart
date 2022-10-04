import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/rendering.dart';

import 'package:get_driver_app/models/user_model.dart';
import 'package:get_driver_app/services/firebase_auth_service.dart';

enum UserType { driver, client }

class UnkownFirestoreException implements Exception {
  final String message;

  UnkownFirestoreException(this.message);
}

class FirestoreService {
  final _firestore = FirebaseFirestore.instance;
  static final _auth = FirebaseAuth.instance;

  Future<void> uploadSignUpInfo(
    UserModel userModel,
    String id,
  ) async {
    try {
      _firestore.collection('Users').doc(id).set(userModel.toJson());
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> postDetailsToFireStore(
    UserModel modelToPassData,
  ) async {
    try {
      await _firestore
          .collection('Users')
          .doc(FirebaseAuthService().firebaseUser?.uid)
          .set(
            modelToPassData.toJson(),
          );
    } catch (e) {
      log(e.toString());
    }
  }

  Future<UserModel?> getData() async {
    UserModel? myUser;
    String? id = _auth.currentUser?.uid;
    try {
      if (id == null) {
        return myUser;
      }
      final data = await _firestore.collection('Users').doc(id).get();
      myUser = UserModel.fromJson(data.data()!);
      Future.delayed(const Duration(seconds: 5));
    } on FirebaseAuthException catch (e) {
      debugPrint(e.toString());
      throw UnkownFirestoreException(
        "Something went wrong, ${e.message} || ${e.code}",
      );
    }
    return myUser;
  }

  Future<bool> isPresent(String id) async {
    bool isPresent = false;
    await _firestore
        .collection('Users')
        .doc(id)
        .snapshots()
        .first
        .then((value) {
      isPresent = false;
      isPresent = value.exists;
    });
    return isPresent;
  }

  Future<void> updateData(UserModel modelToPassData) async {
    User? firebaseUser = _auth.currentUser;
    try {
      var data = await FirebaseFirestore.instance
          .collection('Users')
          .doc(firebaseUser?.uid)
          .get();
      String? photoUrl = modelToPassData.photoUrl;

      if (photoUrl != null) {
        var file = File(photoUrl);

        Reference refRoot = FirebaseStorage.instance.ref();
        Reference referenceDir = refRoot.child('images');
        Reference imgToUpload = referenceDir.child(DateTime.now().toString());

        await imgToUpload.putFile(file);
        photoUrl = await imgToUpload.getDownloadURL();
        log("The uploaded Image URL is $photoUrl");
      }
      if (photoUrl != null) {
        UserModel userModel = UserModel(
            firstName: data.data()?['firstName'],
            lastName: data.data()?['lastName'],
            email: data.data()?['email'],
            id: data.data()?['userId'],
            photoUrl: data.data()?['photoUrl'],
            cnic: modelToPassData.cnic,
            phone: modelToPassData.phone,
            license: modelToPassData.license,
            experience: modelToPassData.experience,
            dateOfBirth: modelToPassData.dateOfBirth,
            userType: data.data()?['userType']);
        await _firestore.collection('Users').doc(firebaseUser?.uid).update(
              userModel.toJson(),
            );
      }
    } on FirebaseAuthException catch (e) {
      debugPrint(
        e.message,
      );
      throw UnkownFirestoreException(
        'Something went wrong ${e.code} ${e.message}',
      );
    }
  }

  Future<void> updateProfileData(
    UserModel modelToPassData,
    bool flag,
  ) async {
    User? firebaseUser = _auth.currentUser;
    try {
      var data = await FirebaseFirestore.instance //initialise only on
          .collection('Users')
          .doc(firebaseUser?.uid)
          .get();
      String photoUrl = modelToPassData.photoUrl.toString();
      if (flag) {
        var file = File(photoUrl);

        Reference refRoot = FirebaseStorage.instance.ref();
        Reference referenceDir = refRoot.child('images');
        Reference imgToUpload = referenceDir.child(DateTime.now().toString());

        await imgToUpload.putFile(file);
        photoUrl = await imgToUpload.getDownloadURL();
        log("The uploaded Image URL is $photoUrl");
      }

      UserModel userModel = UserModel(
          firstName: data.data()?['firstName'],
          lastName: data.data()?['lastName'],
          email: data.data()?['email'],
          id: data.data()?['userId'],
          photoUrl: data.data()?['photoUrl'],
          cnic: modelToPassData.cnic,
          phone: modelToPassData.phone,
          license: modelToPassData.license,
          experience: modelToPassData.experience,
          dateOfBirth: modelToPassData.dateOfBirth,
          userType: data.data()?['userType']);

      await _firestore.collection('Users').doc(firebaseUser?.uid).update(
            userModel.toJson(),
          );
    } on FirebaseAuthException catch (e) {
      debugPrint(
        e.message,
      );
      throw UnkownFirestoreException(
        'Something went wrong ${e.code} ${e.message}',
      );
    }
  }

  Stream<DocumentSnapshot> getStream() {
    User? user = _auth.currentUser;
    return _firestore.collection("Users").doc(user?.uid).snapshots();
  }

  Stream<List<UserModel>> getSearchStream() {
    UserModel userModel = UserModel();
    return _firestore
        .collection('Users')
        .where('userType', isEqualTo: UserType.driver.name)
        .snapshots()
        .map(
          (event) => event.docs
              .map((e) => userModel = UserModel.fromJson(e.data()))
              .toList(),
        );
  }
}
