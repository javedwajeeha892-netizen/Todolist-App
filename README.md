# Flutter Todo List Project

This is a complete Todo List App with a Flutter Frontend and PHP Backend.

## Prerequisites

1.  **Flutter SDK** installed and configured.
2.  **PHP** installed (available on MacOS/Linux by default, or via XAMPP/MAMP on Windows).

## How to Run

### 1. Run the Backend
Open a terminal in the project root directory and run:

```bash
php -S localhost:8000 -t backend
```

*Keep this terminal window open.*

### 2. Run the App
Open a new terminal window, navigate to the `app` directory, and run the app:

```bash
cd app
flutter pub get
flutter run
```

## How to Build APK (Android)

To generate an APK file that you can install on Android phones:

```bash
cd app
flutter build apk --release
```

The APK file will be created at:
`app/build/app/outputs/flutter-apk/app-release.apk`

## Features

- **Login & Signup**: Secure authentication with PHP backend.
- **Todo List**: Add, complete, and delete tasks.
- **Animations**: Splash screen and confetti celebration on task completion!
- **Zero Config**: Uses SQLite, so no need to set up MySQL server.
