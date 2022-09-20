// ignore_for_file: non_constant_identifier_names

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_driver_app/models/user_model.dart';
import 'package:get_driver_app/services/firebase_auth_service.dart';

//TODO: unused and commented code still here :(

class AuthProvider with ChangeNotifier {
  final _firebaseAuthService = FirebaseAuthService();

  bool _isLoading = false;
  bool _hasError = false;
  String _errorMsg = '';
  // String _errorMsg = '';

  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  String get errorMsg => _errorMsg;

  Future<void> signInWithEmailPassword(String email, String password) async {
    _isLoading = true;
    _hasError = false;
    try {
      await _firebaseAuthService.signIn(email, password);
    } on WrongPasswordException catch (e) {
      _errorMsg = e.message;
      _hasError = true;
    } on UserNotFoundException catch (e) {
      _errorMsg = e.message;
      _hasError = true;
    } on UnkownException {
      _errorMsg = 'Something went wrong';
      _hasError = true;
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<UserModel?> FacebookSignUp() async {
    _isLoading = true;
    UserModel? userModel;
    try {
      userModel = await _firebaseAuthService.facebookSignUp();
    } on UnkownException catch (e) {
      log(e.toString());
      _errorMsg = e.message;
      _hasError = true;
    }
    _isLoading = false;
    notifyListeners();
    return userModel;
  }
//TODO: naming Convention not followed. Still not Following :(

  Future<UserModel?> GoogleSignUpFunc() async {
    _isLoading = true;
    UserModel? userModel;
    try {
      userModel = await _firebaseAuthService.googleSignUp();
    } on UnkownException catch (e) {
      _errorMsg = e.message;
      _hasError = true;
    }
    _isLoading = false;
    notifyListeners();
    return userModel;
  }
//TODO: naming Convention not followed and Trailing commas not added :(

  Future<UserCredential?> SignUpWithEmailPass(
      String fName, String lName, String email, String password) async {
    UserCredential? userCredentials;
    try {
      _isLoading = true;
      userCredentials = await _firebaseAuthService.SignUp(
        fName,
        lName,
        email,
        password,
      );
    } on EmailAlreadyExistException catch (e) {
      _errorMsg = e.message;
      _hasError = true;
    } on UnkownException catch (e) {
      _errorMsg = e.message;
      _hasError = true;
    }
    _isLoading = false;
    notifyListeners();
    return userCredentials;
  }

  // profileCreation(String date, int experience, int CNIC, int license, int phone,
  //     BuildContext context) async {
  //
  //   _firebaseAuthService.postUserInfo(
  //       date, experience, CNIC, license, phone, context);
  //   notifyListeners();
  // }
}
