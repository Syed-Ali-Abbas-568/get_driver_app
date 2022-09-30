import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:get_driver_app/models/user_model.dart';
import 'package:get_driver_app/services/firestore_service.dart';

class WrongPasswordException implements Exception {
  final String message;

  WrongPasswordException(this.message);
}

class UserNotFoundException implements Exception {
  final String message;

  UserNotFoundException(this.message);
}

class EmailAlreadyExistException implements Exception {
  final String message;

  EmailAlreadyExistException(this.message);
}

class UnkownException implements Exception {
  final String message;

  UnkownException(this.message);
}

class FirebaseAuthService {
  static final _auth = FirebaseAuth.instance;
  User? firebaseUser = _auth.currentUser;
  final FirestoreService _firestoreServices = FirestoreService();

  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['Email']);
  GoogleSignInAccount? _user;

  GoogleSignInAccount? get user => _user;

  Future<void> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        throw WrongPasswordException('You have entered a wrong password');
      } else if (e.code == 'user-not-found') {
        throw UserNotFoundException('User not found');
      } else {
        throw UnkownException('Something went wrong ${e.code} ${e.message}');
      }
    }
  }

  Future<UserCredential?> signUp(
    String fName,
    String lName,
    String email,
    String password,
    String? userType,
  ) async {
    UserCredential? userCredential;
    try {
      userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      _firestoreServices.postDetailsToFireStore(
        fName,
        lName,
        userCredential.user!.uid,
        email,
        null,
        userType,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw EmailAlreadyExistException('Email already in use');
      } else {
        throw UnkownException('Something went wrong ${e.code} ${e.message}');
      }
    }
    return userCredential;
  }

  Future<UserModel?> facebookSignUp(String? userType) async {
    UserModel? userModel;
    try {
      final LoginResult loginResult = await FacebookAuth.instance.login();
      if (loginResult.accessToken == null) return null;
      final credential = FacebookAuthProvider.credential(
        loginResult.accessToken!.token,
      );

      final userCred = await _auth.signInWithCredential(credential);

      if (loginResult.status == LoginStatus.success) {
        String? id = userCred.user!.uid;
        bool isPresent = await _firestoreServices.isPresent(id);
        if (!isPresent) {
          final n = userCred.user?.displayName?.split(' ');
          userModel = UserModel(
            firstName: n![0],
            lastName: n[1],
            email: userCred.user?.email,
            id: userCred.user?.uid,
            photoUrl: userCred.user?.photoURL,
            userType: userType,
          );
          await _firestoreServices.uploadSignUpInfo(userModel, id);
        } else {
          userModel = await _firestoreServices.getData();
        }
      }
    } on FirebaseAuthException catch (e) {
      throw UnkownException('Something went wrong ${e.code} ${e.message}');
    }
    return userModel;
  }

  Future<UserModel?> googleSignUp(String? userType) async {
    UserModel? userModel = UserModel();
    try {
      final googleUser = await _googleSignIn.signIn();

      _user = googleUser;

      final googleAuth = await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      User? firebaseUser = FirebaseAuth.instance.currentUser;
      bool isEmpty = false;
      isEmpty = await _firestoreServices.isPresent(firebaseUser!.uid);
      final name = _user!.displayName?.split(" ");
      if (!isEmpty) {
        userModel.firstName = name?[0];
        userModel.lastName = name?[1];
        userModel.email = _user?.email;
        userModel.id = firebaseUser.uid;
        userModel.photoUrl = _user?.photoUrl;
        userModel.userType = userType;
        _firestoreServices.uploadSignUpInfo(userModel, firebaseUser.uid);
      } else {
        userModel = await _firestoreServices.getData();
      }
    } on FirebaseAuthException catch (e) {
      throw UnkownException(
        "Something went wrong, ${e.message} || ${e.code}",
      );
    }
    return userModel;
  }
}
