import java.io.FileInputStream
import java.util.Base64
import java.util.Properties

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
    id("com.google.firebase.crashlytics")
}

// Values passed with --dart-define / --dart-define-from-file (e.g. config/dev.json).
// Flutter hands them to Gradle as a base64-encoded, comma-separated "dart-defines" property.
val dartDefines: Map<String, String> = (project.findProperty("dart-defines") as String?)
    ?.split(",")
    ?.mapNotNull {
        val decoded = String(Base64.getDecoder().decode(it), Charsets.UTF_8)
        val i = decoded.indexOf('=')
        if (i > 0) decoded.substring(0, i) to decoded.substring(i + 1) else null
    }
    ?.toMap()
    ?: emptyMap()

// Spandan keys: config JSON first, then ~/.gradle/gradle.properties, else empty
// (empty => the app reports "Spandan keys missing" instead of crashing).
fun spandanConfig(key: String): String =
    (dartDefines[key] ?: providers.gradleProperty(key).orNull ?: "")
        .replace("\\", "\\\\")
        .replace("\"", "\\\"")

android {
    namespace = "com.heart_health_score.heart_health_score"
    compileSdk = 36
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    buildFeatures {
        buildConfig = true
        dataBinding = true
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.heart_health_score.heart_health_score"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = 26
        targetSdk = 36
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        // Read by MainApplication.kt to initialise the Spandan SDK.
        buildConfigField("String", "SPANDAN_MASTER_KEY", "\"${spandanConfig("SPANDAN_MASTER_KEY")}\"")
        buildConfigField("String", "SPANDAN_VERIFIER_TOKEN", "\"${spandanConfig("SPANDAN_VERIFIER_TOKEN")}\"")
    }

    flavorDimensions += "env"
    productFlavors {
        create("dev") {
            dimension = "env"
            applicationIdSuffix = ".dev"
            versionNameSuffix = "-dev"
            resValue("string", "app_name", "HHS Dev")
        }
        create("prod") {
            dimension = "env"
            resValue("string", "app_name", "Heart Health Score")
        }
    }

    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"] as String?
            keyPassword = keystoreProperties["keyPassword"] as String?
            storeFile = keystoreProperties["storeFile"]?.let { file(it as String) }
            storePassword = keystoreProperties["storePassword"] as String?
        }
    }

    buildTypes {
        release {
            signingConfig = if (keystorePropertiesFile.exists())
                signingConfigs.getByName("release")
            else
                signingConfigs.getByName("debug")
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")

    // Spandan ECG SDK (GitHub Packages, see android/build.gradle.kts)
    implementation("in.sunfox.healthcare.commons.android.spandan-sdk:spandan-sdk-ui:1.1.7")
    implementation("in.sunfox.healthcare.commons.android.spandan-sdk:spandan-sdk:2.2.6")
}