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
