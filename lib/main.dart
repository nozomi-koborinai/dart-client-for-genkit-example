import 'package:dart_client_for_genkit_sample/data/providers.dart';
import 'package:dart_client_for_genkit_sample/ui/home_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ProviderScope(child: App()));
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Genkit Client Demo',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.white,
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: AuthWrapper(),
    );
  }
}

class AuthWrapper extends ConsumerStatefulWidget {
  @override
  _AuthWrapperState createState() => _AuthWrapperState();
}

class _AuthWrapperState extends ConsumerState<AuthWrapper> {
  bool _isAuthenticating = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _performAnonymousSignIn();
    });
  }

  Future<void> _performAnonymousSignIn() async {
    setState(() {
      _isAuthenticating = true;
    });

    try {
      final authRepo = ref.read(firebaseAuthRepositoryProvider);
      await authRepo.signinAnonymously();
    } catch (e) {
      print('Anonymous sign-in failed: $e');
    } finally {
      setState(() {
        _isAuthenticating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSignedIn = ref.watch(isSignedInProvider);
    if (isSignedIn && !_isAuthenticating) return HomePage();

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.local_fire_department,
              size: 100,
              color: Colors.orange,
            ),
            const SizedBox(height: 32),
            const Text(
              'Dart client for Genkit - Demo App',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (_isAuthenticating) ...[
              const Text(
                'Initializing anonymous authentication...',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              const CircularProgressIndicator(),
            ],
          ],
        ),
      ),
    );
  }
}
