// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get_driver_app/models/user_model.dart';
import 'package:get_driver_app/providers/firestore_provider.dart';
import 'package:get_driver_app/widgets/snackbar_widget.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
  final FirestoreProvider _firestoreProvider = FirestoreProvider();
  final firestore = FirebaseFirestore.instance;

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

  Future<GoogleSignInAccount?> googleSignIn(BuildContext context) async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      SnackBarWidget.SnackBars(
          "Something went wrong try again", "assets/images/errorImg.png",
          context: context);
      return null;
    }
    _user = googleUser;
    SnackBarWidget.SnackBars(
        "Google login successful", "assets/images/successImg.png",
        context: context);
    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    await FirebaseAuth.instance.signInWithCredential(credential);
    return _user;
  }

  Future<UserCredential?> SignUp(
      String fName, String lName, String email, String password) async {
    UserCredential? userCredential;
    try {
      userCredential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      postDetailsToFireStore(
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
        await firestore
            .collection('Users')
            .doc(id)
            .snapshots()
            .first
            .then((value) {
          isEmpty = false;
          isEmpty = value.exists;
        });

        if (!isEmpty) {
          var n = requestData['name'].toString().split(" ");
          userModel.firstName = n[0];
          userModel.lastName = n[1];
          userModel.email = requestData['email'];
          userModel.id = id;
          userModel.photoUrl = requestData['picture']['data']['url'];
          await firestore.collection('Users').doc(id).set(userModel.toJson());
        } else {
          userModel = await _firestoreProvider.getUserData();
        }
      }
    } on FirebaseAuthException catch (e) {
      throw UnkownException('Something went wrong ${e.code} ${e.message}');
    }
    return userModel;
  }

  postDetailsToFireStore(
    String fName,
    String lName,
    String id,
    String email,
    String photoUrl,
    bool firstTime,
  ) async {
    try {
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      User? user = _auth.currentUser;
      UserModel userModel = UserModel();
      userModel.firstName = fName;
      userModel.lastName = lName;
      userModel.email = email;
      userModel.id = id;
      userModel.photoUrl = photoUrl;
      userModel.firstTime = firstTime;

      await firebaseFirestore
          .collection('Users')
          .doc(user?.uid)
          .set(userModel.toJson());

    } catch (e) {
      log(e.toString());
    }
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
      await firestore
          .collection('Users')
          .doc(firebaseUser?.uid)
          .snapshots()
          .first
          .then((value) {
        isEmpty = value.exists;
      });
      final name = _user!.displayName?.split(" ");
      if (!isEmpty) {
        userModel.firstName = name?[0];
        userModel.lastName = name?[1];
        userModel.email = _user?.email;
        userModel.id = firebaseUser?.uid;
        userModel.photoUrl = _user?.photoUrl;
        await firestore
            .collection('Users')
            .doc(firebaseUser?.uid)
            .set(userModel.toJson());
      } else {
        userModel = await _firestoreProvider.getUserData();
      }
    } catch (e) {
      log(e.toString());
    }
    return userModel;
  }
}
