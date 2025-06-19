import 'package:dart_client_for_genkit_sample/schemas/my_schemas.dart';
import 'package:dart_client_for_genkit_sample/schemas/stream_schemas.dart';
import 'package:genkit/genkit.dart';

/// A client for interacting with Firebase Genkit flows.
///
/// This class provides convenient methods to call various Genkit flows
/// with proper authentication and type safety.
class GenkitClient {
  GenkitClient();

  final baseUrl = 'https://YOUR_REGION-YOUR_PROJECT_ID.cloudfunctions.net';

  Future<String> callSimpleStringAction({
    required String idToken,
    required String input,
  }) async {
    try {
      final remoteAction = defineRemoteAction(
        url: '$baseUrl/simpleString',
        fromResponse: (json) => json as String,
        defaultHeaders: {'Authorization': 'Bearer $idToken'},
      );

      return await remoteAction(input: input);
    } on GenkitException catch (e) {
      throw Exception('Failed to remote action: ${e.message}');
    }
  }

  Future<MyOutput> callProcessObjectAction({
    required String idToken,
    required String message,
    required int count,
  }) async {
    try {
      final remoteAction = defineRemoteAction<MyOutput, void>(
        url: '$baseUrl/processObject',
        fromResponse: (json) => MyOutput.fromJson(json),
        defaultHeaders: {'Authorization': 'Bearer $idToken'},
      );

      return await remoteAction(input: MyInput(message: message, count: count));
    } on GenkitException catch (e) {
      throw Exception('Failed to remote action: ${e.message}');
    }
  }

  FlowStreamResponse<StreamOutput, StreamOutput> subscribeStreamObjectAction({
    required String idToken,
    required String prompt,
  }) {
    try {
      final remoteAction = defineRemoteAction<StreamOutput, StreamOutput>(
        url: '$baseUrl/streamObjects',
        fromResponse: (json) => StreamOutput.fromJson(json),
        fromStreamChunk: (json) => StreamOutput.fromJson(json),
        defaultHeaders: {'Authorization': 'Bearer $idToken'},
      );

      return remoteAction.stream(input: StreamInput(prompt: prompt));
    } on GenkitException catch (e) {
      throw Exception('Failed to remote action: ${e.message}');
    }
  }

  Future<String> callCustomHeaderAction({
    required String idToken,
    required String input,
    required String userId,
    required String clientVersion,
    String? requestId,
  }) async {
    try {
      final remoteAction = defineRemoteAction<String, void>(
        url: '$baseUrl/customHeader',
        fromResponse: (json) => json as String,
        defaultHeaders: {'Authorization': 'Bearer $idToken'},
      );

      return await remoteAction.call(
        input: input,
        headers: {
          'x-user-id': userId,
          'x-client-version': clientVersion,
          if (requestId != null) 'x-request-id': requestId,
        },
      );
    } on GenkitException catch (e) {
      throw Exception('Failed to remote action: ${e.message}');
    }
  }
}
