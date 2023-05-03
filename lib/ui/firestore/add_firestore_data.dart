import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_dumy/ui/posts/post_screen.dart';
import 'package:firebase_dumy/utils/utils.dart';
import 'package:firebase_dumy/widgets/round_button.dart';
import 'package:flutter/material.dart';

class AddFirestoreData extends StatefulWidget {
  const AddFirestoreData({Key? key}) : super(key: key);

  @override
  State<AddFirestoreData> createState() => _AddFirestoreDataState();
}

class _AddFirestoreDataState extends State<AddFirestoreData> {
  bool loading = false;
  final addPostController = TextEditingController();
  final fireStore = FirebaseFirestore.instance.collection('User');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Firestore Data'),
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
              String id = DateTime.now().millisecondsSinceEpoch.toString();
              fireStore.doc(id).set({
                'Title' : addPostController.text.toString(),
                'id' : id
              }).then((value) {
                setState(() {
                  loading = false;
                });
                utils().toastMessage('Post Added');
              }).onError((error, stackTrace) {
                setState(() {
                  loading = false;
                });
                utils().toastMessage(error.toString());
              });
            })
          ],
        ),
      ),
    );
  }
}
