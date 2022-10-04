import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get_driver_app/models/user_model.dart';
import 'package:get_driver_app/services/firestore_service.dart';

class FirestoreProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  bool _hasFirestoreError = false;
  String _firestoreErrorMsg = '';
  bool _isProfileCreation = false;
  bool get isProfileCreation => _isProfileCreation;

  bool get hasFirestoreError => _hasFirestoreError;

  String get firestoreErrorMsg => _firestoreErrorMsg;

  Future<UserModel?> getUserData() async {
    UserModel? userModel;
    try {
      userModel = await _firestoreService.getData();
    } on UnkownFirestoreException catch (e) {
      _hasFirestoreError = true;
      _firestoreErrorMsg = e.message;
    }

    return userModel;
  }

  Future<void> postDetails(
    String fName,
    String lName,
    String id,
    String email,
    String photoUrl,
    String userType,
  ) {
    return _firestoreService.postDetailsToFireStore(
      fName,
      lName,
      id,
      email,
      photoUrl,
      userType,
    );
  }

  Future<void> uploadSignUpDetails(
    UserModel userModel,
    String id,
  ) {
    return _firestoreService.uploadSignUpInfo(userModel, id);
  }

  Future<void> uploadRemainingData(
    String? photoUrl,
    String? date,
    int? experience,
    int cnic,
    int? license,
    String phone,
  ) async {
    try {
      _isProfileCreation = true;
      _firestoreService.updateData(
        photoUrl,
        date,
        experience,
        cnic,
        license,
        phone,
      );
    } on UnkownFirestoreException {
      _firestoreErrorMsg = 'Something went wrong';
      _hasFirestoreError = true;
    }
    _isProfileCreation = false;
    notifyListeners();
  }
  //pass models here

  Future<void> uploadProfileData(
    String photoUrl,
    String date,
    int experience,
    int cnic,
    int license,
    String phone,
    bool flag,
  ) async {
    try {
      _isProfileCreation = true;
      await _firestoreService.updateProfileData(
        photoUrl,
        date,
        experience,
        cnic,
        license,
        phone,
        flag,
      );
    } on UnkownFirestoreException {
      _firestoreErrorMsg = 'Something went wrong';
      _hasFirestoreError = true;
    }
    _isProfileCreation = false;
    notifyListeners();
  }

  Future<bool> isDataPresent(String id) {
    return _firestoreService.isPresent(id);
  }

  Stream<DocumentSnapshot> getUserStream() {
    return _firestoreService.getStream();
  }
}
