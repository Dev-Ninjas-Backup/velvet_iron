-keep class com.dexterous.flutterlocalnotifications.** { *; }
-dontwarn com.dexterous.flutterlocalnotifications.**
-keep class com.google.gson.** { *; }
-dontwarn com.google.gson.**
-keep class com.google.gson.reflect.** { *; }
-keepattributes Signature
-keepattributes *Annotation*
-keepclassmembers class * {
    @com.google.gson.annotations.SerializedName <fields>;
}
