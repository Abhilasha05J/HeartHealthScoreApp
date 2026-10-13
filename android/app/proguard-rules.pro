-keep class io.flutter.** { *; }
-keep class com.google.firebase.** { *; }
-dontwarn com.google.android.play.core.**

# flutter_local_notifications (Gson). Verify against the plugin README for your version.
-keep class com.google.gson.reflect.TypeToken
-keep class * extends com.google.gson.reflect.TypeToken
-keep public class * implements com.google.gson.TypeAdapterFactory
-keep public class * implements com.google.gson.JsonSerializer
-keep public class * implements com.google.gson.JsonDeserializer