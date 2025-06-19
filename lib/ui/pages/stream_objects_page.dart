import 'dart:async';
import 'package:dart_client_for_genkit_sample/data/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StreamObjectsPage extends ConsumerStatefulWidget {
  @override
  _StreamObjectsPageState createState() => _StreamObjectsPageState();
}

class _StreamObjectsPageState extends ConsumerState<StreamObjectsPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  String? _error;
  String _streamedText = '';
  StreamSubscription? _subscription;

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _subscription?.cancel();
    super.dispose();
  }

  Future<void> _startStream() async {
    if (_controller.text.isEmpty) {
      setState(() => _error = 'Please enter a prompt');
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
      _streamedText = '';
    });

    try {
      final idToken =
          await ref.read(firebaseAuthRepositoryProvider).getIdToken();
      final (:stream, :response) =
          ref.read(genkitClientProvider).subscribeStreamObjectAction(
                idToken: idToken,
                prompt: _controller.text.trim(),
              );

      await for (final chunk in stream) {
        setState(() {
          _streamedText += chunk.text;
        });
        _scrollToBottom();
      }
      final finalResult = await response;
      print('Final Response: ${finalResult.text}');

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
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
                      'Stream Objects Action',
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
                    TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        labelText: 'Enter your prompt',
                        border: OutlineInputBorder(),
                        hintText: 'Ask something...',
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _startStream,
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Text('Start Stream'),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Streaming Results:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              if (_error != null)
                                Text(
                                  'Error: $_error',
                                  style: const TextStyle(color: Colors.red),
                                ),
                              if (_streamedText.isNotEmpty)
                                Expanded(
                                  child: SingleChildScrollView(
                                    controller: _scrollController,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SelectableText(
                                        _streamedText,
                                        style: const TextStyle(
                                            fontSize: 16, height: 1.5),
                                      ),
                                    ),
                                  ),
                                ),
                              if (_streamedText.isEmpty &&
                                  !_isLoading &&
                                  _error == null)
                                const Center(
                                  child: Text(
                                    'No results yet. Enter a prompt and start streaming!',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
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
