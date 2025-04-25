# Medicinal Plants Identifier App

A Flutter application for identifying medicinal plants and learning about their therapeutic properties.

## Features

- Take photos of plants directly from the app
- Upload existing images from your gallery
- Identify plant species with scientific and common names
- View detailed information about medicinal properties and therapeutic uses
- Save identified plants to local history
- Access saved plants offline
- No account required - everything stored locally on your device

## Requirements

- Flutter 3.0.0 or higher
- Dart 2.17.0 or higher
- Android SDK for Android deployment
- Xcode for iOS deployment

## Getting Started

### Installation

1. Clone this repository
2. Navigate to the project directory
3. Run `flutter pub get` to install dependencies
4. Connect a device or start an emulator
5. Run `flutter run` to start the app

### API Integration

The app is designed to work with Gemini or Llama APIs for plant recognition. To integrate with these APIs:

1. Obtain an API key from your preferred provider
2. Open `lib/services/plant_recognition_service.dart`
3. Replace the placeholder API key with your actual key
4. Uncomment the appropriate implementation (Gemini or Llama)

## Project Structure

- `lib/constants/` - App theme and constants
- `lib/models/` - Data models
- `lib/screens/` - UI screens
- `lib/services/` - Business logic and API services
- `lib/widgets/` - Reusable UI components

## Building for Production

### Android

```
flutter build apk --release
```

The APK file will be available at `build/app/outputs/flutter-apk/app-release.apk`

### iOS

```
flutter build ios --release
```

Then open the Xcode project in the `ios` folder and archive it for distribution.

## Permissions

The app requires the following permissions:

- Camera - For taking photos of plants
- Photo Library - For accessing saved images
- Storage - For saving identified plants locally

## License

This project is licensed under the MIT License - see the LICENSE file for details.
