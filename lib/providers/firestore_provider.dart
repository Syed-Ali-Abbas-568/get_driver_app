import 'package:flutter/material.dart';
import 'package:get_driver_app/models/user_model.dart';
import 'package:get_driver_app/services/firestore_service.dart';

class FirestoreProvider with ChangeNotifier {
  final FirestoreService _firestoreAuthService = FirestoreService();

  Future<UserModel?> getUserData() {
    return _firestoreAuthService.getData();
  }
}
