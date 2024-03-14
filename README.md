# Flutter Template Project Documentation
## Initial Setup

Before running the project you have to fetch the dependencies and generate the missing file by executing:
```
./run_build_runner_packages
```

The Flutter template project is configured to support two environments: 'dev' and 'prod'. To run the project with a specific flavor, use the command:

```
flutter run --flavor dev/prod
```

For Android Studio users, follow these steps:

```
Open Run/Debug configurations.
Choose Edit Configuration or Add New Configuration.
Set the dart entrypoint to main.dart and specify the build flavor as 'dev' or 'prod'.
```

After configuring the build, you can run the app using the chosen environment.

## Package Identifiers

The template project has support for two environments: 'dev' and 'prod'. To modify the package identifier:

### Android

Navigate to android/app/build.gradle. Locate the productFlavors section and specify the dev and prod package identifiers as required.

### iOS

Open the project in Xcode and within the Runner/Flutter folder, find configuration files named 'dev' and 'prod'. Update the PRODUCT_BUNDLE_IDENTIFIER with the desired identifier. Adjust the app display name if needed.

Feel free to include additional properties as necessary.

## Firebase Setup

To integrate Firebase into the template project, use the Firebase CLI for Flutter. Note: Firebase files are git-ignored, so avoid including them; the pipeline handles Firebase initialization during app builds.

If adding Firebase, include the FIREBASE_PROJECT property in the pipeline secrets. For iOS, additional properties may be necessary. Refer to the pipeline documentation for more details.

### For local Firebase setup:

Use the flutterfire_configure_manual script in the project directory or perform manual setup by executing the following commands:

```
curl -sL https://firebase.tools | bash
dart pub global activate flutterfire_cli
firebase login
flutterfire configure
```

Ensure you have the required tools installed and follow the authentication steps for Firebase.

After initiation, update the app/build.gradle file by setting the Google services plugin version to:
```
'com.google.gms:google-services:4.3.15'
```

Commit only these changes to the gradle files; avoid committing any other secrets.

Remember to include the options generated from the CLI when initializing Firebase in your app:
```
final app = await Firebase.initializeApp(
options: DefaultFirebaseOptions.currentPlatform,
);
```

## Pipeline setup 
For pipeline setup checkout this documentation - https://appolica.atlassian.net/wiki/spaces/AKS/pages/3837231128/Pipeline+setup