plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")  // Apply Google services for Firebase
    // END: FlutterFire Configuration
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.quick_login"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"  // Ensure correct NDK version for Firebase Core

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.quick_login"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")  // Use your debug signing config
        }
    }
}

flutter {
    source = "../.."
}
