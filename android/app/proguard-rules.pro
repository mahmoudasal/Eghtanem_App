# Flutter / Dart
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-dontwarn io.flutter.embedding.**

# Keep JSON model classes used by json_serializable / retrofit
-keepattributes *Annotation*
-keep class com.eghtanem.app.** { *; }

# OkHttp (used by Dio under the hood on Android)
-dontwarn okhttp3.**
-dontwarn okio.**
-dontwarn javax.annotation.**

# Retrofit / gson
-keepattributes Signature
-keepattributes Exceptions
