import 'package:firebase_auth/firebase_auth.dart' as FirebaseAuth show User;

class AuthUser {
  final bool isEmailVerified;

  AuthUser(this.isEmailVerified);
}
