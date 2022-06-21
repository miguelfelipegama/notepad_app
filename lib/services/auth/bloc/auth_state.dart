import 'package:flutter/foundation.dart' show immutable;
import 'package:notepad_app/services/auth/auth_user.dart' show AuthUser;

@immutable
abstract class AuthState {
  const AuthState();
}

class AuthStateLoading extends AuthState {
  const AuthStateLoading();
}

class AuthStateLoggedIn extends AuthState {
  final AuthUser user;
  const AuthStateLoggedIn(this.user);
}

class AuthStateLogInFailure extends AuthState {
  final Exception exception;
  const AuthStateLogInFailure(this.exception);
}

class AuthStateUnverified extends AuthState {
  const AuthStateUnverified();
}

class AuthStateLoggedOut extends AuthState {
  const AuthStateLoggedOut();
}

class AuthStateLogOutFailure extends AuthState {
  final Exception exception;
  const AuthStateLogOutFailure(this.exception);
}
