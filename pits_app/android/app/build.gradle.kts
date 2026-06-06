plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.pitsapp"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "28.2.13676358"

    packaging {
        jniLibs {
            useLegacyPackaging = true
            keepDebugSymbols += "**/*.so"
        }

        doNotStrip += "**/*.so"
    }

    splits {
        abi {
            isEnable = false
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.pitsapp"
        minSdk = flutter.minSdkVersion
        targetSdk = 35
        versionCode = 11
        versionName = "2.0.0"
    }

    signingConfigs {
        create("release") {
            keyAlias = "keyPitsApp"
            keyPassword = "Pitsadmin2022**"
            storeFile = file("/home/diegol-linux/keys/key.jks")
            storePassword = "Pitsadmin2022**"
        }

        getByName("debug") {
            keyAlias = "keyPitsApp"
            keyPassword = "Pitsadmin2022**"
            storeFile = file("/home/diegol-linux/keys/key.jks")
            storePassword = "Pitsadmin2022**"
        }
    }

    buildTypes {
        debug {
            signingConfig = signingConfigs.getByName("debug")
        }
        release {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = false
            isShrinkResources = false
            ndk {
                debugSymbolLevel = "NONE"
            }
        }
    }
}

flutter {
    source = "../.."
}
