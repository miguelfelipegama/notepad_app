import 'package:bloc/bloc.dart';
import 'package:notepad_app/services/auth/auth_provider.dart';
import 'package:notepad_app/services/auth/bloc/auth_event.dart';
import 'package:notepad_app/services/auth/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider)
      : super(const AuthStateUninitialized(isLoading: true)) {
    on<AuthEventSendEmail>((event, emit) async {
      await provider.sendEmailVerification();
      emit(state);
    });

    on<AuthEventForgotPasswd>((event, emit) async {
      bool didSend = false;
      Exception? psswdException;
      final email = event.email;
      emit(AuthStateForgotPasswd(
        isLoading: true,
        exception: psswdException,
        hasSentEmail: didSend,
      ));

      try {
        await provider.sendPasswdResetEmail(email: email);
        didSend = true;
        psswdException = null;
      } on Exception catch (e) {
        didSend = false;
        psswdException = e;
      }
      print(psswdException);
      emit(AuthStateForgotPasswd(
        isLoading: false,
        exception: psswdException,
        hasSentEmail: didSend,
      ));
    });

    on<AuthEventRegister>((event, emit) async {
      final email = event.email;
      final password = event.password;

      try {
        await provider.createUser(email: email, password: password);
        await provider.sendEmailVerification();
        emit(const AuthStateUnverified(isLoading: false));
      } on Exception catch (e) {
        emit(AuthStateRegistering(exception: e, isLoading: false));
      }
    });

    on<AuthEventInitialize>(
      (event, emit) async {
        await provider.initialize();
        final user = provider.currentUser;
        if (user == null) {
          emit(const AuthStateLoggedOut(
            exception: null,
            isLoading: false,
          ));
        } else if (!user.isEmailVerified) {
          emit(const AuthStateUnverified(isLoading: false));
        } else {
          emit(AuthStateLoggedIn(user: user, isLoading: false));
        }
      },
    );
    on<AuthEventLogIn>((event, emit) async {
      emit(const AuthStateLoggedOut(
        exception: null,
        isLoading: true,
      ));
      emit(const AuthStateUninitialized(isLoading: false));
      final email = event.email;
      final password = event.password;
      try {
        final user = await provider.logIn(
          email: email,
          password: password,
        );
        if (!user.isEmailVerified) {
          emit(const AuthStateLoggedOut(
            exception: null,
            isLoading: false,
          ));
          emit(const AuthStateUnverified(isLoading: false));
        } else {
          emit(const AuthStateLoggedOut(
            exception: null,
            isLoading: false,
          ));
          emit(AuthStateLoggedIn(user: user, isLoading: false));
        }
      } on Exception catch (e) {
        emit(AuthStateLoggedOut(exception: e, isLoading: false));
      }
    });
    on<AuthEventLogOut>(
      (event, emit) async {
        try {
          await provider.logOut();
          emit(const AuthStateLoggedOut(exception: null, isLoading: false));
        } on Exception catch (e) {
          emit(AuthStateLoggedOut(exception: e, isLoading: false));
        }
      },
    );
  }
}
