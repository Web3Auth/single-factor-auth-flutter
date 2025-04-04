# Preserve everything under `com.web3auth.singlefactorauth` package
-keep class com.web3auth.singlefactorauth.** { *; }
-keepclassmembers class com.web3auth.singlefactorauth.** { *; }

# Preserve everything under `com.web3auth.singlefactorauth.types` package (POJOs)
-keep class com.web3auth.singlefactorauth.types.** { *; }
-keepclassmembers class com.web3auth.singlefactorauth.types.** { *; }

# Preserve enums and their members (e.g., LoginType)
-keepclassmembers enum com.web3auth.singlefactorauth.** { *; }
-keepclassmembers enum com.web3auth.singlefactorauth.types.** { *; }

# Prevent Gson from stripping interface information from TypeAdapterFactory, JsonSerializer, and JsonDeserializer
-keep class * implements com.google.gson.TypeAdapterFactory
-keep class * implements com.google.gson.JsonSerializer
-keep class * implements com.google.gson.JsonDeserializer

# Keep the UserInfo class
-keep class com.web3auth.singlefactorauth.types.UserInfo { *; }
-keepnames class com.web3auth.singlefactorauth.types.UserInfo { *; }

# Keep LoginType enum
-keep enum com.web3auth.singlefactorauth.types.LoginType { *; }
-keepnames enum com.web3auth.singlefactorauth.types.LoginType { *; }

# Keep TorusGenericContainer class
-keep class com.web3auth.singlefactorauth.types.TorusGenericContainer { *; }
-keepnames class com.web3auth.singlefactorauth.types.TorusGenericContainer { *; }

# Keep org.json library
-keep class org.json.** { *; }
-keepnames class org.json.** { *; }

# Keep Gson (if used within the SDK's Android part)
-keep class com.google.gson.** { *; }
-keepnames class com.google.gson.** { *; }

# Keep necessary attributes
-keepattributes Signature
-keepattributes *Annotation*
-keepattributes EnclosingMethod
-keepattributes InnerClasses
