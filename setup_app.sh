#!/bin/bash

# setup_app.sh

echo "Checking for Flutter..."
if ! command -v flutter &> /dev/null; then
    echo "Flutter is not installed or not in PATH. Please wait for the installation to finish or install it manually."
    exit 1
fi

echo "Creating Flutter app 'app'..."
# Create the app in 'app' directory
flutter create app --project-name todo_app

echo "Copying source code..."
# Overwrite with our source code
cp -r app_source/* app/

echo "Getting dependencies..."
cd app
flutter pub get

echo "Setup complete! You can now run the app with:"
echo "cd app && flutter run"
