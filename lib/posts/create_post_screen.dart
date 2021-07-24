import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_neumorphic_null_safety/flutter_neumorphic.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nearby/location_methods.dart';
import 'package:nearby/posts/post.dart';
import 'package:uuid/uuid.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({Key? key}) : super(key: key);

  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: NeumorphicAppBar(
          title: const Text('New post'),
          centerTitle: true,
          actions: [
            NeumorphicButton(
              onPressed: () async {

                //BAD PRACTISE ERROR
                try {
                  if (_image != null) {
                    String? geoHash = await LocationMethods.getGeoHash();

                    if(geoHash != null){
                      TaskSnapshot taskSnapshot = await FirebaseStorage.instance.ref(const Uuid().v1()).putFile(_image!);
                      String imageUrl = await taskSnapshot.ref.getDownloadURL();

                      Post post = Post(FirebaseAuth.instance.currentUser!.uid, _textEditingController.text.toString(), Timestamp.now(), imageUrl, geoHash);

                      await FirebaseFirestore.instance.collection('posts').add(post.toMap());

                      Navigator.of(context).pop();
                    }else{
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Your location is unknown')));
                    }
                  }
                } on FirebaseException {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Can not upload the post')));
                }
              },
              child: const Icon(Icons.done),
            )
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(8.0),
          children: [
            Neumorphic(
                style: NeumorphicStyle(depth: -8.0, boxShape: NeumorphicBoxShape.roundRect(const BorderRadius.all(Radius.circular(8)))),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                  child: TextField(
                    controller: _textEditingController,
                    decoration: const InputDecoration(
                      hintText: 'Type something',
                      border: InputBorder.none,
                    ),
                    maxLines: 5,
                  ),
                )),
            const SizedBox(height: 8.0),
            if (_image == null)
              Row(
                children: [
                  Expanded(
                    child: NeumorphicButton(
                      child: const Center(child: Text('Gallery')),
                      onPressed: pickImageFromGallery,
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(child: NeumorphicButton(child: const Center(child: Text('Camera')), onPressed: pickImageFromCamera))
                ],
              )
            else
              Neumorphic(
                style: NeumorphicStyle(boxShape: NeumorphicBoxShape.roundRect(const BorderRadius.all(Radius.circular(8.0)))),
                child: Stack(
                  children: [
                    Image.file(
                      _image!,
                      fit: BoxFit.cover,
                      height: MediaQuery.of(context).size.width,
                      width: MediaQuery.of(context).size.width,
                    ),
                    Positioned(
                      right: 0,
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            _image = null;
                          });
                        },
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              )
          ],
        ));
  }

  Future pickImageFromCamera() async {
    XFile? image = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (image != null) {
        _image = File(image.path);
      }
    });
  }

  Future pickImageFromGallery() async {
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (image != null) {
        _image = File(image.path);
      }
    });
  }
}
