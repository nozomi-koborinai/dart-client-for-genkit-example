import 'package:dart_client_for_genkit_sample/data/providers.dart';
import 'package:dart_client_for_genkit_sample/schemas/my_schemas.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProcessObjectPage extends ConsumerStatefulWidget {
  @override
  _ProcessObjectPageState createState() => _ProcessObjectPageState();
}

class _ProcessObjectPageState extends ConsumerState<ProcessObjectPage> {
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _countController =
      TextEditingController(text: '0');
  bool _isLoading = false;
  MyOutput? _result;
  String? _error;

  @override
  void dispose() {
    _messageController.dispose();
    _countController.dispose();
    super.dispose();
  }

  Future<void> _processObject() async {
    if (_messageController.text.isEmpty) {
      setState(() => _error = 'Please enter a message');
      return;
    }

    final count = int.tryParse(_countController.text) ?? 0;

    setState(() {
      _isLoading = true;
      _error = null;
      _result = null;
    });

    try {
      final idToken =
          await ref.read(firebaseAuthRepositoryProvider).getIdToken();

      final result =
          await ref.read(genkitClientProvider).callProcessObjectAction(
                idToken: idToken,
                message: _messageController.text.trim(),
                count: count,
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
                      'Process Object Action',
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
                              Icons.data_object,
                              size: 48,
                              color: Colors.green,
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Send structured data and get processed output',
                              style: TextStyle(fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              controller: _messageController,
                              decoration: const InputDecoration(
                                labelText: 'Message',
                                border: OutlineInputBorder(),
                                hintText: 'Enter your message...',
                              ),
                              maxLines: 2,
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              controller: _countController,
                              decoration: const InputDecoration(
                                labelText: 'Count',
                                border: OutlineInputBorder(),
                                hintText: 'Enter a number...',
                              ),
                              keyboardType: TextInputType.number,
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _processObject,
                                child: _isLoading
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                            strokeWidth: 2),
                                      )
                                    : const Text('Process Object'),
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
                                      _result != null
                                          ? 'Reply: ${_result!.reply}\nNew Count: ${_result!.newCount}'
                                          : '',
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
