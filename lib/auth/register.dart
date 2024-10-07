import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../constants/app_colors.dart';
import '../constants/image_path.dart';
import 'auth_widgets/test_widgets.dart';
import 'auth_widgets/text_form_field.dart';
import 'auth_widgets/password_test_field.dart';
import 'firebase_auth.dart';
import 'login.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;
  bool isLoading = false;

  File? _image;
  final picker = ImagePicker();
  String? _imageUrl;

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });

    if (_image != null) {
      try {
        setState(() {
          isLoading = true;
        });

        // Upload image to Firebase Storage
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('profile_images/${DateTime.now().millisecondsSinceEpoch}');
        final uploadTask = storageRef.putFile(_image!);
        final snapshot = await uploadTask.whenComplete(() {});

        // Get the download URL
        _imageUrl = await snapshot.ref.getDownloadURL();

        setState(() {
          isLoading = false;
        });
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        Get.snackbar('Error', 'Failed to upload image: $e');
      }
    }
  }

  String? selectedRole = 'senior member?';
  final List<String> roleOptions = [
    'senior member?',
    'Senior Member',
    'Senior Staff'
  ];

  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController passwordC = TextEditingController();
  TextEditingController staffIDC = TextEditingController();
  TextEditingController departmentC = TextEditingController();
  TextEditingController contactC = TextEditingController();
  TextEditingController roleC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.kWhite,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Create Account',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColor.kGrayscaleDark100,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(children: [
        Stepper(
          type: StepperType.horizontal,
          currentStep: _currentStep,
          onStepContinue: () async {
            if (_currentStep < 1) {
              setState(() => _currentStep += 1);
            } else {
              // Handle form submission
              setState(() {
                isLoading = true;
              });

              try {
                await createAccount(
                    firstName.text,
                    lastName.text,
                    emailC.text,
                    passwordC.text,
                    staffIDC.text,
                    departmentC.text,
                    contactC.text,
                    roleC.text,
                    _imageUrl!
                );
              } catch (e) {
                Get.snackbar(
                    'Error', 'Please check and upload a profile image');
              } finally {
                setState(() {
                  isLoading = false;
                });
              }
            }
          },
          onStepCancel: () {
            if (_currentStep > 0) {
              setState(() => _currentStep -= 1);
            }
          },
          controlsBuilder: (BuildContext context, ControlsDetails details) {
            return Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  if (_currentStep > 0)
                    TextButton(
                      onPressed: details.onStepCancel,
                      child: Text('<< Back',
                          style: TextStyle(color: AppColor.kPrimary)),
                    ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: details.onStepContinue,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.kPrimary),
                    child: Text(_currentStep < 1 ? 'Next' : 'Submit',
                        style: const TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            );
          },
          steps: [
            Step(
              stepStyle: StepStyle(
                  errorColor: Colors.red,
                  color: AppColor.kPrimary,
                  connectorColor: Colors.green),
              title: const Text('Personal'),
              content: Column(
                children: [
                  _buildProfileAvatar(),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: PrimaryTextFormField(
                          borderRadius: BorderRadius.circular(5),
                          hintText: 'First Name',
                          height: 50,
                          width: 100,
                          controller: firstName,
                          keyboardType: TextInputType.text,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: PrimaryTextFormField(
                          borderRadius: BorderRadius.circular(5),
                          hintText: 'Last Name',
                          keyboardType: TextInputType.text,
                          controller: lastName,
                          height: 50,
                          width: 100,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  PrimaryTextFormField(
                      borderRadius: BorderRadius.circular(24),
                      hintText: 'Email',
                      keyboardType: TextInputType.emailAddress,
                      controller: emailC,
                      width: double.infinity,
                      height: 52),
                  const SizedBox(height: 10),
                  PasswordTextField(
                      borderRadius: BorderRadius.circular(24),
                      hintText: 'Password',
                      controller: passwordC,
                      width: double.infinity,
                      height: 52)
                ],
              ),
              isActive: _currentStep >= 0,
            ),
            Step(
                stepStyle: StepStyle(
                    errorColor: Colors.red,
                    color: AppColor.kPrimary,
                    connectorColor: Colors.green),
                title: const Text('Work'),
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PrimaryTextFormField(
                      borderRadius: BorderRadius.circular(12),
                      hintText: 'Staff ID',
                      controller: staffIDC,
                      height: 50,
                      width: double.infinity,
                    ),
                    const SizedBox(height: 20),
                    PrimaryTextFormField(
                      keyboardType: TextInputType.text,
                      borderRadius: BorderRadius.circular(12),
                      hintText: 'Department/Section/Units',
                      controller: departmentC,
                      height: 50,
                      width: double.infinity,
                    ),
                    const SizedBox(height: 20),

                    PrimaryTextFormField(
                      borderRadius: BorderRadius.circular(12),
                      hintText: 'Phone',
                      keyboardType: TextInputType.phone,
                      controller: contactC,
                      height: 50,
                      width: double.infinity,
                    ),
                    // _buildRoleDropdown(),
                    const SizedBox(height: 20),

                    PrimaryTextFormField(
                      borderRadius: BorderRadius.circular(50),
                      keyboardType: TextInputType.text,
                      hintText: 'Rank',
                      controller: roleC,
                      height: 50,
                      width: double.infinity,
                    ),
                    const Text(
                        "Please Tell Us Your Rank. Eg: senior member or senior staff",
                        style: TextStyle(fontSize: 10)),

                    const SizedBox(height: 20),
                    Center(
                      child: CustomRichText(
                        title: 'Already have an account? ',
                        subtitle: '  Log In',
                        onTab: () => Get.to(LoginScreen()),
                        subtitleTextStyle: GoogleFonts.acme(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: AppColor.kWhite)
                            .copyWith(
                                color: AppColor.kGrayscaleDark100,
                                fontWeight: FontWeight.w600,
                                fontSize: 10),
                      ),
                    )
                  ],
                ),
                isActive: _currentStep >= 1)
          ],
        ),
        if (isLoading)
          Container(
            color: Colors.black.withOpacity(0.5),
            child: const Center(
                child: SizedBox(
                    height: 100,
                    width: 100,
                    child: Card(
                        child: Center(child: CircularProgressIndicator())))),
          ),
      ]),
    );
  }

  Widget _buildProfileAvatar() {
    return Center(
      child: _image == null
          ? Stack(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage(ImagesPath.kProfileImage),
                  radius: 50,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColor.kPrimary,
                      shape: BoxShape.circle,
                    ),
                    child: GestureDetector(
                      onTap: getImage,
                      child: const Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ),
              ],
            )
          : Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.file(_image!,
                      fit: BoxFit.cover, width: 100, height: 100),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColor.kPrimary,
                      shape: BoxShape.circle,
                    ),
                    child: GestureDetector(
                      onTap: getImage,
                      child: const Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildRoleDropdown() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        hintText: "Select Role",
      ),
      items: roleOptions.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          selectedRole = newValue;
        });
      },
      value: selectedRole,
    );
  }
}
