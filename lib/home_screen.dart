import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'firebase.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text(FirebaseAuth.instance.currentUser.toString()),
          MaterialButton(
            child: const Text('Sign out'),
            onPressed: () {
              Authentication.signOut();
              Navigator.popAndPushNamed(context, '/signIn');
            },
          ),
        ],
      ),
    );
  }
}
