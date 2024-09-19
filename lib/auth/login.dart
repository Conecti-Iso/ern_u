import 'package:ern_u/auth/auth_widgets/test_widgets.dart';
import 'package:ern_u/auth/register.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/app_colors.dart';
import '../constants/image_path.dart';
import '../constants/primary_button.dart';
import 'auth_widgets/forget_password.dart';
import 'auth_widgets/password_test_field.dart';
import 'auth_widgets/text_form_field.dart';
import 'firebase_auth.dart';

class LoginScreen extends StatefulWidget {

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailC = TextEditingController();
  TextEditingController passwordC = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.kWhite,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(ImagesPath.kLogo,height: 200),
                Text(
                  'Login',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.actor(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ).copyWith(
                      color: AppColor.kGrayscaleDark100,
                      fontWeight: FontWeight.w600,
                      fontSize: 24),
                ),
                const SizedBox(height: 15),
                Text(
                  'We happy to see you again.',
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

                const SizedBox(
                  height: 15,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 7),
                    PrimaryTextFormField(
                        borderRadius: BorderRadius.circular(24),
                        hintText: 'Email',
                        controller: emailC,
                        width: double.infinity,
                        height: 52
                    )
                  ],
                ),
                const SizedBox(height: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    PasswordTextField(
                        borderRadius: BorderRadius.circular(24),
                        hintText: 'Password',
                        controller: passwordC,
                        width: double.infinity,
                        height: 52)
                  ],
                ),
                const SizedBox(height: 20),
                Column(
                  children: [
                    PrimaryButton(
                      elevation: 0,
                      onTap: () async {
                        setState(() {
                          isLoading = true;
                        });

                        try{
                         await loginUser(
                              emailC.text,
                              passwordC.text,context
                          );
                        }catch (e) {
                          Get.snackbar(
                              'Error', 'Failed to create account: $e');
                        }finally{
                          setState(() {
                            isLoading = false;
                          });
                        }
                      },
                      text: 'Log - in',
                      bgColor: AppColor.kPrimary,
                      borderRadius: 20,
                      height: 46,
                      width: double.infinity,
                      textColor: AppColor.kWhite,
                    ),
                    const SizedBox(height: 20),
                    CustomRichText(
                      title: 'New User? ',
                      subtitle: 'create an Account ',
                      onTab: () => Get.to(const RegisterScreen()),
                      subtitleTextStyle: GoogleFonts.acme(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColor.kWhite)
                          .copyWith(
                          color: AppColor.kGrayscaleDark100,
                          fontWeight: FontWeight.w600,
                          fontSize: 14
                      ),
                    ),
                    const SizedBox(height: 20),
                    CustomRichText(
                      title: 'Lost password? ',
                      subtitle: 'create a new one ',
                      onTab: () => Get.to( ForgotPasswordPage()),
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
              ]),
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
    ]
      ),
    );
  }
}















