# Smart Class Check-in and Learning Reflection App

Flutter app for classroom attendance check-in and end-of-class reflection.

Students can:
- Scan a QR code for session identification
- Capture current GPS coordinates
- Submit pre-class and post-class responses
- Save records to Cloud Firestore

## Tech Stack

- Flutter 3.x
- Dart 3.x
- Firebase Hosting (web deployment)
- Cloud Firestore (data storage)
- mobile_scanner (QR scanning)
- geolocator (location access)

## Features

### Check-in Screen
- Scan session QR code
- Retrieve GPS location
- Enter previous topic and expected topic
- Select mood score (1-5)
- Submit to Firestore collection: `checkins`

### Finish Class Screen
- Scan session QR code
- Retrieve GPS location
- Enter learned today and feedback
- Submit to Firestore collection: `finish_class`

## Project Structure

```text
lib/
	models/
		checkin_record.dart
	screens/
		home_screen.dart
		checkin_screen.dart
		finish_class_screen.dart
	services/
		firestore_service.dart
		location_service.dart
		qr_service.dart
	firebase_options.dart
	main.dart
```

## Prerequisites

- Flutter SDK installed and configured
- Firebase project created
- Firebase CLI installed
- FlutterFire CLI installed

Windows check commands:

```powershell
flutter --version
firebase --version
flutterfire --version
```

## Setup

1. Install dependencies:

```powershell
flutter pub get
```

2. Ensure Firebase configuration exists:
- `lib/firebase_options.dart` should match your Firebase project

3. Verify Firestore rules are deployed:

```powershell
firebase deploy --only firestore:rules --project smart-class-checkin-f78b5
```

## Run the App

### Web

```powershell
flutter run -d chrome
```

### Mobile (example)

```powershell
flutter run
```

## Build and Deploy (Web)

```powershell
flutter build web --release
firebase deploy --only hosting --project smart-class-checkin-f78b5
```

Live URL:
- https://smart-class-checkin-f78b5.web.app

## Firestore Data Model

Each record contains:
- `studentId` (string)
- `sessionToken` (string)
- `latitude` (number)
- `longitude` (number)
- `timestamp` (Firestore Timestamp)
- `previousTopic` (string)
- `expectedTopic` (string)
- `mood` (number)
- `learnedToday` (string)
- `feedback` (string)

## Firestore Notes

Current `firestore.rules` is open for lab testing:

```text
allow read, write: if true;
```

Important:
- This is not safe for production.
- Replace with authenticated and validated rules before real-world use.

## Troubleshooting

### Submit does not save
- Ensure QR scan completed and session token is not null
- Ensure GPS location is retrieved and permission is granted
- Check browser console for Firebase errors
- Verify Firestore rules are deployed to the correct project

### App shows old version after deploy
- Hard refresh the page (`Ctrl+Shift+R`)
- Try an incognito/private tab
- Clear site data/cache for the hosting URL

### Blank page on web
- Check browser console for startup errors
- Confirm Firebase options match the deployed Firebase project
- Rebuild and redeploy

## Security Reminder

Before submission/demo beyond lab scope:
- Add Firebase Authentication
- Restrict Firestore rules per user/role
- Validate required fields and ranges in rules
- Remove any temporary debug/test-only code
