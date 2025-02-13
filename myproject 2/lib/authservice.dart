import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> createUserWithEmailAndPassword(String email, String password, String name) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = cred.user;
      if (user != null) {
        await user.updateProfile(displayName: name);
        await user.reload();
        user = _auth.currentUser;
      }
      return user;
    } catch (e) {
      throw FirebaseAuthException(code: e.toString());
    }
  }

  Future<User?> loginUserWithEmailAndPassword(String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return cred.user;
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(code: e.code, message: e.message);
    }
  }

  Future<void> signout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception("Error: $e");
    }
  }
}
