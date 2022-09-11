// ignore_for_file: non_constant_identifier_names

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_driver_app/services/firebase_auth_service.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthProviders with ChangeNotifier {
  final FirebaseAuthService _firebaseAuthService = FirebaseAuthService();
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  bool _isSignUpLoading = false;

  bool get isSignUpLoading => _isSignUpLoading;

  bool _isGoogleLoading = false;

  bool get isGoogleLoading => _isGoogleLoading;

  bool _isGoogleSignUpLoading = false;

  bool get isGoogleSignUpLoading => _isGoogleSignUpLoading;

  bool _isFacebookLoading = false;

  bool get isFacebookLoading => _isFacebookLoading;

  Future<UserCredential?> SignInWithEmailPass(
      String email, String password, BuildContext context) async {
    _isLoading = true;
    UserCredential? userCredentials;
    userCredentials = await _firebaseAuthService.signIn(
      email,
      password,
      context,
    );
    _isLoading = false;
    notifyListeners();
    return userCredentials;
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
    log(loginStatus.toString());
    _isFacebookLoading = false;
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
}
