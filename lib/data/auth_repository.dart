import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthRepository {
  FirebaseAuthRepository({
    required this.auth,
  });

  final FirebaseAuth auth;

  Future<String> signinAnonymously() async {
    try {
      final userCredential = await auth.signInAnonymously();
      return userCredential.user!.uid;
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Firebase Auth Error: ${e.code}';
      if (e.message != null) {
        errorMessage += ' - ${e.message}';
      }

      if (e.code == 'operation-not-allowed') {
        errorMessage +=
            '\n\nPlease enable Anonymous Authentication in Firebase Console:\n'
            '1. Go to Firebase Console\n'
            '2. Select your project (firebase-genkit-sample)\n'
            '3. Go to Authentication > Sign-in method\n'
            '4. Enable Anonymous authentication';
      }

      throw Exception(errorMessage);
    } catch (e) {
      throw Exception('Unexpected error during anonymous sign-in: $e');
    }
  }

  Future<String> getIdToken() async {
    try {
      final user = auth.currentUser;
      if (user == null) throw Exception('User not authenticated');
      final token = await user.getIdToken();
      if (token == null) throw Exception('Failed to get ID token');
      return token;
    } on FirebaseAuthException catch (e) {
      throw Exception('Failed to get ID token: ${e.message}');
    }
  }
}
