# Firebase Todo List

A simple SwiftUI todo app with email/password sign-up and login. Each signed-in user can add, edit, and delete tasks with a title and description. Tasks are stored in Cloud Firestore under `users/{userId}/todos/{taskId}`.

## Firebase setup

1. Open the Firebase project associated with `rusho/GoogleService-Info.plist` (or replace the file with the configuration for your own iOS Firebase app). Its bundle ID must match the Xcode target's bundle ID.
2. In Firebase Authentication, enable the **Email/Password** sign-in provider.
3. Create a Cloud Firestore database and publish the rules in `firestore.rules` in the Firestore Rules tab. These rules let a signed-in user access only their own tasks.
4. Open `rusho.xcodeproj` in Xcode, allow Swift packages to resolve, select an iOS simulator or signing team, and run the app.

The Firebase project, Authentication provider, database, and rules must be configured in the Firebase console before the app can use them.
