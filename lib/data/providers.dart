import 'package:dart_client_for_genkit_sample/data/auth_repository.dart';
import 'package:dart_client_for_genkit_sample/data/genkit_client.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for [GenkitClient] instance
final genkitClientProvider = Provider<GenkitClient>(
  (ref) => GenkitClient(),
);

final _authProvider = Provider<FirebaseAuth>((_) => FirebaseAuth.instance);

final authUserProvider = StreamProvider<User?>(
  (ref) => ref.watch(_authProvider).userChanges(),
);

final userIdProvider = Provider<String?>((ref) {
  ref.watch(authUserProvider);
  return ref.watch(_authProvider).currentUser?.uid;
});

final isSignedInProvider = Provider<bool>(
  (ref) => ref.watch(userIdProvider) != null,
);

final firebaseAuthRepositoryProvider = Provider<FirebaseAuthRepository>(
  (ref) => FirebaseAuthRepository(auth: ref.watch(_authProvider)),
);
