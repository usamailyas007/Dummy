import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dumy/utils/utils.dart';
import 'package:firebase_dumy/widgets/round_button.dart';
import 'package:flutter/material.dart';

import 'auth/login_screen.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final forgotController = TextEditingController();
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Forgot Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            TextFormField(
              controller: forgotController,
              decoration: InputDecoration(
                hintText: "Email"
              ),
            ),
            SizedBox(
              height: 40,
            ),
            RoundedButton(title: 'Forgot', onTap: (){
              auth.sendPasswordResetEmail(email: forgotController.text.toString()).then((value) {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen(),));
                utils().toastMessage('we have sent you email to recover passwod, please check email');
              }).onError((error, stackTrace) {
                utils().toastMessage(error.toString());
              });
            })

          ],
        ),
      ),
    );
  }
}
