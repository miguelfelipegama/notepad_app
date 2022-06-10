import 'package:firebase_auth/firebase_auth.dart' as firebase_auth show User;
import 'package:flutter/cupertino.dart';

@immutable
class AuthUser {
  final String email;
  final bool isEmailVerified;
  const AuthUser({required this.isEmailVerified, required this.email});

  factory AuthUser.fromFirebase(firebase_auth.User user) => AuthUser(
      email: user.email.toString(), isEmailVerified: user.emailVerified);
}
