package com.web3auth.single_factor_auth_flutter

import android.content.Context
import android.util.Log
import androidx.annotation.NonNull
import com.google.gson.Gson
import com.web3auth.singlefactorauth.SingleFactorAuth
import com.web3auth.singlefactorauth.types.LoginParams
import com.web3auth.singlefactorauth.types.SessionData
import com.web3auth.singlefactorauth.types.Web3AuthOptions
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import org.torusresearch.fetchnodedetails.types.Web3AuthNetwork

/** SingleFactorAuthFlutterPlugin */
class SingleFactorAuthFlutterPlugin : FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private lateinit var context: Context
    private lateinit var singleFactorAuth: SingleFactorAuth
    private lateinit var web3AuthOptions: Web3AuthOptions
    private lateinit var loginParams: LoginParams
    private var gson: Gson = Gson()

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "single_factor_auth_flutter")
        channel.setMethodCallHandler(this)
        context = flutterPluginBinding.applicationContext
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    private fun getNetwork(network: String): Web3AuthNetwork {
        return when (network) {
            "mainnet" -> Web3AuthNetwork.MAINNET
            "testnet" -> Web3AuthNetwork.TESTNET
            "aqua" -> Web3AuthNetwork.AQUA
            "cyan" -> Web3AuthNetwork.CYAN
            "celeste" -> Web3AuthNetwork.CELESTE
            "sapphire_devnet" -> Web3AuthNetwork.SAPPHIRE_DEVNET
            "sapphire_mainnet" -> Web3AuthNetwork.SAPPHIRE_MAINNET
            else -> Web3AuthNetwork.MAINNET
        }
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: MethodChannel.Result) {
        CoroutineScope(Dispatchers.Default).launch {
            try {
                val response = runMethodCall(call)
                launch(Dispatchers.Main) { result.success(response) }
            } catch (e: NotImplementedError) {
                launch(Dispatchers.Main) { result.notImplemented() }
            } catch (e: Throwable) {
                launch(Dispatchers.Main) {
                    result.error("error", e.message, e.localizedMessage)
                }
            }
        }
    }

    private fun runMethodCall(@NonNull call: MethodCall): Any? {
        when (call.method) {
            "getPlatformVersion" -> return "Android ${android.os.Build.VERSION.RELEASE}"

            "init" -> {
                try {
                    val initArgs = call.arguments<String>()
                    val params = gson.fromJson(initArgs, SFAOptions::class.java)
                    Log.d("SingleFactorAuth", "Params parsed successfully: $params")

                    web3AuthOptions = Web3AuthOptions(
                        params.clientId,
                        getNetwork(params.network),
                        params.sessionTime
                    )

                    singleFactorAuth = SingleFactorAuth(web3AuthOptions, context)
                    Log.d("SingleFactorAuth", "SingleFactorAuth initialized successfully")
                } catch (e: Exception) {
                    Log.d("SingleFactorAuth", "Initialization failed: ${e.message}")
                }
                return null
            }

            "initialize" -> {
                try {
                    singleFactorAuth.initialize(context).get()
                    Log.d("${SingleFactorAuthFlutterPlugin::class.qualifiedName}", "#initialize")
                    return null
                } catch (e: Throwable) {
                    throw Error(e)
                }
            }

            "connect" -> {
                try {
                    if(!::singleFactorAuth.isInitialized) {
                        Log.d("${SingleFactorAuthFlutterPlugin::class.qualifiedName}", "SFA not initialized.")
                    }
                    val initArgs = call.arguments<String>()
                    val loginParams = gson.fromJson(initArgs, LoginParams::class.java)
                    val sessionData = singleFactorAuth.connect(loginParams, context)
                    Log.d("${SingleFactorAuthFlutterPlugin::class.qualifiedName}", "#connect")
                    val result: SessionData = sessionData
                    return gson.toJson(result)
                } catch (e: Throwable) {
                    throw Error(e)
                }
            }

            "logout" -> {
                try {
                    val logoutCF = singleFactorAuth.logout(context)
                    Log.d("${SingleFactorAuthFlutterPlugin::class.qualifiedName}", "#logout")
                    return null
                } catch (e: Throwable) {
                    throw Error(e)
                }
            }

            "getSessionData" -> {
                try {
                    Log.d(
                        "${SingleFactorAuthFlutterPlugin::class.qualifiedName}",
                        "#getSessionData"
                    )
                    var sessionData = singleFactorAuth.getSessionData()
                    val loginResult: SessionData? = sessionData
                    return if (loginResult == null) {
                        null
                    } else {
                        gson.toJson(loginResult)
                    }
                } catch (e: Throwable) {
                    Log.d(
                        "${SingleFactorAuthFlutterPlugin::class.qualifiedName}",
                        "Error retrieving session data",
                        e
                    )
                    return gson.toJson(mapOf("error" to "Failed to retrieve session data"))
                }
            }

            "connected" -> {
                try {
                    return singleFactorAuth.isConnected()
                } catch (e: Throwable) {
                    throw Error(e)
                }
            }
        }
        throw NotImplementedError()
    }
}
