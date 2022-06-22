import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:notepad_app/services/auth/auth_user.dart' show AuthUser;

@immutable
abstract class AuthState {
  const AuthState();
}

class AuthStateUninitialized extends AuthState {
  const AuthStateUninitialized();
}

class AuthStateRegistering extends AuthState {
  final Exception exception;
  const AuthStateRegistering(this.exception);
}

class AuthStateRegistered extends AuthState {
  const AuthStateRegistered();
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

class AuthStateLoggedOut extends AuthState with EquatableMixin {
  final Exception? exception;
  final bool isLoading;
  const AuthStateLoggedOut({
    required this.exception,
    required this.isLoading,
  });

  @override
  List<Object?> get props => [exception, isLoading];
}
