# FarmSmart

FarmSmart is a Flutter-based mobile application designed to help farmers manage farm activities, track resources, and improve productivity through smart digital tools.

---

## Getting Started

This guide will help you set up the project on your local machine and run the app using **Flutter**, **FVM (Flutter Version Management)**, and **flavors**.

---

## Prerequisites

Before running the project, install the following:

### 1. Install Git
- Download: https://git-scm.com/downloads

### 2. Install Flutter SDK (Recommended via FVM)
We recommend using **FVM** to manage Flutter versions.

---

## Install FVM (Flutter Version Management)

### Install FVM globally:
```bash
dart pub global activate fvm
Add FVM to PATH:

Make sure this is added to your environment variables:

export PATH="$PATH":"$HOME/.pub-cache/bin"
Install Flutter version used by the project:
fvm install

or specific version:

fvm install 3.22.0
Use the version:
fvm use 3.22.0
Install Flutter

If not using FVM:

Download Flutter SDK:

https://flutter.dev/docs/get-started/install

Verify installation:
flutter doctor

Fix any missing dependencies shown.

🧑‍💻 Install VS Code
Download:

https://code.visualstudio.com/

Install extensions:
Flutter
Dart
🤖 Install Android Studio
Download:

https://developer.android.com/studio

Setup:
Install Android SDK
Install Android Emulator
Run:
flutter doctor

Accept licenses:

flutter doctor --android-licenses
Project Setup
Clone the repository:
git clone https://github.com/eisax/farmsmart-flutter.git
cd farmsmart
Install dependencies:
fvm flutter pub get

or without FVM:

flutter pub get
Running the App
Run default flavor:
fvm flutter run

or:

flutter run
Flavors Setup

FarmSmart supports multiple environments:

Development
Staging
Production
Run specific flavor:
Android:
fvm flutter run --flavor dev -t lib/main_dev.dart
fvm flutter run --flavor staging -t lib/main_staging.dart
fvm flutter run --flavor prod -t lib/main_prod.dart
Build APK / App Bundle
Android APK:
fvm flutter build apk --flavor prod -t lib/main_prod.dart
Android App Bundle:
fvm flutter build appbundle --flavor prod -t lib/main_prod.dart
Running Tests
fvm flutter test
Project Structure (Example)
lib/
 ├── core/
 ├── features/
 ├── shared/
 ├── main_dev.dart
 ├── main_staging.dart
 ├── main_prod.dart
Useful Commands
fvm flutter clean
fvm flutter pub get
fvm flutter doctor
fvm flutter upgrade
Troubleshooting
Flutter not found:

Ensure FVM is in PATH or Flutter SDK is installed correctly.

Emulator not starting:

Open Android Studio → Device Manager → Start emulator.

Build issues:

Run:

fvm flutter clean
fvm flutter pub get
About FarmSmart

FarmSmart aims to empower farmers with smart agricultural tools for better decision-making, resource tracking, and farm optimization.

License

This project is licensed under the MIT License.


---

If you want, I can also:
- :contentReference[oaicite:0]{index=0}  
- :contentReference[oaicite:1]{index=1}
- or :contentReference[oaicite:2]{index=2}