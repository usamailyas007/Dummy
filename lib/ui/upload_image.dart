import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_dumy/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../widgets/round_button.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class UploadImageScreen extends StatefulWidget {
  const UploadImageScreen({Key? key}) : super(key: key);

  @override
  State<UploadImageScreen> createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
  File? _image;
  bool loading = false;
  final picker = ImagePicker();

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  DatabaseReference databaseRef = FirebaseDatabase.instance.ref('Post');

  Future getGalleryImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print("No image Picked");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Upload Image'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: InkWell(
              onTap: () {
                getGalleryImage();
              },
              child: Container(
                height: 200,
                width: 200,
                child: _image != null
                    ? Image.file(_image!.absolute)
                    : Center(child: Icon(Icons.image,size: 100,)),
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.black)),
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 100),
            child: RoundedButton(
              loading: loading,
                title: 'Upload',
                onTap: () async {
                  setState(() {
                    loading = true;
                  });
                  firebase_storage.Reference ref = firebase_storage
                      .FirebaseStorage.instance
                      .ref("foldername/"+DateTime.now().millisecondsSinceEpoch.toString());
                  firebase_storage.UploadTask uploadTask = ref.putFile(_image!.absolute);
                  Future.value(uploadTask).then((value) async {
                    var newUrl = await ref.getDownloadURL();

                    databaseRef.child('1').set({
                      'id' : '1212',
                      'user' : newUrl.toString()
                    }).then((value){
                      setState(() {
                        loading = false;
                      });
                      utils().toastMessage('Uploaded');

                    } ).onError((error, stackTrace) {
                      loading = false;
                      utils().toastMessage(error.toString());
                    });
                  }).onError((error, stackTrace) {
                    utils().toastMessage(error.toString());
                  });
                }),
          )
        ],
      ),
    );
  }
}
