import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailTextEditingController = TextEditingController();
  final TextEditingController _password0TextEditingController = TextEditingController();
  final TextEditingController _password1TextEditingController = TextEditingController();

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
                    controller: _password0TextEditingController,
                    decoration: const InputDecoration(hintText: 'Password'),
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
                  TextFormField(
                    controller: _password1TextEditingController,
                    decoration: const InputDecoration(hintText: 'Password'),
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
                  MaterialButton(
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
                    child: const Text('Sign up'),
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
    );
  }
}
