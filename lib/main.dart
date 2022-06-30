import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notepad_app/constants/routes.dart';
import 'package:notepad_app/helpers/loading/loading_screen.dart';
import 'package:notepad_app/services/auth/bloc/auth_bloc.dart';
import 'package:notepad_app/services/auth/bloc/auth_event.dart';
import 'package:notepad_app/services/auth/bloc/auth_state.dart';
import 'package:notepad_app/services/auth/firebase_auth_provider.dart';
import 'package:notepad_app/views/login_view.dart';
import 'package:notepad_app/views/notes/create_update_note_view.dart';
import 'package:notepad_app/views/notes/notes_view.dart';
import 'package:notepad_app/views/register_view.dart';
import 'package:notepad_app/views/verify_email_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.grey,
    ),
    home: BlocProvider<AuthBloc>(
      create: (context) => AuthBloc(FireBaseAuthProvider()),
      child: const HomePage(),
    ),
    routes: {
      createOrUpdateNoteRoute: (context) => const CreateUpdateNoteView(),
    },
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocConsumer<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthStateLoggedIn) {
          return const NotesView();
        } else if (state is AuthStateUnverified) {
          return const VerifyEmailView();
        } else if (state is AuthStateLoggedOut) {
          return const LoginView();
        } else if (state is AuthEventRegisterView) {
          return const RegisterView();
        } else {
          return const Scaffold(body: CircularProgressIndicator());
        }
      },
      listener: (context, state) {
        if (state.isLoading) {
          LoadingScreen().show(context: context, text: state.loadingText);
        } else {
          LoadingScreen().hide();
        }
      },
    );
  }
}
