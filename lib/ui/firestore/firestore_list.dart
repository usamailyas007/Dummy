import 'package:cloud_firestore/cloud_firestore.dart';
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
  final fireStore = FirebaseFirestore.instance.collection('User').snapshots();
  final updateController = TextEditingController();
  CollectionReference ref = FirebaseFirestore.instance.collection('User');

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
          StreamBuilder(
            stream: fireStore,
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
              if(snapshot.connectionState == ConnectionState.waiting )
                return CircularProgressIndicator();
              if(snapshot.hasError)
                return Text('Some Error');
              return Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final title = snapshot.data!.docs[index]['Title'].toString();
                    return ListTile(
                      title: Text(snapshot.data!.docs[index]['Title'].toString()),
                      subtitle: Text(snapshot.data!.docs[index]['id'].toString()),
                      trailing: PopupMenuButton(
                        child: Icon(Icons.more_vert),
                          itemBuilder: (context) => [
                            PopupMenuItem(
                                child: ListTile(
                                  leading: Icon(Icons.edit),
                                  title: Text('Edit'),
                                  onTap: (){
                                    Navigator.pop(context);
                                    messageDialoge(title, snapshot.data!.docs[index]['id'].toString());
                                  },
                            ),value: 1,),
                            PopupMenuItem(
                                child: ListTile(
                                  leading: Icon(Icons.delete),
                                  title: Text('Delete'),
                                  onTap: (){
                                    Navigator.pop(context);
                                    ref.doc( snapshot.data!.docs[index]['id'].toString()).delete();
                                  },
                                ),value: 1,),
                          ],),
                    );
                  },),
              );
              }),
          // Expanded(
          //   child: ListView.builder(
          //     itemCount: 10,
          //     itemBuilder: (context, index) {
          //     return ListTile(
          //       title: Text('Usama'),
          //     );
          //   },),
          // )
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
  Future<void> messageDialoge (String title,String id) async{
    return showDialog(context: context, builder: (context){
      updateController.text = title;
      return AlertDialog(
        title: Text('Update'),
        content: Container(
          child: TextFormField(
            controller: updateController,
            decoration: InputDecoration(
                hintText: 'Update'
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: (){
            Navigator.pop(context);
          }, child: Text('Cancel')),
          TextButton(onPressed: (){
            Navigator.pop(context);
            ref.doc(id).update({
              'Title' : updateController.text.toString()
            }).then((value) {
              utils().toastMessage('Post Updated');
            }).onError((error, stackTrace) {
              utils().toastMessage(error.toString());
            });
          }, child: Text('Update'))
        ],
      );
    });
  }
}
