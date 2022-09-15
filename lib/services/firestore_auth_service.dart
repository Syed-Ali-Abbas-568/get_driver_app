import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_driver_app/models/user_model.dart';

class FirestoreAuthService {


  Future<UserModel> getData() async {
    User? user = FirebaseAuth.instance.currentUser;

    final data = await FirebaseFirestore.instance
        .collection('Users')
        .doc(user?.uid)
        .get();

    return null;
  }
}
