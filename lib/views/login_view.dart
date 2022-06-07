import 'package:flutter/material.dart';
import 'package:notepad_app/constants/routes.dart';
import 'package:notepad_app/services/auth/auth_exceptions.dart';
import 'package:notepad_app/services/auth/auth_service.dart';

import '../utilities/show_error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
        appBar: AppBar(title: const Text('Login')),
        body: Column(children: [
          TextField(
            decoration: const InputDecoration(hintText: 'Enter e-mail'),
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            controller: _email,
          ),
          TextField(
            decoration: const InputDecoration(hintText: 'Enter password'),
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
          ),
          Row(children: [
            TextButton(
              child: const Text('Login'),
              onPressed: () async {
                final email = _email.text;
                final password = _password.text;
                try {
                  await AuthService.firebase()
                      .logIn(email: email, password: password);
                } on WrongPasswordAuthException catch (_) {
                  await showErrorDialog(context, 'Wrong Password.');
                } on UserNotFoundAuthException catch (_) {
                  await showErrorDialog(context, 'User not found.');
                } on GenericAuthException catch (_) {
                  await showErrorDialog(context, 'Authentication Error.');
                }
                if (!mounted) {
                  return;
                }
                if (AuthService.firebase().currentUser?.isEmailVerified ??
                    false) {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(notesRoute, (route) => false);
                } else if (AuthService.firebase().currentUser != null) {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(verifyRoute, (route) => false);
                } else {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(loginRoute, (route) => false);
                }
              },
            ),
            TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(registerRoute, (route) => false);
                },
                child: const Text("Register"))
          ])
        ]));
  }
}
