import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nearby/firebase.dart';

class SignInScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailTextEditingController = TextEditingController();
  final TextEditingController _passwordTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        shrinkWrap: true,
        children: [
          Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _emailTextEditingController,
                    decoration: const InputDecoration(hintText: 'Email'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Field can not be empty';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _passwordTextEditingController,
                    decoration: const InputDecoration(hintText: 'Password'),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Field can not be empty';
                      }
                      return null;
                    },
                  ),
                  MaterialButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Future<UserCredential> uc = Authentication.signIn(_emailTextEditingController.text, _passwordTextEditingController.text);
                        uc.whenComplete(() => Navigator.popAndPushNamed(context, '/home'));
                      }
                    },
                    child: const Text('Sign in'),
                  ),
                ],
              )),
          TextButton(
              onPressed: () {
                Navigator.popAndPushNamed(context, '/signUp');
              },
              child: const Text('Sign up'))
        ],
      ),
    );
  }
}
