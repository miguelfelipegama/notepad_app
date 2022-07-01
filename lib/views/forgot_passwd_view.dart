import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notepad_app/services/auth/bloc/auth_bloc.dart';
import 'package:notepad_app/services/auth/bloc/auth_event.dart';
import 'package:notepad_app/services/auth/bloc/auth_state.dart';
import 'package:notepad_app/utilities/dialogs/error_dialog.dart';
import 'package:notepad_app/utilities/dialogs/passwd_reset_dialog.dart';

class ForgotPasswdView extends StatefulWidget {
  const ForgotPasswdView({Key? key}) : super(key: key);

  @override
  State<ForgotPasswdView> createState() => _ForgotPasswdViewState();
}

class _ForgotPasswdViewState extends State<ForgotPasswdView> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (
        context,
        state,
      ) async {
        if (state is AuthStateForgotPasswd) {
          if (state.hasSentEmail) {
            _controller.clear();
            await showPasswdResetDialog(context);
          }
          if (state.exception != null && mounted) {
            await showErrorDialog(context, state.exception.toString());
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Password Reset'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(children: [
            const Text('Enter user e-mail for recovery:'),
            TextField(
              keyboardType: TextInputType.emailAddress,
              autocorrect: false,
              autofocus: true,
              controller: _controller,
              decoration: const InputDecoration(hintText: 'User e-mail.'),
            ),
            TextButton(
                onPressed: () {
                  final email = _controller.text;
                  context
                      .read<AuthBloc>()
                      .add(AuthEventForgotPasswd(email: email));
                },
                child: const Text('Reset')),
            TextButton(
                onPressed: () {
                  context.read<AuthBloc>().add(const AuthEventLogOut());
                },
                child: const Text('Login')),
          ]),
        ),
      ),
    );
  }
}
