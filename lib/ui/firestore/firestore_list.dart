import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_dumy/ui/auth/login_screen.dart';
import 'package:firebase_dumy/ui/firestore/add_firestore_data.dart';
import 'package:firebase_dumy/ui/posts/add_post.dart';
import 'package:firebase_dumy/utils/utils.dart';
import 'package:flutter/material.dart';

class FirestoreScreen extends StatefulWidget {
  const FirestoreScreen({Key? key}) : super(key: key);

  @override
  State<FirestoreScreen> createState() => _FirestoreScreenState();
}

class _FirestoreScreenState extends State<FirestoreScreen> {
  final auth = FirebaseAuth.instance;
  final editController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Firestore'),
        actions: [
          IconButton(onPressed: (){
            auth.signOut().then((value) {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen(),));
            });
          }, icon: Icon(Icons.logout_outlined)),
          SizedBox(width: 10 ,)
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 10,),
          Expanded(
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
              return ListTile(
                title: Text('Usama'),
              );
            },),
          )
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
        child: FloatingActionButton(
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => AddFirestoreData(),));
          },child: Icon(Icons.add),),
      ),
    );
  }
  Future<void> showMyDialoge(String title, String id)async{
    editController.text = title;
    return showDialog(context: context, builder: (context) {
      return AlertDialog(
        title: Text('Update'),
        content: Container(
          child: TextFormField(
            controller: editController,
            decoration: InputDecoration(
                hintText: 'Update'
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: (){
            Navigator.pop(context);
          }, child: Text("Cancel")),
          TextButton(onPressed: (){
            Navigator.pop(context);
          }, child: Text('Update'))
        ],
      );
    },);
  }
}
