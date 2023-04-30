import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dumy/ui/posts/post_screen.dart';
import 'package:firebase_dumy/widgets/round_button.dart';
import 'package:flutter/material.dart';

import '../../utils/utils.dart';

class VerifyCodeScreen extends StatefulWidget {
  final String verificationId;
  const VerifyCodeScreen({Key? key, required this.verificationId}) : super(key: key);

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  bool loading = false;
  final VerificationController = TextEditingController();
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Login')),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            TextFormField(
              controller: VerificationController,

              decoration: InputDecoration(hintText: "123456"),
            ),
            SizedBox(
              height: 50,
            ),
            RoundedButton(
                loading: loading,
                title: 'Verify',
                onTap: ()async {
                  setState(() {
                    loading = true;
                  });
                  final credential = PhoneAuthProvider.credential(
                      verificationId: widget.verificationId,
                      smsCode: VerificationController.text.toString()
                  );
                  try{
                    await auth.signInWithCredential(credential);
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PostScreen(),));
                  }catch(e){
                    setState(() {
                      loading = false;
                    });
                    utils().toastMessage(e.toString());
                  }

                })
          ],
        ),
      ),
    );
  }
}
