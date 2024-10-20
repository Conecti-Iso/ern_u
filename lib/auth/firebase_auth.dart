import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ern_u/auth/register.dart';
import 'package:ern_u/constants/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../home_page/buttom_navigation.dart';
import '../home_page/vc_memo_list.dart';
import 'login.dart';


Future<void> createAccount(
    String firstName,
    String lastName,
    String email,
    String password,
    String staffID,
    String department,
    String contact,
    String role,
    String imageUrl


    ) async {
  if(
  firstName.isEmpty || lastName.isEmpty || email.isEmpty || password.isEmpty || staffID.isEmpty
  || department.isEmpty || contact.isEmpty || role.isEmpty || imageUrl.isEmpty) {
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
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'staffID': staffID,
      'department': department,
      'contact': contact,
      'role': role,
      'userId': userCredential.user?.uid,
      'profileImageUrl': imageUrl,
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
    Get.to(() => const LoginScreen());

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





// // user log-in
// Future<void> loginUser(String email, String password, BuildContext context) async {
//   FirebaseAuth auth = FirebaseAuth.instance;
//   FirebaseFirestore firestore = FirebaseFirestore.instance;
//
//   if (email.isEmpty || password.isEmpty) {
//
//     showCustomSnackbar(
//       icon: Icons.error_outline_outlined,
//       title: 'Validation Error',
//       message: 'field required',
//       backgroundColor: AppColor.kErrorColors,
//       iconColor: Colors.white,
//       position: SnackPosition.TOP,
//       duration: const Duration(seconds: 3),
//     );
//     return;
//   }
//
//   try {
//     // await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
//
//     UserCredential userCredential = await auth.signInWithEmailAndPassword(
//       email: email,
//       password: password,
//     );
//     await redirectUser(userCredential.user!.uid);
//
//     Future<void> redirectUser(String uid) async {
//       DocumentSnapshot userDoc = await firestore.collection('users').doc(uid).get();
//
//       if (userDoc.exists) {
//         Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
//
//         if (userData['isVC'] == true) {
//           Get.offAll(() => const VCDashBoard());
//         } else {
//           Get.offAll(() => const NavigationHome());
//         }
//       }
//     }
//
//     Future<void> checkLoginStatus() async {
//       User? user = auth.currentUser;
//       if (user != null) {
//         await _redirectUser(user.uid);
//       } else {
//         Get.offAll(() => const SignInScreen());
//       }
//     }
//
//     showCustomSnackbar(
//       icon: Icons.check_box_rounded,
//       title: 'Log-in Success',
//       message: 'user successfully log-in',
//       backgroundColor: AppColor.kSuccessColor,
//       iconColor: Colors.white,
//       position: SnackPosition.TOP,
//       duration: const Duration(seconds: 3),
//     );
//
//     Get.off(const NavigationHome());
//
//   } on FirebaseAuthException catch (e) {
//
//     switch (e.code) {
//       case 'wrong-password':
//         showCustomSnackbar(
//           icon: Icons.error_outline_outlined,
//           title: 'Validation Error',
//           message: 'The password provided is too weak.',
//           backgroundColor: AppColor.kErrorColors,
//           iconColor: Colors.white,
//           position: SnackPosition.TOP,
//           duration: const Duration(seconds: 3),
//         );
//         break;
//       case 'email-already-in-use':
//         showCustomSnackbar(
//           icon: Icons.error_outline_outlined,
//           title: 'Error',
//           message: 'The account already exists for that email.',
//           backgroundColor: AppColor.kErrorColors,
//           iconColor: Colors.white,
//           position: SnackPosition.TOP,
//           duration: const Duration(seconds: 3),
//         );
//         break;
//       case 'invalid-email':
//         showCustomSnackbar(
//           icon: Icons.error_outline_outlined,
//           title: 'Error',
//           message: 'The email address is not valid.',
//           backgroundColor: AppColor.kErrorColors,
//           iconColor: Colors.white,
//           position: SnackPosition.TOP,
//           duration: const Duration(seconds: 3),
//         );
//         break;
//       case 'user-disabled':
//
//         showCustomSnackbar(
//           icon: Icons.error_outline_outlined,
//           title: 'Error',
//           message: 'This user has been disabled. Please contact support.',
//           backgroundColor: AppColor.kErrorColors,
//           iconColor: Colors.white,
//           position: SnackPosition.TOP,
//           duration: const Duration(seconds: 3),
//         );
//         break;
//       default:
//     }
//     showCustomSnackbar(
//       icon: Icons.error_outline_outlined,
//       title: 'Error',
//       message: 'An error occurred: ${e.message}',
//       backgroundColor: AppColor.kErrorColors,
//       iconColor: Colors.white,
//       position: SnackPosition.TOP,
//       duration: const Duration(seconds: 3),
//     );
//   } catch (e) {
//     showCustomSnackbar(
//       icon: Icons.error_outline_outlined,
//       title: 'Error',
//       message: 'An error occurred: $e',
//       backgroundColor: AppColor.kErrorColors,
//       iconColor: Colors.white,
//       position: SnackPosition.TOP,
//       duration: const Duration(seconds: 3),
//     );
//   }
// }

Future<void> loginUser(String email, String password, BuildContext context) async {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  if (email.isEmpty || password.isEmpty) {
    showCustomSnackbar(
      icon: Icons.error_outline_outlined,
      title: 'Validation Error',
      message: 'Fields are required',
      backgroundColor: AppColor.kErrorColors,
      iconColor: Colors.white,
      position: SnackPosition.TOP,
      duration: const Duration(seconds: 3),
    );
    return;
  }

  try {
    UserCredential userCredential = await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    await redirectUser(userCredential.user!.uid);

    showCustomSnackbar(
      icon: Icons.check_box_rounded,
      title: 'Log-in Success',
      message: 'User successfully logged in',
      backgroundColor: AppColor.kSuccessColor,
      iconColor: Colors.white,
      position: SnackPosition.TOP,
      duration: const Duration(seconds: 3),
    );
  } on FirebaseAuthException catch (e) {
    handleFirebaseAuthError(e);
  } catch (e) {
    showCustomSnackbar(
      icon: Icons.error_outline_outlined,
      title: 'Error',
      message: 'An unexpected error occurred: $e',
      backgroundColor: AppColor.kErrorColors,
      iconColor: Colors.white,
      position: SnackPosition.TOP,
      duration: const Duration(seconds: 3),
    );
  }
}

Future<void> redirectUser(String uid) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  DocumentSnapshot userDoc = await firestore.collection('users').doc(uid).get();

  if (userDoc.exists) {
    Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
    if (userData['isVC'] == true) {
      Get.offAll(() => const VCMemList());
    } else {
      Get.offAll(() => const NavigationHome());
    }
  } else {
    Get.offAll(() => const RegisterScreen());
  }
}

void handleFirebaseAuthError(FirebaseAuthException e) {
  String message = 'An error occurred';
  switch (e.code) {
    case 'wrong-password':
      message = 'The password provided is incorrect.';
      break;
    case 'email-already-in-use':
      message = 'The account already exists for this email.';
      break;
    case 'invalid-email':
      message = 'The email address is not valid.';
      break;
    case 'user-disabled':
      message = 'This user has been disabled. Please contact support.';
      break;
    default:
      message = 'An error occurred: ${e.message}';
  }

  showCustomSnackbar(
    icon: Icons.error_outline_outlined,
    title: 'Error',
    message: message,
    backgroundColor: AppColor.kErrorColors,
    iconColor: Colors.white,
    position: SnackPosition.TOP,
    duration: const Duration(seconds: 3),
  );
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