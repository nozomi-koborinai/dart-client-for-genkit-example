import 'package:dart_client_for_genkit_sample/data/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SimpleStringPage extends ConsumerStatefulWidget {
  @override
  _SimpleStringPageState createState() => _SimpleStringPageState();
}

class _SimpleStringPageState extends ConsumerState<SimpleStringPage> {
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;
  String? _result;
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _sendString() async {
    if (_controller.text.isEmpty) {
      setState(() => _error = 'Please enter some text');
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
      _result = null;
    });

    try {
      final idToken =
          await ref.read(firebaseAuthRepositoryProvider).getIdToken();
      final result =
          await ref.read(genkitClientProvider).callSimpleStringAction(
                idToken: idToken,
                input: _controller.text.trim(),
              );

      setState(() => _result = result);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Simple String Action',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.text_fields,
                              size: 48,
                              color: Colors.blue,
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Send a string and get a processed response',
                              style: TextStyle(fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              controller: _controller,
                              decoration: const InputDecoration(
                                labelText: 'Enter your message',
                                border: OutlineInputBorder(),
                                hintText: 'Type something here...',
                              ),
                              maxLines: 3,
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _sendString,
                                child: _isLoading
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                            strokeWidth: 2),
                                      )
                                    : const Text('Send String'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (_result != null || _error != null) ...[
                      const Text(
                        'Result:',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: SingleChildScrollView(
                              child: _error != null
                                  ? Text(
                                      'Error: $_error',
                                      style: const TextStyle(color: Colors.red),
                                    )
                                  : Text(
                                      _result ?? '',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
