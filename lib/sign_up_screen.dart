import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nearby/firebase.dart';

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
                      if (value == null || value.isEmpty) {
                        return 'Field can not be empty';
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
                        return 'Field can not be empty';
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
                        return 'Field can not be empty';
                      }
                      return null;
                    },
                  ),
                  MaterialButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Authentication.signUp(_emailTextEditingController.text, _password1TextEditingController.text);
                      }
                    },
                    child: Text('Sign up'),
                  ),
                ],
              )),
          TextButton(
              onPressed: () {
                Navigator.popAndPushNamed(context, '/signIn');
              },
              child: Text('Sign in'))
        ],
      ),
    );
  }
}
