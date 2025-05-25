# ChatGPT Clone Flutter App

A Flutter mobile application that serves as a ChatGPT clone, supporting both iOS and Android platforms.

## Features

- Clean and modern UI design
- Real-time chat with ChatGPT API
- Dark/Light theme support
- Message history
- Secure API key storage
- Responsive layout

## Prerequisites

- Flutter SDK (latest version)
- Dart SDK (latest version)
- OpenAI API key
- Android Studio / Xcode (for platform-specific development)

## Setup

1. Clone the repository:
```bash
git clone <repository-url>
cd chat-gpt-clone
```

2. Install dependencies:
```bash
flutter pub get
```

3. Create a `.env` file in the root directory and add your OpenAI API key:
```
OPENAI_API_KEY=your_api_key_here
```

4. Run the app:
```bash
flutter run
```

## Project Structure

```
lib/
├── main.dart
├── config/         # environment, constants
├── models/         # message, chat, model
├── services/       # API, MongoDB, Cloudinary
├── screens/        # chat screen, history screen, settings
├── widgets/        # chat bubble, input field, model selector
├── providers/      # state management (Riverpod/Provider/Bloc)
└── utils/          # helpers, validators, error handlers
```

## Dependencies

- flutter_riverpod: State management
- http: API calls
- flutter_dotenv: Environment variables
- flutter_secure_storage: Secure storage
- intl: Internationalization
- uuid: Unique IDs
- cached_network_image: Image caching
- flutter_spinkit: Loading animations

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details. 