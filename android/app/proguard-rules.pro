-keep class io.flutter.** { *; }
-keep class com.google.firebase.** { *; }
-dontwarn com.google.android.play.core.**

# flutter_local_notifications (Gson). Verify against the plugin README for your version.
-keep class com.google.gson.reflect.TypeToken
-keep class * extends com.google.gson.reflect.TypeToken
-keep public class * implements com.google.gson.TypeAdapterFactory
-keep public class * implements com.google.gson.JsonSerializer
-keep public class * implements com.google.gson.JsonDeserializer
-keep class in.sunfox.** { *; }
-dontwarn in.sunfox.**

# --- Spandan SDK internals (Retrofit / OkHttp / Gson / Kotlin coroutines) ---
-keepattributes Signature, InnerClasses, EnclosingMethod, Exceptions, *Annotation*, AnnotationDefault

-keep class retrofit2.** { *; }
-keep interface retrofit2.** { *; }
-keep,allowobfuscation,allowshrinking class kotlin.coroutines.Continuation
-keep,allowobfuscation,allowshrinking class retrofit2.Response
-keep,allowobfuscation,allowshrinking interface retrofit2.Call

-keep class com.google.gson.** { *; }
-keep class com.ebionet.** { *; }

-dontwarn retrofit2.**
-dontwarn okhttp3.**
-dontwarn okio.**
-dontwarn com.ebionet.**

-keep class androidx.databinding.** { *; }
-dontwarn androidx.databinding.**