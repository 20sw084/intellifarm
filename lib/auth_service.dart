import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import 'controller/references.dart';

class AuthService{
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  signUp(String email, String password, String phoneNumber) async {
    try {
      final UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      try {
        References ref = References();
        ref.usersRef.add({
          'email': email,
          'password': password,
          'phonenum': phoneNumber,
        });
      }
      catch (e){
        print(e);
      }
      return userCredential.user;
    }
    catch (e){
      if (kDebugMode) {
        print(e);
      }
    }
  }

  signIn(String email, String password) async {
    try {
      final UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    }
    catch (e){
      if (kDebugMode) {
        print(e);
      }
    }
  }
  Future<QuerySnapshot?> signInAsFarmer(String uniqueNumber) async {
    try {
      QuerySnapshot farmerSnapshot = await FirebaseFirestore.instance
          .collection("farmers")
          .where("loginCode", isEqualTo: uniqueNumber)
          .get();

      // Return the QuerySnapshot if found
      return farmerSnapshot;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      // Return null if an error occurs
      return null;
    }
  }
}