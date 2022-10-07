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

  bool _isLoading = false;
  bool get isLoading => _isLoading;

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
    UserModel modelToPassData,
  ) {
    return _firestoreService.postDetailsToFireStore(modelToPassData);
  }

  Future<void> uploadSignUpDetails(
    UserModel userModel,
    String id,
  ) {
    return _firestoreService.uploadSignUpInfo(userModel, id);
  }

  // Future<void> uploadRemainingData(
  //   UserModel modelToPassData,
  // ) async {
  //   try {
  //     _isProfileCreation = true;
  //     _firestoreService.updateData(
  //       modelToPassData,
  //     );
  //   } on UnkownFirestoreException {
  //     _firestoreErrorMsg = 'Something went wrong';
  //     _hasFirestoreError = true;
  //   }
  //   _isProfileCreation = false;
  //   notifyListeners();
  // }

  Future<String?> uploadImage(String filePath) async {
    _isLoading = true;
    notifyListeners();
    String? imageUrl;
    try {
      imageUrl = await _firestoreService.uploadImage(filePath);
    } on UnkownFirestoreException {
      _firestoreErrorMsg = 'Something went Wrong';
      _hasFirestoreError = true;
    }
    return imageUrl;
  }

  Future<void> uploadProfileData(
    UserModel modelToPassData,
  ) async {
    _isLoading = true;

    try {
      _isProfileCreation = true;
      await _firestoreService.updateProfileData(
        modelToPassData,
      );
    } on UnkownFirestoreException {
      _firestoreErrorMsg = 'Something went wrong';
      _hasFirestoreError = true;
    }
    _isProfileCreation = false;
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> isDataPresent(String id) {
    return _firestoreService.isPresent(id);
  }

  Stream<UserModel> getUserStream() {
    return _firestoreService.getStream();
  }

  Stream<List<UserModel>> getDriversStream() {
    return _firestoreService.getDriversStream();
  }

  Stream<List<UserModel>> getDriversSearchStream(int filterValue) {
    return _firestoreService.getDriversSearchStream(filterValue);
  }
}
