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

  Future<void> signInWithEmailPassword(
    String email,
    String password,
  ) async {
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

  Future<UserModel?> facebookSignUp(String userType) async {
    _isLoading = true;
    _hasError = false;
    UserModel? userModel;
    try {
      userModel = await _firebaseAuthService.facebookSignUp(userType);
    } on UnkownException catch (e) {
      debugPrint(e.toString());
      _errorMsg = e.message;
      _hasError = true;
    }
    _isLoading = false;
    notifyListeners();
    return userModel;
  }

  Future<UserModel?> googleSignUpFunc(
    String? userType,
  ) async {
    _hasError = false;
    UserModel? userModel;
    try {
      userModel = await _firebaseAuthService.googleSignUp(userType);
    } on UnkownException catch (e) {
      _errorMsg = e.message;
      _hasError = true;
    }
    notifyListeners();
    return userModel;
  }

  Future<UserCredential?> signUpWithEmailPass(
    UserModel modelToPassData,
    String password,
  ) async {
    UserCredential? userCredentials;
    try {
      _isLoading = true;
      _hasError = false;
      userCredentials = await _firebaseAuthService.signUp(
        modelToPassData,
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

  Future<List<String>> forgotPassword(String email) async {
    var result;
    _isLoading = true;
    _hasError = false;
    try {
      result = await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
    } on UnkownException catch (e) {
      _errorMsg = e.message;
      _hasError = true;
    }
    _isLoading = false;
    notifyListeners();
    return result;
  }
}
