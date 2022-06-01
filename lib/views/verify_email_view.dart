import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notepad_app/constants/routes.dart';
import 'package:notepad_app/utilities/show_error_dialog.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({Key? key}) : super(key: key);

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Verify')),
        body: Column(
          children: [
            const Text("Please verify your email adress:"),
            TextButton(
              onPressed: () async {
                final user = FirebaseAuth.instance.currentUser;

                try {
                  await user?.sendEmailVerification();
                } on FirebaseAuthException catch (e) {
                  showErrorDialog(context, 'Error: ${e.code}');
                }
              },
              child: const Text("Send verification email"),
            ),
            TextButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  if (mounted) {
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil(loginRoute, (route) => false);
                  }
                },
                child: const Text("Signout"))
          ],
        ));
  }
}
