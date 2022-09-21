import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get_driver_app/models/user_model.dart';
import 'package:get_driver_app/providers/firestore_provider.dart';
import 'package:google_sign_in/google_sign_in.dart';

//TODO: imports statements needs to be organized

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
  final firebaseUser = _auth.currentUser;
  //TODO:
  //!ALERT: Do not use providers in services but use services in providers
  //Instead of using the providers here use FirestoreService here
  final FirestoreProvider _firestoreProvider = FirestoreProvider();
  final _firestore = FirebaseFirestore.instance;

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
  ) async {
    UserCredential? userCredential;
    try {
      userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      _firestoreProvider.postDetails(
        fName,
        lName,
        userCredential.user!.uid,
        email,
        "null",
        true,
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

  Future<UserModel?> facebookSignUp() async {
    UserModel? userModel = UserModel();
    try {
      LoginResult result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.success) {
        final requestData = await FacebookAuth.instance.getUserData();

        String? id = requestData['id'];

        bool isEmpty = false;
        isEmpty = await _firestoreProvider.isDataPresent(id!);
        if (!isEmpty) {
          var n = requestData['name'].toString().split(" ");
          userModel.firstName = n[0];
          userModel.lastName = n[1];
          userModel.email = requestData['email'];
          userModel.id = id;
          userModel.photoUrl = requestData['picture']['data']['url'];
          _firestoreProvider.uploadSignUpDetails(userModel, id);
        } else {
          userModel = await _firestoreProvider.getUserData();
        }
      }
    } on FirebaseAuthException catch (e) {
      throw UnkownException('Something went wrong ${e.code} ${e.message}');
    }
    return userModel;
  }

  Future<UserModel?> googleSignUp() async {
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
      isEmpty = await _firestoreProvider.isDataPresent(firebaseUser!.uid);
      final name = _user!.displayName?.split(" ");
      if (!isEmpty) {
        userModel.firstName = name?[0];
        userModel.lastName = name?[1];
        userModel.email = _user?.email;
        userModel.id = firebaseUser.uid;
        userModel.photoUrl = _user?.photoUrl;
        _firestoreProvider.uploadSignUpDetails(userModel, firebaseUser.uid);
      } else {
        userModel = await _firestoreProvider.getUserData();
      }
    } catch (e) {
      log(e.toString());
    }
    return userModel;
  }
}
