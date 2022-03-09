import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';

Future<void> showEmailVerifyPopup(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Verify Email'),
        content: const Text(
            'Email verification sent. Please click the link on the email.'),
        actions: [
          TextButton(
            onPressed: () async {
              final user = FirebaseAuth.instance.currentUser;
              if (user != null) {
                await user.reload();
                if (user.emailVerified) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    notesRoute,
                    (route) => false,
                  );
                } else {
                  showEmailVerifyPopup(context);
                }
              }
            },
            child: const Text('Ok'),
          ),
        ],
      );
    },
  );
}
