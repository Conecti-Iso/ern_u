import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';


Future<void> createAccount(String firstName, String lastName, String email, String password) async {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;


  // Create the user account
  UserCredential userCredential = await auth.createUserWithEmailAndPassword(
    email: email,
    password: password,
  );

  // Get the FCM token
  // String? fcmToken = await FirebaseMessaging.instance.getToken();

  // Add user details to Firestore
  await firestore.collection('users').doc(userCredential.user!.uid).set({
    'name': firstName,
    'phone': lastName,
    'email': email,
  });
}
