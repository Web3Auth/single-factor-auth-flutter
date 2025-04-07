# Keep your plugin class and its methods
-keep class com.web3auth.single_factor_auth_flutter.SingleFactorAuthFlutterPlugin { *; }
-keep class com.web3auth.single_factor_auth_flutter.SFAOptions { *; }
-keep class com.web3auth.singlefactorauth.** { *; }
-keep class com.web3auth.singlefactorauth.types.** { *; }

-keep class org.torusresearch.fetchnodedetails.** { *; }
-keep class org.torusresearch.fetchnodedetails.** { public *; }
-keep class org.torusresearch.fetchnodedetails.FetchNodeDetails {
    public *;
}
-keep class org.torusresearch.fetchnodedetails.types.NodeDetails {
    <fields>;
    <methods>;
}
-keep class org.torusresearch.fetchnodedetails.types.TorusNodePub {
    <fields>;
    <methods>;
}
-keep class org.torusresearch.fetchnodedetails.types.** {
    <fields>;
    <methods>;
}
-dontwarn org.torusresearch.fetchnodedetails.**
-dontwarn org.torusresearch.**

-keepattributes Signature
-keepattributes *Annotation*
-keepattributes EnclosingMethod
-keepattributes InnerClasses
-keepclassmembers class * {
    @com.google.gson.annotations.SerializedName <fields>;
}

# Keep generic types used via TypeToken
-keepclassmembers class * {
    ** fromJson(...);
}

# Prevent CompletableFuture-related class stripping
-dontwarn java.util.concurrent.CompletableFuture


-keep class com.web3auth.singlefactorauth.types.SessionData { *; }
-keep class com.web3auth.singlefactorauth.types.UserInfo { *; }
-keep class com.web3auth.singlefactorauth.types.TorusGenericContainer { *; }
-keepclassmembers class com.web3auth.singlefactorauth.types.TorusGenericContainer {
    <fields>;
}
-keepclassmembers class com.web3auth.singlefactorauth.types.UserInfo {
    <fields>;
}
-keepclassmembers class com.web3auth.singlefactorauth.types.SessionData {
    <fields>;
}
-keep class * implements java.io.Serializable { *; }
-keepclassmembers class kotlin.jvm.internal.** {
    *;
}
-keepclassmembers class kotlinx.coroutines.** {
    *;
}
-keepattributes Signature, RuntimeVisibleAnnotations, EnclosingMethod
-keepattributes *Annotation*
-keep class com.web3auth.single_factor_auth_flutter.** { *; }
-dontwarn java.lang.reflect.**

# Prevent Gson from stripping necessary attributes
-keepattributes Signature, RuntimeVisibleAnnotations

# Keep Gson-related classes (usually required)
-keep class com.google.gson.** { *; }
-keepnames class com.google.gson.** { *; }
-dontwarn com.google.gson.**

# Keep classes used by reflection (especially if you use Gson or any other serializer)
-keep class com.web3auth.** { *; }

# Keep all classes and methods under kotlinx.coroutines.intrinsics
-keep class kotlinx.coroutines.intrinsics.** { *; }

# Keep all coroutine-related classes (this was likely working for you before)
-keep class kotlinx.coroutines.** { *; }
-keep class kotlin.coroutines.** { *; }
-keep class kotlinx.coroutines.internal.** { *; }
-keep class kotlinx.coroutines.scheduling.** { *; }

# Preserve BouncyCastle Provider classes and interfaces
-keep class org.bouncycastle.** { *; }
-dontwarn org.bouncycastle.**

# Preserve BC's JSSE classes for SSL/TLS support
-keep class org.bouncycastle.jsse.** { *; }
-dontwarn org.bouncycastle.jsse.**

# Preserve BC's Jcajce classes for cryptography
-keep class org.bouncycastle.jcajce.** { *; }
-dontwarn org.bouncycastle.jcajce.**

# Preserve BC's ASN.1 classes (for parsing ASN.1 data)
-keep class org.bouncycastle.asn1.** { *; }
-dontwarn org.bouncycastle.asn1.**

# Preserve BC's PGP classes (if you're using PGP functionality)
-keep class org.bouncycastle.openpgp.** { *; }
-dontwarn org.bouncycastle.openpgp.**

# Prevent stripping of static initializers (important for security providers)
-keepclassmembers class org.bouncycastle.** {
    static <fields>;
    static <methods>;
}

# Keep classes used by BCJSSE for SSL/TLS
-keep class org.bouncycastle.jsse.provider.** { *; }

# Suppress warnings related to missing classes (if any)
-dontwarn org.bouncycastle.**

# Keep the LoginType enum
-keep enum com.web3auth.singlefactorauth.types.LoginType { *; }

-keepnames class com.web3auth.single_factor_auth_flutter.** { *; }
-keepnames class com.web3auth.singlefactorauth.types.UserInfo { *; }
-keepnames enum com.web3auth.singlefactorauth.types.LoginType { *; }
-keepnames class com.web3auth.singlefactorauth.types.TorusGenericContainer { *; }

# Keep the specific JSON library classes being used (org.json in this case)
-keep class org.json.** { *; }
-keepnames class org.json.** { *; }

# Keep attributes related to generics and annotations for Gson and potentially other reflection
-keepattributes Signature
-keepattributes *Annotation*
-keepattributes EnclosingMethod
-keepattributes InnerClasses


