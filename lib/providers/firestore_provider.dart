import 'package:flutter/material.dart';
import 'package:get_driver_app/services/firestore_auth_service.dart';

class FirestoreProvider with ChangeNotifier{
  final FirestoreAuthService _firestoreAuthService=FirestoreAuthService();

 Map<String, dynamic>? getUserData(){
    return _firestoreAuthService.getData();
  }

}