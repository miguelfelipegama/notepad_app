import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
                  showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text('Verification Error'),
                      content: Text(e.code.toString()),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'OK'),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                }
              },
              child: const Text("Send verification email"),
            ),
            TextButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  if (mounted) {
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil('/login/', (route) => false);
                  }
                },
                child: const Text("Signout"))
          ],
        ));
  }
}
