import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_dumy/utils/utils.dart';
import 'package:firebase_dumy/widgets/round_button.dart';
import 'package:flutter/material.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  bool loading = false;
  final addPostController = TextEditingController();
  final databaseRef = FirebaseDatabase.instance.ref('Post');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('What\'s new'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: 30,),
            TextFormField(
              controller: addPostController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'What is in your mind?',
                border: OutlineInputBorder()
              ),
            ),
            SizedBox(height: 30,),
            RoundedButton(title: 'Add Post',loading: loading, onTap: (){
              setState(() {
                loading = true;
              });
              databaseRef.child(DateTime.now().millisecondsSinceEpoch.toString()).set({
                'user' : addPostController.text.toString(),
                'id' : DateTime.now().millisecondsSinceEpoch.toString()
              }).then((value){
                utils().toastMessage('Post Added');
                setState(() {
                  loading = false;
                });
              }).onError((error, stackTrace) {
                utils().toastMessage(error.toString());
                setState(() {
                  loading = false;
                });
              });
            })
          ],
        ),
      ),
    );
  }
}
