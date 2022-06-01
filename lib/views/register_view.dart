import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notepad_app/constants/routes.dart';
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
                await FirebaseAuth.instance.createUserWithEmailAndPassword(
                    email: email, password: password);
                await FirebaseAuth.instance.currentUser
                    ?.sendEmailVerification();
                if (mounted) {
                  Navigator.of(context).pushNamed(verifyRoute);
                }
              } on FirebaseAuthException catch (e) {
                switch (e.code) {
                  case 'email-already-in-use':
                    showErrorDialog(context, 'Email already in use.');
                    break;
                  case 'invalid-email':
                    showErrorDialog(context, 'This is an invalid email adress');
                    break;
                  default:
                    showErrorDialog(context, 'Error: ${e.code}');
                    break;
                }
              } catch (e) {
                showErrorDialog(context, e.toString());
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
