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
  final _firestore = FirebaseFirestore.instance.collection('Users');
  static final _auth = FirebaseAuth.instance;
  final User? _firebaseUser = _auth.currentUser;

  Future<void> uploadSignUpInfo(
    UserModel userModel,
    String id,
  ) async {
    try {
      _firestore.doc(id).set(userModel.toJson());
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> postDetailsToFireStore(
    UserModel modelToPassData,
  ) async {
    try {
      await _firestore.doc(FirebaseAuthService().firebaseUser?.uid).set(
            modelToPassData.toJson(),
          );
    } catch (e) {
      log(e.toString());
    }
  }

  Future<UserModel?> getData() async {
    UserModel? myUser;
    User? userId = _auth.currentUser;
    String? id = userId?.uid;
    try {
      if (id == null) {
        return myUser;
      }
      final data = await _firestore.doc(id).get();
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
    await _firestore.doc(id).snapshots().first.then((value) {
      isPresent = false;
      isPresent = value.exists;
    });
    return isPresent;
  }

  // Future<void> updateData(UserModel modelToPassData) async {
  //   try {
  //     var data = await _firestore.doc(_firebaseUser?.uid).get();
  //     String? photoUrl = modelToPassData.photoUrl;

  //     if (photoUrl != null) {
  //       var file = File(photoUrl);

  //       Reference refRoot = FirebaseStorage.instance.ref();
  //       Reference referenceDir = refRoot.child('images');
  //       Reference imgToUpload = referenceDir.child(data.id);

  //       await imgToUpload.putFile(file);
  //       photoUrl = await imgToUpload.getDownloadURL();
  //       log("The uploaded Image URL is $photoUrl");
  //     }
  //     log(modelToPassData.email.toString());
  //     log(modelToPassData.cnic.toString());
  //     log(modelToPassData.photoUrl.toString());
  //     log(modelToPassData.firstName.toString());
  //     log(modelToPassData.lastName.toString());

  //     UserModel userModel = UserModel(
  //         firstName: data.data()?['firstName'],
  //         lastName: data.data()?['lastName'],
  //         email: data.data()?['email'],
  //         id: data.data()?['userId'],
  //         photoUrl: photoUrl ?? data.data()?['photoUrl'],
  //         cnic: modelToPassData.cnic,
  //         phone: modelToPassData.phone,
  //         license: modelToPassData.license,
  //         experience: modelToPassData.experience,
  //         dateOfBirth: modelToPassData.dateOfBirth,
  //         userType: data.data()?['userType']);
  //     final result = await _firestore.doc(_firebaseUser?.uid).update(
  //           userModel.toJson(),
  //         );
  //   } on FirebaseAuthException catch (e) {
  //     debugPrint(
  //       e.message,
  //     );
  //     throw UnkownFirestoreException(
  //       'Something went wrong ${e.code} ${e.message}',
  //     );
  //   }
  // }

  Future<String> uploadImage(String filePath) async {
    try {
      var file = File(filePath);
      String? uid = _firebaseUser?.uid;
      Reference refRoot = FirebaseStorage.instance.ref();
      Reference referenceDir = refRoot.child('images');
      Reference imgToUpload =
          referenceDir.child(uid.toString()); // try making the string  same

      await imgToUpload.putFile(file);
      String imageUrl = await imgToUpload.getDownloadURL();
      return imageUrl;
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
  ) async {
    try {
      var data = await _firestore.doc(_firebaseUser?.uid).get();

      UserModel userModel = UserModel(
          firstName: data.data()?['firstName'],
          lastName: data.data()?['lastName'],
          email: data.data()?['email'],
          id: data.data()?['userId'],
          photoUrl: modelToPassData.photoUrl,
          cnic: modelToPassData.cnic,
          phone: modelToPassData.phone,
          license: modelToPassData.license,
          experience: modelToPassData.experience,
          dateOfBirth: modelToPassData.dateOfBirth,
          userType: data.data()?['userType']);

      log(modelToPassData.email.toString());
      log(modelToPassData.cnic.toString());
      log(modelToPassData.photoUrl.toString());
      log(modelToPassData.firstName.toString());
      log(modelToPassData.lastName.toString());
      log(modelToPassData.id.toString());

      await _firestore.doc(_firebaseUser?.uid).set(
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

  Stream<UserModel> getStream() {
    final User? user = _auth.currentUser;
    return _firestore.doc(user?.uid).snapshots().map((event) {
      return UserModel.fromJson(event.data()!);
    });
  }

  Stream<List<UserModel>> getDriversStream() {
    return _firestore
        .where(
          'userType',
          isEqualTo: UserType.driver.name,
        )
        .snapshots()
        .map(
          (event) =>
              event.docs.map((e) => UserModel.fromJson(e.data())).toList(),
        );
  }

  Stream<List<UserModel>> getDriversSearchStream(int filterValue) {
    log("value is = $filterValue");
    return _firestore
        .where('experience', isNull: false)
        .where('experience', isGreaterThan: filterValue)
        .snapshots()
        .map(
          (event) =>
              event.docs.map((e) => UserModel.fromJson(e.data())).toList(),
        );
  }
}
