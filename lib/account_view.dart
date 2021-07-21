import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_neumorphic_null_safety/flutter_neumorphic.dart';

class AccountView extends StatelessWidget {
  const AccountView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
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
        )
      ],
    );
  }
}
