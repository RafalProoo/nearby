import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
                      if (value == null || value.isEmpty || !EmailValidator.validate(value)) {
                        return 'Incorrect address email';
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
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        try {
                          await FirebaseAuth.instance
                              .signInWithEmailAndPassword(email: _emailTextEditingController.text, password: _passwordTextEditingController.text);
                          Navigator.popAndPushNamed(context, '/home');
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'user-not-found') {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No user found for that email')));
                          } else if (e.code == 'wrong-password') {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Wrong password provided for that user')));
                          }
                        }
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
