# Nexia

A new Flutter project.

## Getting Started

Make sure u upload the drive link in a diff format for direct download andd permission in android xml 
drive link should be like export=download = id 

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

To update the version change the version of the pubsoec.yaml to +next number 

keytool -delete -alias upload -keystore $env:USERPROFILE\upload-keystore.jks  
// to delete the existing keynotes 

keytool -genkey -v -keystore $env:USERPROFILE\upload-keystore.jks `
        -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 `
         -alias upload
// to create new one .
// passwd in android/key.properties

keytool -list -v -keystore android/app/upload-keystore.jks
// to check the id of keystore.jks

// if there is an error like this Your Android App Bundle is signed with the wrong key. Ensure that your App Bundle is signed with the correct signing key and try again. Your App Bundle is expected to be signed with the certificate with fingerprint:
SHA1: 4A:BE:8F:EE:0E:65:B6:47:2A:9A:3E:26:25:C0:91:8D:BC:47:8B:E2
but the certificate used to sign the App Bundle you uploaded has fingerprint:
SHA1: A0:6B:1D:A6:3C:04:12:F2:CE:94:AC:62:DF:22:DD:C2:84:F3:0D:E9
 -- just remove the signingConfig = signingConfigs.release from build.gradle

//when running on google play console create new relaease or new signing key  then upload the 
// apk or aab

if having issue or error like this 
FAILURE: Build failed with an exception.

* What went wrong:
Execution failed for task ':app:signReleaseBundle'.
> A failure occurred while executing com.android.build.gradle.internal.tasks.FinalizeBundleTask$BundleToolRunnable
   > Failed to read key upload from store "C:\Users\vishn\OneDrive\Desktop\note\project_name\android\app\upload-keystore.jks": Cannot recover key

* Try:
> Run with --stacktrace option to get the stack trace.
> Run with --info or --debug option to get more log output.
> Run with --scan to get full insights.
> Get more help at https://help.gradle.org.

BUILD FAILED in 1m 40s
Running Gradle task 'bundleRelease'...                            101.2s
Gradle task bundleRelease failed with exit code 1 


try to check the key.properties name is correct and password , just change the gradle version to 7.5 and run then a error comes . then change the gradle version to previous version it will work . also check the build gradle well