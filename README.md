# Firebase CRUD

A Flutter inventory list connected to Cloud Firestore in Firebase project
`activity8-merioles`. Android, web, and Windows Firebase options are generated
in `lib/firebase_options.dart`; Android's native configuration is in
`android/app/google-services.json`.

Items are stored in the `items` collection with `name`, `quantity`,
`isFavorite`, and `createdAt` fields. The list listens to Firestore snapshots,
so changes appear without a manual refresh.

## Firestore access

The Cloud Firestore API is enabled and the default `(default)` database is
created in the `asia-southeast1` (Singapore) region.

Anonymous Authentication is enabled to preserve the reference UI without a
login screen. Each anonymous user can access only their own
`users/{uid}/items` collection. Anonymous sessions are device/browser-specific;
clearing app data or switching devices does not restore that user's items.

The checked-in Firestore rules are deployed. Redeploy them after changes with
`firebase deploy --only firestore:rules`.

Run `flutter pub get` and `flutter run` after configuring the database and
rules.
