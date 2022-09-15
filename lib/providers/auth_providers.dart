// ignore_for_file: non_constant_identifier_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_driver_app/services/firebase_auth_service.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthProvider with ChangeNotifier {
  final _firebaseAuthService = FirebaseAuthService();

  bool _isLoading = false;
  bool _hasError = false;
  // bool _isProfileCreation = false;
  // bool _isSignUpLoading = false;
  // bool _isGoogleLoading = false;
  bool _isGoogleSignUpLoading = false;
  bool _isFacebookLoading = false;
  String _errorMsg = '';

  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  String get errorMsg => _errorMsg;
  bool get isSignUpLoading => _isSignUpLoading;
  bool get isGoogleLoading => _isGoogleLoading;
  bool get isFacebookLoading => _isFacebookLoading;
  bool get isProfileCreation => _isProfileCreation;
  bool get isGoogleSignUpLoading => _isGoogleSignUpLoading;

  Future<void> signInWithEmailPassword(String email, String password) async {
    _isLoading = true;
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

  Future<GoogleSignInAccount?> GoogleSignInFunc(BuildContext context) async {
    _isGoogleLoading = true;
    GoogleSignInAccount? googleSignInAccount =
        await _firebaseAuthService.googleSignIn(context);
    _isGoogleLoading = false;
    notifyListeners();
    return googleSignInAccount;
  }

  Future<Map<String, dynamic>?> FacebookSignIn(BuildContext context) async {
    _isFacebookLoading = true;
    Map<String, dynamic>? loginStatus =
        await _firebaseAuthService.facebookLogin(context);
    _isFacebookLoading = false;
    notifyListeners();
    return loginStatus;
  }

  Future<Map<String, dynamic>?> FacebookSignUp(BuildContext context) async {
    Map<String, dynamic>? loginStatus =
        await _firebaseAuthService.facebookSignUp(context);
    notifyListeners();
    return loginStatus;
  }

  Future<GoogleSignInAccount?> GoogleSignUpFunc(BuildContext context) async {
    _isGoogleSignUpLoading = true;
    GoogleSignInAccount? googleSignInAccount =
        await _firebaseAuthService.googleSignUp(context);
    _isGoogleSignUpLoading = false;
    notifyListeners();
    return googleSignInAccount;
  }

  Future<UserCredential?> SignUpWithEmailPass(String fName, String lName,
      String email, String password, BuildContext context) async {
    _isSignUpLoading = true;
    UserCredential? userCredentials;
    userCredentials = await _firebaseAuthService.SignUp(
      fName,
      lName,
      email,
      password,
      context,
    );
    _isSignUpLoading = false;
    notifyListeners();
    return userCredentials;
  }

  profileCreation(String date, int experience, int CNIC, int license, int phone,
      BuildContext context) async {
    _isProfileCreation = true;

    _firebaseAuthService.postUserInfo(
        date, experience, CNIC, license, phone, context);
    _isProfileCreation = false;
    notifyListeners();
  }
}
