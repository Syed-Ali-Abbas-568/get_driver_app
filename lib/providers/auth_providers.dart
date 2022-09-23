import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import 'package:get_driver_app/models/user_model.dart';
import 'package:get_driver_app/services/firebase_auth_service.dart';

class AuthProvider with ChangeNotifier {
  final _firebaseAuthService = FirebaseAuthService();

  bool _isLoading = false;
  bool _hasError = false;
  String _errorMsg = '';

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

  Future<UserModel?> facebookSignUp() async {
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

  Future<UserModel?> googleSignUpFunc() async {
    _hasError = false;
    UserModel? userModel;
    try {
      userModel = await _firebaseAuthService.googleSignUp();
    } on UnkownException catch (e) {
      log("exception thrown");
      _errorMsg = e.message;
      _hasError = true;
    }
    notifyListeners();
    return userModel;
  }

  Future<UserCredential?> signUpWithEmailPass(
    String fName,
    String lName,
    String email,
    String password,
    String userType,
  ) async {
    UserCredential? userCredentials;
    try {
      _isLoading = true;
      userCredentials = await _firebaseAuthService.signUp(
        fName,
        lName,
        email,
        password,
        userType,
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
}
