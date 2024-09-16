import 'package:ern_u/auth/auth_widgets/test_widgets.dart';
import 'package:ern_u/auth/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/app_colors.dart';
import '../constants/primary_button.dart';
import 'auth_widgets/password_test_field.dart';
import 'auth_widgets/text_form_field.dart';
import 'firebase_auth.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  String? _emailError;

  TextEditingController firstName = TextEditingController();
  TextEditingController listName = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController passwordC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.kWhite,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(children: [
        SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: 327,
                child: Column(children: [
                  Text(
                    'Create Account',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ).copyWith(
                        color: AppColor.kGrayscaleDark100,
                        fontWeight: FontWeight.w600,
                        fontSize: 24),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'We happy to see you. Sign Up to your account',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.aBeeZee(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColor.kWhite)
                        .copyWith(
                            color: AppColor.kGrayscale40,
                            fontWeight: FontWeight.w600,
                            fontSize: 14),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'First Name',
                            style: GoogleFonts.plusJakartaSans(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: AppColor.kWhite)
                                .copyWith(
                                    color: AppColor.kGrayscaleDark100,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14
                            ),
                          ),
                          const SizedBox(height: 8),
                          PrimaryTextFormField(

                              borderRadius: BorderRadius.circular(24),
                              hintText: 'John',
                              controller: firstName,
                              width: 155,
                              height: 52)
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Last Name',
                            style: GoogleFonts.plusJakartaSans(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: AppColor.kWhite)
                                .copyWith(
                                    color: AppColor.kGrayscaleDark100,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          PrimaryTextFormField(

                              borderRadius: BorderRadius.circular(24),
                              hintText: 'Doe',
                              controller: listName,
                              width: 155,
                              height: 52)
                        ],
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Email',
                        style: GoogleFonts.plusJakartaSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppColor.kWhite)
                            .copyWith(
                                color: AppColor.kGrayscaleDark100,
                                fontWeight: FontWeight.w600,
                                fontSize: 14),
                      ),
                      const SizedBox(height: 7),
                      PrimaryTextFormField(

                          borderRadius: BorderRadius.circular(24),
                          hintText: 'john.doe@gmail.com',
                          controller: emailC,
                          width: 327,
                          height: 52
                      ),
                      if (_emailError != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            _emailError!,
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Password',
                        style: GoogleFonts.plusJakartaSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppColor.kWhite)
                            .copyWith(
                                color: AppColor.kGrayscaleDark100,
                                fontWeight: FontWeight.w600,
                                fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      PasswordTextField(
                          borderRadius: BorderRadius.circular(24),
                          hintText: 'Password',
                          controller: passwordC,
                          width: 327,
                          height: 52)
                    ],
                  ),
                  const SizedBox(height: 28),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: TermsAndPrivacyText(
                      title1: '  By signing up you agree to our',
                      title2: ' Terms ',
                      title3: '  and',
                      title4: ' Conditions of Use',
                    ),
                  ),
                  const SizedBox(height: 20),
                  Column(
                    children: [
                      PrimaryButton(
                        elevation: 5,
                        onTap: () async {

                            setState(() {
                              isLoading = true;
                            });

                            try {
                              await createAccount(
                                firstName.text,
                                listName.text,
                                emailC.text,
                                passwordC.text,
                              );

                            } catch (e) {
                              // Handle errors
                              Get.snackbar(
                                  'Error', 'Failed to create account: $e');
                            } finally {
                              setState(() {
                                isLoading = false;
                              });
                            }

                        },
                        text: 'Create Account',
                        bgColor: AppColor.kPrimary,
                        borderRadius: 20,
                        height: 46,
                        width: 327,
                        textColor: AppColor.kWhite,
                      ),
                      const SizedBox(height: 20),
                      CustomRichText(
                        title: 'Already have an account? ',
                        subtitle: '  Log In',
                        onTab: () => Get.to(LoginScreen()),
                        subtitleTextStyle: GoogleFonts.acme(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppColor.kWhite)
                            .copyWith(
                                color: AppColor.kGrayscaleDark100,
                                fontWeight: FontWeight.w600,
                                fontSize: 14
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 23),
                ]),
              ),
            ),
          ),
        ),
        if (isLoading)
          Container(
            color: Colors.black.withOpacity(0.5),
            child:
                const Center(child: SizedBox(
                    height: 100,
                    width: 100,
                    child: Card(child: Center(child: CircularProgressIndicator())))),
          ),
      ]),
    );
  }
}
