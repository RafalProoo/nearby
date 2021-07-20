import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_null_safety/flutter_neumorphic.dart';

class SignInScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailTextEditingController = TextEditingController();
  final TextEditingController _passwordTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
                key: _formKey,
                child: Column(
                  children: [
                    Neumorphic(
                      style: const NeumorphicStyle(depth: -8.0),
                      padding: const EdgeInsets.fromLTRB(30,5,30,5),
                      child: TextFormField(
                        controller: _emailTextEditingController,
                        decoration: const InputDecoration(hintText: 'Email', border: InputBorder.none),
                        validator: (value) {
                          if (value == null || value.isEmpty || !EmailValidator.validate(value)) {
                            return 'Incorrect address email';
                          }

                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Neumorphic(
                      style: const NeumorphicStyle(depth: -8.0),
                      padding: const EdgeInsets.fromLTRB(30,5,30,5),
                      child: TextFormField(
                        controller: _passwordTextEditingController,
                        decoration: const InputDecoration(hintText: 'Password', border: InputBorder.none),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Field can not be empty';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    SizedBox(
                      width: double.infinity,
                      child: NeumorphicButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            try {
                              await FirebaseAuth.instance.signInWithEmailAndPassword(email: _emailTextEditingController.text, password: _passwordTextEditingController.text);
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
                        child: const Center(child: Text('Sign in')),
                      ),
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
      ),
    );
  }
}
