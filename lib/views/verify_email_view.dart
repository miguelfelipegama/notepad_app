import 'package:flutter/material.dart';
import 'package:notepad_app/constants/routes.dart';
import 'package:notepad_app/services/auth/auth_exceptions.dart';
import 'package:notepad_app/services/auth/auth_service.dart';
import 'package:notepad_app/utilities/dialogs/error_dialog.dart';

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
            const Text(
                "Please verify your email, We have sent a verification e-mail, check spam"),
            TextButton(
              onPressed: () async {
                try {
                  await AuthService.firebase().sendEmailVerification();
                } on GenericAuthException {
                  showErrorDialog(context, 'Verification Exception on View');
                }
              },
              child: const Text("Re-send verification e-mail."),
            ),
            TextButton(
                onPressed: () async {
                  await AuthService.firebase().logOut();
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
