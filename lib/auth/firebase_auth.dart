import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ern_u/constants/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../home_page/home_page.dart';
import 'login.dart';


Future<void> createAccount(String firstName, String lastName, String email, String password) async {


  if(firstName.isEmpty || lastName.isEmpty || email.isEmpty || password.isEmpty) {
    showCustomSnackbar(
      icon: Icons.error_outline_outlined,
      title: 'Validation Error',
      message: 'field required',
      backgroundColor: AppColor.kErrorColors,
      iconColor: Colors.white,
      position: SnackPosition.TOP,
      duration: const Duration(seconds: 3),
    );
    return;
  }

  try{
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Create the user account
    UserCredential userCredential = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );


    // Add user details to Firestore
    await firestore.collection('users').doc(userCredential.user!.uid).set({
      'name': firstName,
      'phone': lastName,
      'email': email,
    });


    showCustomSnackbar(
      icon: Icons.check_box_rounded,
      title: 'Success',
      message: 'Account created successfully',
      backgroundColor: AppColor.kSuccessColor,
      iconColor: Colors.white,
      position: SnackPosition.TOP,
      duration: const Duration(seconds: 3),
    );
    Get.to(() => LoginScreen());

  } on FirebaseAuthException catch (e) {
    switch (e.code) {
      case 'weak-password':
        showCustomSnackbar(
          icon: Icons.error_outline_outlined,
          title: 'Validation Error',
          message: 'The password provided is too weak.',
          backgroundColor: AppColor.kErrorColors,
          iconColor: Colors.white,
          position: SnackPosition.TOP,
          duration: const Duration(seconds: 3),
        );
        break;
      case 'email-already-in-use':

        showCustomSnackbar(
          icon: Icons.error_outline_outlined,
          title: 'Error',
          message: 'The account already exists for that email.',
          backgroundColor: AppColor.kErrorColors,
          iconColor: Colors.white,
          position: SnackPosition.TOP,
          duration: const Duration(seconds: 3),
        );
        break;
      case 'invalid-email':

        showCustomSnackbar(
          icon: Icons.error_outline_outlined,
          title: 'Error',
          message: 'The email address is not valid.',
          backgroundColor: AppColor.kErrorColors,
          iconColor: Colors.white,
          position: SnackPosition.TOP,
          duration: const Duration(seconds: 3),
        );
        break;
      case 'operation-not-allowed':
        showCustomSnackbar(
          icon: Icons.error_outline_outlined,
          title: 'Error',
          message: 'operation not allowed.',
          backgroundColor: AppColor.kErrorColors,
          iconColor: Colors.white,
          position: SnackPosition.TOP,
          duration: const Duration(seconds: 3),
        );
        break;
      case 'user-disabled':

        showCustomSnackbar(
          icon: Icons.error_outline_outlined,
          title: 'Error',
          message: 'This user has been disabled. Please contact support.',
          backgroundColor: AppColor.kErrorColors,
          iconColor: Colors.white,
          position: SnackPosition.TOP,
          duration: const Duration(seconds: 3),
        );
        break;
      default:

        showCustomSnackbar(
          icon: Icons.error_outline_outlined,
          title: 'Error',
          message: 'An error occurred: ${e.message}',
          backgroundColor: AppColor.kErrorColors,
          iconColor: Colors.white,
          position: SnackPosition.TOP,
          duration: const Duration(seconds: 3),
        );
    }
  }
}





// user log-in
Future<void> loginUser(String email, String password, BuildContext context) async {

  if (email.isEmpty || password.isEmpty) {

    showCustomSnackbar(
      icon: Icons.error_outline_outlined,
      title: 'Validation Error',
      message: 'field required',
      backgroundColor: AppColor.kErrorColors,
      iconColor: Colors.white,
      position: SnackPosition.TOP,
      duration: const Duration(seconds: 3),
    );
    return;
  }

  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);

    showCustomSnackbar(
      icon: Icons.check_box_rounded,
      title: 'Log-in Success',
      message: 'user successfully log-in',
      backgroundColor: AppColor.kSuccessColor,
      iconColor: Colors.white,
      position: SnackPosition.TOP,
      duration: const Duration(seconds: 3),
    );




    Get.off(const HomePage());

  } on FirebaseAuthException catch (e) {

    switch (e.code) {
      case 'wrong-password':
        showCustomSnackbar(
          icon: Icons.error_outline_outlined,
          title: 'Validation Error',
          message: 'The password provided is too weak.',
          backgroundColor: AppColor.kErrorColors,
          iconColor: Colors.white,
          position: SnackPosition.TOP,
          duration: const Duration(seconds: 3),
        );
        break;
      case 'email-already-in-use':
        showCustomSnackbar(
          icon: Icons.error_outline_outlined,
          title: 'Error',
          message: 'The account already exists for that email.',
          backgroundColor: AppColor.kErrorColors,
          iconColor: Colors.white,
          position: SnackPosition.TOP,
          duration: const Duration(seconds: 3),
        );
        break;
      case 'invalid-email':
        showCustomSnackbar(
          icon: Icons.error_outline_outlined,
          title: 'Error',
          message: 'The email address is not valid.',
          backgroundColor: AppColor.kErrorColors,
          iconColor: Colors.white,
          position: SnackPosition.TOP,
          duration: const Duration(seconds: 3),
        );
        break;
      case 'user-disabled':

        showCustomSnackbar(
          icon: Icons.error_outline_outlined,
          title: 'Error',
          message: 'This user has been disabled. Please contact support.',
          backgroundColor: AppColor.kErrorColors,
          iconColor: Colors.white,
          position: SnackPosition.TOP,
          duration: const Duration(seconds: 3),
        );
        break;
      default:
    }
    showCustomSnackbar(
      icon: Icons.error_outline_outlined,
      title: 'Error',
      message: 'An error occurred: ${e.message}',
      backgroundColor: AppColor.kErrorColors,
      iconColor: Colors.white,
      position: SnackPosition.TOP,
      duration: const Duration(seconds: 3),
    );
  } catch (e) {
    showCustomSnackbar(
      icon: Icons.error_outline_outlined,
      title: 'Error',
      message: 'An error occurred: $e',
      backgroundColor: AppColor.kErrorColors,
      iconColor: Colors.white,
      position: SnackPosition.TOP,
      duration: const Duration(seconds: 3),
    );
  }
}



void showCustomSnackbar({
  required String title,
  required String message,
  required IconData icon,
  Color backgroundColor = Colors.white10,
  Color iconColor = Colors.white,
  SnackPosition position = SnackPosition.BOTTOM,
  Duration duration = const Duration(seconds: 3),
}) {
  Get.snackbar(
    title,
    message,
    backgroundColor: backgroundColor,
    icon: Icon(icon, color: iconColor),
    snackPosition: position,
    duration: duration,
    colorText: Colors.white,
    borderRadius: 10,
    margin: const EdgeInsets.all(10),
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
    shouldIconPulse: false,
  );
}