
import 'package:firebase_dumy/ui/auth/login_screen.dart';
import 'package:flutter/material.dart';

import '../../widgets/round_button.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passController  = TextEditingController();


  @override
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
    passController.dispose();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Sign Up')),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        controller: emailController,
                        decoration: InputDecoration(
                            hintText: 'Emial',
                            prefixIcon: Icon(Icons.email)
                        ),
                        validator: (value){
                          if(value!.isEmpty){
                            return 'Enter Email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        controller: passController,
                        obscureText: true,
                        decoration: InputDecoration(
                            hintText: 'Password',
                            prefixIcon: Icon(Icons.lock_open)
                        ),
                        validator: (value){
                          if(value!.isEmpty){
                            return 'Enter Password';
                          }
                          return null;
                        },
                      ),
                    ],
                  )
              ),
              const SizedBox(
                height: 50,
              ),
              RoundedButton(title: 'Sign Up',onTap: (){
                if(_formKey.currentState!.validate()){

                }
              },),
              const SizedBox(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Already have an account '),
                  TextButton(onPressed: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginScreen(),));
                  }, child: Text('Log In'))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
