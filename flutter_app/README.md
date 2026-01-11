# AI Studio Mobile - Flutter App

This is a Flutter application that provides AI-powered tools for mobile devices.

## Features

- Chat with AI assistants
- Code editor with syntax highlighting
- AI tools for various tasks
- Workflow management
- Settings and preferences

## Building with GitHub Actions

This project is configured to build automatically using GitHub Actions. When you push changes to the `main` or `master` branch, GitHub will automatically:

1. Set up Flutter environment
2. Install dependencies
3. Run analysis and tests
4. Build the Android APK
5. Upload the APK as an artifact

### To get your APK:

1. Push this code to a GitHub repository
2. Go to the "Actions" tab in your repository
3. Wait for the build to complete
4. Download the APK from the "Artifacts" section

## Local Development

If you wish to develop locally:

1. Install Flutter from [flutter.dev](https://flutter.dev)
2. Run `flutter pub get` to install dependencies
3. Run `flutter run` to launch the app
4. Run `flutter build apk --release` to build a release APK

## Project Structure

- `lib/main.dart` - Entry point of the application
- `lib/app.dart` - Main app widget with routing
- `lib/screens/` - UI screens
- `lib/models/` - Data models
- `lib/providers/` - State management
- `lib/services/` - Backend services (Firebase)