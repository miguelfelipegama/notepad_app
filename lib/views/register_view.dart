import 'package:flutter/material.dart';
import 'package:notepad_app/constants/routes.dart';
import 'package:notepad_app/services/auth/auth_exceptions.dart';
import 'package:notepad_app/services/auth/auth_service.dart';
import 'package:notepad_app/utilities/show_error_dialog.dart';

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
        appBar: AppBar(title: const Text('Register')),
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
          TextButton(
            child: const Text('Register'),
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              try {
                await AuthService.firebase()
                    .createUser(email: email, password: password);

                await AuthService.firebase().sendEmailVerification();
                if (mounted) {
                  Navigator.of(context).pushNamed(verifyRoute);
                }
              } on EmailinUseAuthException {
                showErrorDialog(context, 'Email already in use.');
              } on InvalidEmailAuthException {
                showErrorDialog(context, 'This is an invalid email adress');
              } on WeakPasswordAuthException {
                showErrorDialog(context, 'Weak password.');
              } on GenericAuthException {
                showErrorDialog(context, 'Registration Error');
              }
            },
          ),
          TextButton(
              onPressed: (() {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(loginRoute, (route) => false);
              }),
              child: const Text('Already Registered? Log in'))
        ]));
  }
}
