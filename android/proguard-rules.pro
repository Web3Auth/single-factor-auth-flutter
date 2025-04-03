# Keep your plugin class and its methods
-keep class com.web3auth.single_factor_auth_flutter.SingleFactorAuthFlutterPlugin { *; }
-keep class com.web3auth.single_factor_auth_flutter.SFAOptions { *; }
-keep class com.web3auth.singlefactorauth.** { *; }
-keep class com.web3auth.singlefactorauth.types.** { *; }

-keep class org.torusresearch.fetchnodedetails.** { *; }
-keep class org.torusresearch.fetchnodedetails.FetchNodeDetails { *; }
-keep class org.torusresearch.fetchnodedetails.types.NodeDetails { *; }
-keep class org.torusresearch.fetchnodedetails.types.TorusNodePub { *; }
-keep class org.torusresearch.fetchnodedetails.** { public *; }
-dontwarn org.torusresearch.fetchnodedetails.**
-dontwarn org.torusresearch.**

# Prevent Gson from stripping necessary attributes
-keepattributes Signature, RuntimeVisibleAnnotations

# Keep Gson-related classes (usually required)
-keep class com.google.gson.** { *; }
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

