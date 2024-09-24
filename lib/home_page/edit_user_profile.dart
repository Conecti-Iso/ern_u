// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:ern_u/constants/app_colors.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// class EditProfilePage extends StatefulWidget {
//   const EditProfilePage({Key? key}) : super(key: key);
//
//   @override
//   _EditProfilePageState createState() => _EditProfilePageState();
// }
//
// class _EditProfilePageState extends State<EditProfilePage> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseStorage _storage = FirebaseStorage.instance;
//
//   final TextEditingController _firstNameController = TextEditingController();
//   final TextEditingController _lastNameController = TextEditingController();
//   final TextEditingController _staffIDController = TextEditingController();
//   final TextEditingController _roleController = TextEditingController();
//   final TextEditingController _departmentController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _contactController = TextEditingController();
//
//   File? _imageFile;
//   String? _currentImageUrl;
//   bool _isLoading = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadUserData();
//   }
//
//   Future<void> _loadUserData() async {
//     setState(() => _isLoading = true);
//     try {
//       User? user = _auth.currentUser;
//       if (user != null) {
//         DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();
//         if (userDoc.exists) {
//           var userData = userDoc.data() as Map<String, dynamic>;
//           setState(() {
//             _firstNameController.text = userData['firstName'] ?? '';
//             _lastNameController.text = userData['lastName'] ?? '';
//             _staffIDController.text = userData['staffID'] ?? '';
//             _roleController.text = userData['role'] ?? '';
//             _departmentController.text = userData['department'] ?? '';
//             _emailController.text = userData['email'] ?? '';
//             _contactController.text = userData['contact'] ?? '';
//             _currentImageUrl = userData['profileImageUrl'];
//           });
//         }
//       }
//     } catch (e) {
//       print('Error loading user data: $e');
//     }
//     setState(() => _isLoading = false);
//   }
//
//   Future<void> _pickImage() async {
//     final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() {
//         _imageFile = File(pickedFile.path);
//       });
//     }
//   }
//
//   Future<void> _updateProfile() async {
//     setState(() => _isLoading = true);
//     try {
//       User? user = _auth.currentUser;
//       if (user != null) {
//         String imageUrl = _currentImageUrl ?? '';
//         if (_imageFile != null) {
//           String fileName = 'profile_${user.uid}.jpg';
//           Reference storageRef = _storage.ref().child('profile_images/$fileName');
//           await storageRef.putFile(_imageFile!);
//           imageUrl = await storageRef.getDownloadURL();
//         }
//
//         await _firestore.collection('users').doc(user.uid).update({
//           'firstName': _firstNameController.text,
//           'lastName': _lastNameController.text,
//           'staffID': _staffIDController.text,
//           'role': _roleController.text,
//           'department': _departmentController.text,
//           'email': _emailController.text,
//           'contact': _contactController.text,
//           'profileImageUrl': imageUrl,
//         });
//
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Profile updated successfully')),
//         );
//       }
//     } catch (e) {
//       print('Error updating profile: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to update profile')),
//       );
//     }
//     setState(() => _isLoading = false);
//   }
//
//   Widget _buildTextField(TextEditingController controller, String label, IconData icon) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: TextFormField(
//         controller: controller,
//         decoration: InputDecoration(
//           labelText: label,
//           prefixIcon: Icon(icon, color: AppColor.kPrimary),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: BorderSide(color: AppColor.kPrimary),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: BorderSide(color: AppColor.kPrimary, width: 2),
//           ),
//           filled: true,
//           fillColor: Colors.white,
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Edit Profile', style: GoogleFonts.acme(color: Colors.white)),
//         backgroundColor: AppColor.kPrimary,
//         elevation: 0,
//       ),
//       body: _isLoading
//           ? Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Container(
//               height: 200,
//               decoration: BoxDecoration(
//                 color: AppColor.kPrimary,
//                 borderRadius: BorderRadius.only(
//                   bottomLeft: Radius.circular(30),
//                   bottomRight: Radius.circular(30),
//                 ),
//               ),
//               child: Center(
//                 child: GestureDetector(
//                   onTap: _pickImage,
//                   child: CircleAvatar(
//                     radius: 70,
//                     backgroundColor: Colors.white,
//                     child: CircleAvatar(
//                       radius: 65,
//                       backgroundImage: _imageFile != null
//                           ? FileImage(_imageFile!) as ImageProvider
//                           : (_currentImageUrl != null
//                           ? NetworkImage(_currentImageUrl!)
//                           : AssetImage('assets/default_profile.png')) as ImageProvider,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 children: [
//                   _buildTextField(_firstNameController, 'First Name', Icons.person),
//                   _buildTextField(_lastNameController, 'Last Name', Icons.person),
//                   _buildTextField(_staffIDController, 'Staff ID', Icons.badge),
//                   _buildTextField(_roleController, 'Role', Icons.work),
//                   _buildTextField(_departmentController, 'Department', Icons.business),
//                   _buildTextField(_emailController, 'Email', Icons.email),
//                   _buildTextField(_contactController, 'Contact', Icons.phone),
//                   SizedBox(height: 20),
//                   ElevatedButton(
//                     onPressed: _updateProfile,
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
//                       child: Text('Update Profile', style: TextStyle(fontSize: 18)),
//                     ),
//                     style: ElevatedButton.styleFrom(
//                       foregroundColor: Colors.white, backgroundColor: AppColor.kPrimary,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(30),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }



import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:ern_u/constants/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _staffIDController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();
  final TextEditingController _departmentController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();

  File? _imageFile;
  String? _currentImageUrl;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() => _isLoading = true);
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          var userData = userDoc.data() as Map<String, dynamic>;
          setState(() {
            _firstNameController.text = userData['firstName'] ?? '';
            _lastNameController.text = userData['lastName'] ?? '';
            _staffIDController.text = userData['staffID'] ?? '';
            _roleController.text = userData['role'] ?? '';
            _departmentController.text = userData['department'] ?? '';
            _emailController.text = userData['email'] ?? '';
            _contactController.text = userData['contact'] ?? '';
            _currentImageUrl = userData['profileImageUrl'];
          });
        }
      }
    } catch (e) {
      print('Error loading user data: $e');
    }
    setState(() => _isLoading = false);
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _updateProfile() async {
    setState(() => _isLoading = true);
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        String imageUrl = _currentImageUrl ?? '';
        if (_imageFile != null) {
          String fileName = 'profile_${user.uid}.jpg';
          Reference storageRef = _storage.ref().child('profile_images/$fileName');
          await storageRef.putFile(_imageFile!);
          imageUrl = await storageRef.getDownloadURL();
        }

        await _firestore.collection('users').doc(user.uid).update({
          'firstName': _firstNameController.text,
          'lastName': _lastNameController.text,
          'staffID': _staffIDController.text,
          'role': _roleController.text,
          'department': _departmentController.text,
          'email': _emailController.text,
          'contact': _contactController.text,
          'profileImageUrl': imageUrl,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully')),
        );
      }
    } catch (e) {
      print('Error updating profile: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile')),
      );
    }
    setState(() => _isLoading = false);
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: AppColor.kPrimary),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColor.kPrimary),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColor.kPrimary, width: 2),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile', style: GoogleFonts.acme(color: Colors.white)),
        backgroundColor: AppColor.kPrimary,
        elevation: 0,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: AppColor.kPrimary,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 70,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 65,
                      backgroundImage: _imageFile != null
                          ? FileImage(_imageFile!) as ImageProvider
                          : (_currentImageUrl != null
                          ? NetworkImage(_currentImageUrl!)
                          : AssetImage('assets/default_profile.png')) as ImageProvider,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildTextField(_firstNameController, 'First Name', Icons.person),
                  _buildTextField(_lastNameController, 'Last Name', Icons.person),
                  _buildTextField(_staffIDController, 'Staff ID', Icons.badge),
                  _buildTextField(_roleController, 'Role', Icons.work),
                  _buildTextField(_departmentController, 'Department', Icons.business),
                  _buildTextField(_emailController, 'Email', Icons.email),
                  _buildTextField(_contactController, 'Contact', Icons.phone),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _updateProfile,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                      child: Text('Update Profile', style: TextStyle(fontSize: 18)),
                    ),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: AppColor.kPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}