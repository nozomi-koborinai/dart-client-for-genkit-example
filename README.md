# Dart Client for Genkit Example

Using the released [Dart client for Genkit](https://pub.dev/packages/genkit) package!

## Project Structure

```plain
lib/                             # Flutter app (client side)
├── main.dart                    # App entry point
├── ui/                          # UI layer
│   ├── home_page.dart           # Home page (ConsumerWidget)
│   └── pages/                   # Feature pages
│       ├── simple_string_page.dart    # String Flow demo
│       ├── process_object_page.dart   # Object Flow demo
│       └── stream_objects_page.dart   # Stream Flow demo
├── data/                        # Data layer (Repository)
│   ├── genkit_client.dart       # Genkit API client (using dart client for genkit package)
│   ├── providers.dart           # Riverpod Provider definitions
│   └── auth_repository.dart     # Firebase authentication repository
├── schemas/                     # Data models
│   ├── my_schemas.dart          # Basic Input/Output types
│   └── stream_schemas.dart      # Streaming data types
└── firebase_options.dart        # Firebase configuration

genkit/                          # Genkit server (server side)
├── functions/                   # Cloud Run functions for Genkit (2nd Gen)
│   ├── src/                     # TypeScript source code
│   │   ├── index.ts             # Functions entry point
│   │   ├── genkit.ts            # Genkit configuration
│   │   └── flows/               # Flow definitions
│   │       ├── simple-string-flow.ts      # String flow implementation
│   │       ├── process-object-flow.ts     # Object flow implementation
│   │       └── stream-objects-flow.ts     # Stream flow implementation
│   ├── lib/                     # Compiled JavaScript output
│   ├── package.json             # Node.js dependencies
│   └── tsconfig.json            # TypeScript configuration
├── firebase.json                # Firebase project configuration
├── .firebaserc                  # Firebase project aliases
└── .gitignore                   # Git ignore rules
```

## Tech Stack

- **Flutter**: UI framework
- **Riverpod**: State management (FutureProvider, StreamProvider)
- **Firebase Authentication**: Anonymous Authentication
- **[Genkit](https://genkit.dev/)**: An open-source framework for building AI-powered apps, built and used in production by Google
- **[Dart client for Genkit](https://pub.dev/packages/genkit)**: **Official Genkit client library**

## Genkit Package Features

### Core Capabilities

1. **Type-safe Remote Actions**: Type-safe flow invocation with `defineRemoteAction`
2. **Streaming Support**: Real-time data fetching with `FlowStreamResponse`
3. **Authentication Integration**: Firebase Auth ID Token authentication
4. **Error Handling**: Unified error handling with `GenkitException`

### Basic Usage Example

```dart
// Simple String → String flow
final action = defineRemoteAction(
  url: 'https://your-genkit-endpoint.com/flow',
  fromResponse: (data) => data as String,
  defaultHeaders: {'Authorization': 'Bearer $idToken'},
);

final result = await action(input: 'Hello Genkit!');
```

### Streaming Example

```dart
// Streaming-enabled flow
final streamAction = defineRemoteAction(
  url: 'https://your-genkit-endpoint.com/stream-flow',
  fromResponse: (data) => StreamOutput.fromJson(data),
  fromStreamChunk: (data) => StreamOutput.fromJson(data),
  defaultHeaders: {'Authorization': 'Bearer $idToken'},
);

final (:stream, :response) = streamAction.stream(input: prompt);

// Process stream data
await for (final chunk in stream) {
  print('Chunk: ${chunk.text}');
}

// Get final response
final finalResult = await response;
```

## Demo Features

### 1. Simple String Action

Basic String → String flow invocation

- Fundamental usage of `defineRemoteAction`
- Authentication header configuration

### 2. Process Object Action

Flow invocation with typed objects

- Custom type JSON serialization
- Structured data exchange

### 3. Stream Objects Action

Real-time data streaming implementation

- `FlowStreamResponse` usage
- Real-time stream data display

## Getting Started

```bash
# Install dependencies
flutter pub get

# Generate JSON serialization files
flutter packages pub run build_runner build

# Run the app
flutter run
```

## Firebase Setup

This app uses Firebase Authentication:

1. Create a Firebase project
2. Configure `firebase_options.dart` appropriately
3. Enable Anonymous Authentication

## Genkit Server Configuration

To connect to an actual Genkit server, update the `baseUrl` in `lib/data/genkit_client.dart`:

```dart
final baseUrl = 'https://YOUR_REGION-YOUR_PROJECT_ID.cloudfunctions.net';
```

## References

- [genkit package (pub.dev)](https://pub.dev/packages/genkit)

---

## Security Note

**Important**: This repository contains masked/placeholder values for all sensitive information including:

- Firebase project IDs
- API keys
- Cloud Function URLs
- Authentication tokens

Before running this app, you must:

1. Replace all `YOUR_PROJECT_ID`, `YOUR_API_KEY`, etc. with your actual values
2. Run `flutterfire configure` to generate proper Firebase configuration
3. Deploy your Genkit functions and update the endpoint URLs
