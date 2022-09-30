import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/rendering.dart';

import 'package:get_driver_app/models/user_model.dart';
import 'package:get_driver_app/services/firebase_auth_service.dart';

class UnkownFirestoreException implements Exception {
  final String message;

  UnkownFirestoreException(this.message);
}

class FirestoreService {
  final _firestore = FirebaseFirestore.instance;
  static final _auth = FirebaseAuth.instance;
  final User? _user = _auth.currentUser;

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
    String fName,
    String lName,
    String id,
    String email,
    String? photoUrl,
    String? userType,
  ) async {
    try {
      UserModel userModel = UserModel(
        firstName: fName,
        lastName: lName,
        email: email,
        id: id,
        photoUrl: photoUrl,
        userType: userType,
      );

      await _firestore
          .collection('Users')
          .doc(FirebaseAuthService().firebaseUser?.uid)
          .set(
            userModel.toJson(),
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

  Future<void> updateData(
    String? photoUrl,
    String? date,
    int? experience,
    int cnic,
    int? license,
    String phone,
  ) async {
    User? firebaseUser = _auth.currentUser;
    try {
      var data = await FirebaseFirestore.instance
          .collection('Users')
          .doc(firebaseUser?.uid)
          .get();

      if (photoUrl != null) {
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
          cnic: cnic,
          phone: phone,
          license: license,
          experience: experience,
          dateOfBirth: date,
          userType: data.data()?['userType']);
      await _firestore.collection('Users').doc(firebaseUser?.uid).update(
            userModel.toJson(),
          );
      getData();
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
    String photoUrl,
    String date,
    int experience,
    int cnic,
    int license,
    String phone,
    bool flag,
  ) async {
    User? firebaseUser = _auth.currentUser;
    try {
      var data = await FirebaseFirestore.instance
          .collection('Users')
          .doc(firebaseUser?.uid)
          .get();

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
          cnic: cnic,
          phone: phone,
          license: license,
          experience: experience,
          dateOfBirth: date,
          userType: data.data()?['userType']);
      await _firestore.collection('Users').doc(firebaseUser?.uid).update(
            userModel.toJson(),
          );
      getData();
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
}
