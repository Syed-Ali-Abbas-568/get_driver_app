import 'package:flutter/rendering.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:get_driver_app/models/user_model.dart';
import 'package:get_driver_app/services/firebase_auth_service.dart';

class FirestoreService {
  final _firestore = FirebaseFirestore.instance;

  Future<UserModel?> getData() async {
    User? user = FirebaseAuthService().firebaseUser;
    UserModel? myUser;
    try {
      final data = await _firestore.collection('Users').doc(user?.uid).get();
      myUser = UserModel.fromJson(data.data()!);
    } catch (e) {
      debugPrint(e.toString());
    }

    return myUser;
  }
}
