import 'package:ern_u/auth/auth_widgets/test_widgets.dart';
import 'package:ern_u/auth/register.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/app_colors.dart';
import '../constants/primary_button.dart';
import 'auth_widgets/password_test_field.dart';
import 'auth_widgets/text_form_field.dart';

class LoginScreen extends StatelessWidget {

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
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SizedBox(
            width: 327,
            height: 500,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
                      // validator: (value) {
                      //   if (value == null || value.isEmpty) {
                      //     return 'Please enter your email address';
                      //   } else if (!value.contains("@")) {
                      //     return 'Email does not contain @';
                      //   }
                      //   return null;
                      // },
                      borderRadius: BorderRadius.circular(24),
                      hintText: 'abc@gmail.com',
                      controller: emailC,
                      width: 327,
                      height: 52
                  )
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
              const SizedBox(height: 20),
              Column(
                children: [
                  PrimaryButton(
                    elevation: 0,
                    onTap: () {},
                    text: 'Log - in',
                    bgColor: AppColor.kPrimary,
                    borderRadius: 20,
                    height: 46,
                    width: 327,
                    textColor: AppColor.kWhite,
                  ),
                  const SizedBox(height: 20),
                  CustomRichText(
                    title: 'New User? ',
                    subtitle: 'create an Account ',
                    onTab: () => Get.to(RegisterScreen()),
                    subtitleTextStyle: GoogleFonts.acme(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColor.kWhite)
                        .copyWith(
                        color: AppColor.kGrayscaleDark100,
                        fontWeight: FontWeight.w600,
                        fontSize: 14),
                  )
                ],
              ),
            ]),
          ),
        ),
      ),
    );
  }
}















