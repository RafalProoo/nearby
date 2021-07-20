import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_null_safety/flutter_neumorphic.dart';

class SignUpScreen extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailTextEditingController = TextEditingController();
  final TextEditingController _password0TextEditingController = TextEditingController();
  final TextEditingController _password1TextEditingController = TextEditingController();

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
                        controller: _password0TextEditingController,
                        decoration: const InputDecoration(hintText: 'Password', border: InputBorder.none),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password must contain at least 8 characters';
                          }

                          if (!value.contains(RegExp('[A-Z]'))) {
                            return 'Password must contain at least 1 uppercase letter';
                          }

                          if (!value.contains(RegExp('[a-z]'))) {
                            return 'Password must contain at least 1 lowercase letter';
                          }

                          if (!value.contains(RegExp('[0-9]'))) {
                            return 'Password must contain at least 1 digit';
                          }

                          if (!value.contains(RegExp(r'[!@#$%^&*]'))) {
                            return 'Password must contain at least 1 special character [!@#\$%^&*]';
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
                        controller: _password1TextEditingController,
                        decoration: const InputDecoration(hintText: 'Password', border: InputBorder.none),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password must contain at least 8 characters';
                          }

                          if (!value.contains(RegExp('[A-Z]'))) {
                            return 'Password must contain at least 1 uppercase letter';
                          }

                          if (!value.contains(RegExp('[a-z]'))) {
                            return 'Password must contain at least 1 lowercase letter';
                          }

                          if (!value.contains(RegExp('[0-9]'))) {
                            return 'Password must contain at least 1 digit';
                          }

                          if (!value.contains(RegExp(r'[!@#$%^&*]'))) {
                            return 'Password must contain at least 1 special character [!@#\$%^&*]';
                          }

                          if (_password0TextEditingController.text != _password1TextEditingController.text) {
                            return 'Passwords must be the same';
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
                              await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _emailTextEditingController.text, password: _password1TextEditingController.text);
                              Navigator.pushNamed(context, '/signIn');
                            } on FirebaseAuthException catch (e) {
                              if (e.code == 'email-already-in-use') {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('The account already exists for that email')));
                              }
                            }
                          }
                        },
                        child: const Center(child: Text('Sign up')),
                      ),
                    ),
                  ],
                )),
            TextButton(
                onPressed: () {
                  Navigator.popAndPushNamed(context, '/signIn');
                },
                child: const Text('Sign in'))
          ],
        ),
      ),
    );
  }
}
