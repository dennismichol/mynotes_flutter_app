import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/popup_views/alert_popup.dart';
import 'package:mynotes/popup_views/email_verify_popup.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: 'Enter your email here',
            ),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(
              hintText: 'Enter your password here',
            ),
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;

              try {
                await FirebaseAuth.instance.createUserWithEmailAndPassword(
                  email: email,
                  password: password,
                );
                final user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  await user.sendEmailVerification();
                  await showEmailVerifyPopup(context);
                }
              } on FirebaseAuthException catch (e) {
                switch (e.code) {
                  case 'weak-password':
                    const title = Text('Weak password');
                    const message = Text(
                        'Weak password detected. Please use a stronger password.');
                    final textButtonsList = [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                        child: const Text('Ok'),
                      ),
                    ];
                    await showPopup(
                      context,
                      title,
                      message,
                      textButtonsList,
                    );
                    break;
                  case 'email-already-in-use':
                    const title = Text('Email already in use');
                    const message = Text(
                        'Email entered is already in use. Please login instead.');
                    final textButtonsList = [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                        child: const Text('Ok'),
                      ),
                    ];
                    await showPopup(
                      context,
                      title,
                      message,
                      textButtonsList,
                    );
                    break;
                  case 'invalid-email':
                    const title = Text('Invalid email');
                    const message = Text('Email address is invalid.');
                    final textButtonsList = [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                        child: const Text('Ok'),
                      ),
                    ];
                    await showPopup(
                      context,
                      title,
                      message,
                      textButtonsList,
                    );
                    break;
                }
              }
            },
            child: const Text('Register'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                loginRoute,
                (route) => false,
              );
            },
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }
}
