import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notepad_app/services/auth/auth_exceptions.dart';
import 'package:notepad_app/services/auth/bloc/auth_event.dart';

import '../services/auth/bloc/auth_bloc.dart';
import '../services/auth/bloc/auth_state.dart';
import '../utilities/dialogs/error_dialog.dart';

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
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateRegistering) {
          if (state.exception is EmailinUseAuthException) {
            showErrorDialog(context, 'Email already in use.');
          } else if (state.exception is InvalidEmailAuthException) {
            showErrorDialog(context, 'This is an invalid email adress');
          } else if (state.exception is WeakPasswordAuthException) {
            showErrorDialog(context, 'Weak password.');
          } else if (state.exception is GenericAuthException) {
            showErrorDialog(context, 'Registration Error');
          }
        }
      },
      child: Scaffold(
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
                  context
                      .read<AuthBloc>()
                      .add(AuthEventRegister(email: email, password: password));
                }),
            TextButton(
                onPressed: (() {
                  context.read<AuthBloc>().add(const AuthEventLogOut());
                }),
                child: const Text('Already Registered? Log in'))
          ])),
    );
  }
}
