import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_neumorphic_null_safety/flutter_neumorphic.dart';
import 'package:nearby/posts/post.dart';

class AccountView extends StatefulWidget {
  const AccountView({Key? key}) : super(key: key);

  @override
  _AccountViewState createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
  final List<Post> _posts = [];

  @override
  void initState() {
    super.initState();
    getUserPosts();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: () {
          return getUserPosts();
        },
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverList(
                  delegate: SliverChildListDelegate([
                const Icon(Icons.account_circle, size: 128, color: Color(0xff1b58ca)),
                Center(
                    child: Text(
                  FirebaseAuth.instance.currentUser!.email.toString(),
                  style: const TextStyle(fontSize: 20, color: Colors.black87),
                )),
                TextButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.popAndPushNamed(context, '/signIn');
                  },
                  child: const Text(
                    'Sign out',
                    style: TextStyle(color: Color(0xff1b58ca)),
                  ),
                ),
              ])),
              SliverGrid(
                  delegate: SliverChildBuilderDelegate((context, index) => Image.network(_posts[index].image!), childCount: _posts.length),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 2.0, mainAxisSpacing: 2.0)),
            ],
          ),
        ));
  }

  getUserPosts() async {
    CollectionReference posts = FirebaseFirestore.instance.collection('posts');
    QuerySnapshot querySnapshot = await posts.where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid).get();

    List<Post> list = querySnapshot.docs
        .map(((document) => Post(
              document['uid'],
              document['text'],
              document['timestamp'],
              document['image'],
              document['location'],
            )))
        .toList();

    setState(() {
      _posts.clear();
      _posts.addAll(list);
    });
  }
}
