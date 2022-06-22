import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../services/auth/bloc/auth_bloc.dart';
import '../services/auth/bloc/auth_event.dart';

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
              onPressed: () {
                context.read<AuthBloc>().add(const AuthEventSendEmail());
              },
              child: const Text("Re-send verification e-mail."),
            ),
            TextButton(
                onPressed: () {
                  context.read<AuthBloc>().add(const AuthEventLogOut());
                },
                child: const Text("Signout"))
          ],
        ));
  }
}
