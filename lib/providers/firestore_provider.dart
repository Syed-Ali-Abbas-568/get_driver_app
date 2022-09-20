import 'package:flutter/material.dart';
import 'package:get_driver_app/models/user_model.dart';
import 'package:get_driver_app/services/firestore_service.dart';

class FirestoreProvider with ChangeNotifier {
  final FirestoreService _firestoreAuthService = FirestoreService();

  bool _hasFirestoreError = false;
  String _FirestoreErrorMsg = '';
  bool _isProfileCreation = false;
  bool get isProfileCreation => _isProfileCreation;

  bool get hasFirestoreError => _hasFirestoreError;

  String get FirestoreErrorMsg => _FirestoreErrorMsg;
//TODO: Naming convention not following :(

  Future<UserModel?> getUserData() async {
//*IMPORTANT: Function type and the returning value (name) is not matching  :(

    var name = await _firestoreAuthService.getData();
    // print(name);
    return name;
  }

//TODO: Trailing commas not used :(

  Future<void> uploadRemainingData(String photoUrl, String date, int experience,
      int cnic, int license, String phone) async {
    try {
      _isProfileCreation = true;
      _firestoreAuthService.UpdateData(
          photoUrl, date, experience, cnic, license, phone);
    } on UnkownFirestoreException {
      _FirestoreErrorMsg = 'Something went wrong';
      _hasFirestoreError = true;
    }
    _isProfileCreation = false;
    notifyListeners();
  }
}
