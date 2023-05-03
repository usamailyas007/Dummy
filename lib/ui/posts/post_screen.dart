import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_dumy/ui/auth/login_screen.dart';
import 'package:firebase_dumy/ui/posts/add_post.dart';
import 'package:firebase_dumy/utils/utils.dart';
import 'package:flutter/material.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}
class _PostScreenState extends State<PostScreen> {
  final auth = FirebaseAuth.instance;
  final ref = FirebaseDatabase.instance.ref('Post');
  final searchController = TextEditingController();
  final editController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Posts'),
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: TextFormField(
        controller: searchController,
        decoration: InputDecoration(
            hintText: 'Search',
            border: OutlineInputBorder()
        ),
              onChanged: (String value){
          setState(() {

          });
              },
      ),
          ),
          Expanded(
            child: FirebaseAnimatedList(
              defaultChild: Text('Loading Data'),
                query: ref,
                itemBuilder: (context, snapshot, animation, index){
                  final title = snapshot.child('user').value.toString();
                  if(searchController.text.isEmpty){
                    return ListTile(
                      title: Text(snapshot.child('user').value.toString()),
                      subtitle: Text(snapshot.child('id').value.toString()),
                      trailing: PopupMenuButton(
                        child: Icon(Icons.more_vert),
                        itemBuilder: (context) => [
                        PopupMenuItem(
                            child: ListTile(
                          leading: Icon(Icons.edit),
                          title: Text('Edit'),
                              onTap: (){
                            Navigator.pop(context);
                                showMyDialoge(
                                  title, snapshot.child('id').value.toString()
                                );
                              },
                        ),value: 1,),
                          PopupMenuItem(child: ListTile(
                            leading: Icon(Icons.delete),
                            title: Text('Delete'),
                            onTap: (){
                              Navigator.pop(context);
                             ref.child( snapshot.child('id').value.toString()).remove();
                            },
                          ),
                          value: 1,)
                      ],),
                    );
                  }else if(title.toLowerCase().contains(searchController.text.toLowerCase().toLowerCase())){
                    return ListTile(
                      title: Text(snapshot.child('user').value.toString()),
                      subtitle: Text(snapshot.child('id').value.toString()),
                      trailing: PopupMenuButton(
                        child: Icon(Icons.more_vert),
                        itemBuilder: (context) => [
                          PopupMenuItem(child: ListTile(
                            leading: Icon(Icons.edit),
                            title: Text('Edit'),
                            onTap: (){
                              Navigator.pop(context);
                              showMyDialoge(title, snapshot.child('id').value.toString());
                            },
                          ),value: 1,),
                          PopupMenuItem(child: ListTile(
                            leading: Icon(Icons.delete),
                            title: Text('Delete'),
                            onTap: (){
                              Navigator.pop(context);
                              ref.child(snapshot.child('id').value.toString()).remove();
                            },
                          ),value: 1,)
                        ],
                      ),
                    );
                  }else{
                    return Container();
                  }
                }
            ),
          )
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
        child: FloatingActionButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => AddPostScreen(),));
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
            ref.child(id).update({
              'user' : editController.text.toString()
            }).then((value){
              utils().toastMessage('Post Updated');
            } ).onError((error, stackTrace) {
              utils().toastMessage(error.toString());
            });
          }, child: Text('Update'))
        ],
      );
    },);
  }
}
// Expanded(child: StreamBuilder(
// stream: ref.onValue,
// builder: (context ,AsyncSnapshot<DatabaseEvent> snapshot){
// if(!snapshot.hasData){
// return CircularProgressIndicator();
// }else{
// Map<dynamic, dynamic> map = snapshot.data!.snapshot.value as dynamic;
// List<dynamic> list = [];
// list.clear();
// list = map.values.toList();
// return ListView.builder(
// itemCount: snapshot.data!.snapshot.children.length,
// itemBuilder: (context, index) {
// return ListTile(
// title: Text(list[index]['user']),
// subtitle: Text(list[index]['id']),
// );
// },);
// }
//
//
// })),
