import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:notepad_app/services/auth/auth_user.dart' show AuthUser;

@immutable
abstract class AuthState {
  final bool isLoading;
  final String loadingText;
  const AuthState({required this.isLoading, this.loadingText = 'Please wait.'});
}

class AuthStateUninitialized extends AuthState {
  const AuthStateUninitialized({required bool isLoading})
      : super(isLoading: isLoading);
}

class AuthStateRegistering extends AuthState {
  final Exception? exception;
  const AuthStateRegistering({
    required this.exception,
    required isLoading,
  }) : super(isLoading: isLoading);
}

class AuthStateLoggedIn extends AuthState {
  final AuthUser user;
  const AuthStateLoggedIn({
    required this.user,
    required bool isLoading,
  }) : super(isLoading: isLoading);
}

class AuthStateUnverified extends AuthState {
  const AuthStateUnverified({required bool isLoading})
      : super(isLoading: isLoading);
}

class AuthStateLoggedOut extends AuthState with EquatableMixin {
  final Exception? exception;
  const AuthStateLoggedOut({
    required this.exception,
    required bool isLoading,
    String loadingText = 'Please wait.',
  }) : super(
          isLoading: isLoading,
          loadingText: loadingText,
        );

  @override
  List<Object?> get props => [exception, isLoading];
}

class AuthStateForgotPasswd extends AuthState {
  final Exception? exception;
  final bool hasSentEmail;

  const AuthStateForgotPasswd(
      {this.exception, this.hasSentEmail = false, required bool isLoading})
      : super(isLoading: isLoading);
}
