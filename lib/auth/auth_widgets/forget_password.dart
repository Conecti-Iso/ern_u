import 'package:ern_u/auth/auth_widgets/text_form_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/image_path.dart';
import '../../constants/primary_button.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  final FirebaseAuth _auth =  FirebaseAuth.instance;

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
      ),
      body: Stack(
        children:[ SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(ImagesPath.kForgetPassword,height: 300),

                const SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PrimaryTextFormField(
                        borderRadius: BorderRadius.circular(24),
                        hintText: 'Email',
                        controller: _emailController,
                        width: double.infinity,
                        height: 52
                    ),
                    const Text(
                      'Enter your email to reset your password',
                      style: TextStyle(fontSize: 10),
                    ),
                  ],
                ),

                SizedBox(height: 20),

                PrimaryButton(
                  elevation: 0,
                  onTap: () async {
                    setState(() {
                      isLoading = true;
                    });

                    if(_emailController.text.isEmpty){
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('please enter your email')),
                      );
                    }

                    try {
                      await _auth.sendPasswordResetEmail(email: _emailController.text);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Password reset email sent')),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: ${e.toString()}')),
                      );
                    }finally{
                      setState(() {
                        isLoading = false;
                      });
                    }
                  },
                  text: 'Reset Password',
                  bgColor: AppColor.kPrimary,
                  borderRadius: 20,
                  height: 46,
                  width: double.infinity,
                  textColor: AppColor.kWhite,
                ),
              ],
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
            ]
      ),
    );
  }
}


