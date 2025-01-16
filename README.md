```markdown
# Flutter App Management and Troubleshooting Guide

## Managing App Versions

To update the app version:

1. Open `pubspec.yaml`.
2. Change the version number in the `version:` field.
   - Example: To increment the build number:
     ```yaml
     version: 1.0.0+1
     ```
     Update to:
     ```yaml
     version: 1.0.0+2
     ```

---

## Keystore Management

### Deleting an Existing Keystore Alias
If you need to delete an existing keystore alias, use the following command:
```bash
keytool -delete -alias upload -keystore $env:USERPROFILE\upload-keystore.jks
```

### Creating a New Keystore
To create a new keystore:
```bash
keytool -genkey -v -keystore $env:USERPROFILE\upload-keystore.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

### Checking Keystore Information
To view details of your keystore, such as SHA1 and SHA256 fingerprints, run:
```bash
keytool -list -v -keystore android/app/upload-keystore.jks
```

---

## Google Play Console Upload & Signing

### Error: App Signed with Wrong Key
If you see this error in the Google Play Console:
```
Your Android App Bundle is signed with the wrong key.
```

1. Ensure your keystore matches the one expected by Google Play.
2. If correct but the error persists, temporarily remove the signing configuration from your `android/app/build.gradle` file:
   ```groovy
   signingConfig = signingConfigs.release
   ```

### Creating a New Release in Google Play Console
- Consider creating a new release or regenerating a signing key if the issue persists.
- Then upload the APK or AAB.

---

## Troubleshooting Build Issues

### Error: `Execution failed for task ':app:signReleaseBundle'`
If you encounter this error during release bundle generation:
```
Failed to read key upload from store "C:\path\to\upload-keystore.jks": Cannot recover key
```

#### Solution:
1. Verify that the `key.properties` file contains correct alias and password information:
   ```properties
   storeFile=upload-keystore.jks
   storePassword=your_store_password
   keyAlias=upload
   keyPassword=your_key_password
   ```
2. Ensure the password matches the one used during keystore generation.

---

### Gradle Build Failure
If you encounter a Gradle build error, such as:
```
Execution failed for task ':app:signReleaseBundle'.
A failure occurred while executing com.android.build.gradle.internal.tasks.FinalizeBundleTask$BundleToolRunnable
```

#### Solution:
1. Check the `key.properties` file for correctness.
2. Try clearing Gradle and Flutter caches:
   ```bash
   ./gradlew clean
   flutter clean
   flutter pub get
   flutter build appbundle --release
   ```
3. Update the Gradle wrapper version:
   - Open `android/gradle/wrapper/gradle-wrapper.properties` and set:
     ```properties
     distributionUrl=https\://services.gradle.org/distributions/gradle-8.0.2-all.zip
     ```

---

## Resolving Kotlin Version Mismatch Error
If you encounter errors related to Kotlin version mismatches, such as:
```
Module was compiled with an incompatible version of Kotlin. The binary version of its metadata is 1.8.0, expected version is 1.6.0.
```

#### Solution:
1. Update the Kotlin plugin version in `android/build.gradle`:
   ```gradle
   plugins {
       id "org.jetbrains.kotlin.android" version "1.9.10" apply false
   }
   ```
2. Sync Gradle and rebuild:
   ```bash
   flutter build appbundle --release
   ```

---

## Drive Link Setup for Android Permissions
When using Google Drive links in your app:

1. Format the link for direct download:
   - Replace the default link with: `export=download&id=YOUR_FILE_ID`.
   
2. Add necessary permissions in `AndroidManifest.xml`:
   ```xml
   <uses-permission android:name="android.permission.INTERNET" />
   <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
   <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
   ```

---

## Final Notes

### Last Encountered Error and Solution
#### Error:
```
e: C:/Users/vishn/.gradle/caches/transforms-3/0aa4da88d63f2deb0827c46751832c56/transformed/fragment-1.7.1-api.jar!/META-INF/fragment_release.kotlin_module: Module was compiled with an incompatible version of Kotlin. The binary version of its metadata is 1.8.0, expected version is 1.6.0.
e: C:/Users/vishn/.gradle/caches/transforms-3/d7fc011219779ffabf29ddb5ecb780fe/transformed/jetified-activity-1.8.1-api.jar!/META-INF/activity_release.kotlin_module: Module was compiled with an incompatible version of Kotlin. The binary version of its metadata is 1.8.0, expected version is 1.6.0.
e: C:/Users/vishn/.gradle/caches/transforms-3/9cb715769913d0a55e978e7366b82d6a/transformed/jetified-lifecycle-livedata-core-ktx-2.7.0-api.jar!/META-INF/lifecycle-livedata-core-ktx_release.kotlin_module: Module was compiled with an incompatible version of Kotlin. The binary version of its metadata is 1.8.0, expected version is 1.6.0.
...
```

#### Solution:
- In `settings.gradle`, update the Kotlin plugin version:
  ```gradle
  id "org.jetbrains.kotlin.android" version "1.7.10" apply false
  ```
  Change to:
  ```gradle
  id "org.jetbrains.kotlin.android" version "1.9.10" apply false
  ```

- Verify the `key.properties` file for correctness:
  ```properties
  storeFile=upload-keystore.jks
  storePassword=321456987
  keyAlias=upload
  keyPassword=321456987
  ```
---
```
