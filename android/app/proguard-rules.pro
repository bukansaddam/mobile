# Flutter Engine
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-dontwarn io.flutter.embedding.**

# Security & Obfuscation Enhancements
-repackageclasses ''
-allowaccessmodification
-renamesourcefileattribute SourceFile
-keepattributes *Annotation*,Signature,InnerClasses,EnclosingMethod

# Suppress ProGuard warnings for optional dependencies
-dontwarn javax.annotation.**
-dontwarn org.checkerframework.**
-dontwarn kotlin.Unit

# Google Play Services & Maps
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.android.gms.**

# Background Service
-keep class id.flutter.flutter_background_service.** { *; }

# Flutter Local Notifications
-keep class com.dexterous.flutterlocalnotifications.** { *; }

# SQFlite
-keep class com.tekartik.sqflite.** { *; }

# Camera & Media
-keep class io.flutter.plugins.camera.** { *; }
-keep class xyz.luan.audioplayers.** { *; }
-keep class com.llfbandit.record.** { *; }
