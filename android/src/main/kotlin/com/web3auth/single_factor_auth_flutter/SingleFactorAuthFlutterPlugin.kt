package com.web3auth.single_factor_auth_flutter

import android.app.Activity
import android.net.Uri
import android.util.Log
import androidx.annotation.NonNull
import com.google.gson.Gson
import com.google.gson.JsonArray
import com.google.gson.JsonElement
import com.google.gson.JsonPrimitive
import com.web3auth.singlefactorauth.SingleFactorAuth
import com.web3auth.singlefactorauth.types.ChainConfig
import com.web3auth.singlefactorauth.types.LoginParams
import com.web3auth.singlefactorauth.types.SessionData
import com.web3auth.singlefactorauth.types.Web3AuthOptions
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import org.torusresearch.fetchnodedetails.types.Web3AuthNetwork

/** SingleFactorAuthFlutterPlugin */
class SingleFactorAuthFlutterPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private var activity: Activity? = null
    private lateinit var singleFactorAuth: SingleFactorAuth
    private lateinit var web3AuthOptions: Web3AuthOptions
    private lateinit var loginParams: LoginParams
    private var gson: Gson = Gson()

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "single_factor_auth_flutter")
        channel.setMethodCallHandler(this)
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
                val initArgs = call.arguments<String>()
                val params = gson.fromJson(initArgs, SFAOptions::class.java)
                web3AuthOptions =
                    Web3AuthOptions(
                        params.clientId, getNetwork(params.network), params.sessionTime,
                        redirectUrl = Uri.parse(params.redirectUrl)
                    )
                singleFactorAuth = SingleFactorAuth(web3AuthOptions, activity!!)
                return null
            }

            "initialize" -> {
                try {
                    val sfaKey = singleFactorAuth.initialize(activity!!)
                    Log.d("${SingleFactorAuthFlutterPlugin::class.qualifiedName}", "#initialize")
                    return null
                } catch (e: Throwable) {
                    throw Error(e)
                }
            }

            "connect" -> {
                try {
                    val initArgs = call.arguments<String>()
                    val loginParams = gson.fromJson(initArgs, LoginParams::class.java)
                    val sessionData = singleFactorAuth.connect(loginParams, activity!!)
                    Log.d("${SingleFactorAuthFlutterPlugin::class.qualifiedName}", "#connect")
                    val result: SessionData = sessionData
                    return gson.toJson(result)
                } catch (e: Throwable) {
                    throw Error(e)
                }
            }

            "logout" -> {
                try {
                    val logoutCF = singleFactorAuth.logout(activity!!)
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
                    singleFactorAuth.initialize(activity!!).get()
                    var sessionData = singleFactorAuth.getSessionData()
                    val loginResult: SessionData? = sessionData
                    return if (loginResult == null) {
                        null
                    } else {
                        gson.toJson(loginResult)
                    }
                } catch (e: Throwable) {
                    Log.e(
                        "${SingleFactorAuthFlutterPlugin::class.qualifiedName}",
                        "Error retrieving session data",
                        e
                    )
                    return null
                }
            }

            "connected" -> {
                try {
                    return singleFactorAuth.isConnected()
                } catch (e: Throwable) {
                    throw Error(e)
                }
            }

            "showWalletUI" -> {
                try {
                    Log.d("${SingleFactorAuthFlutterPlugin::class.qualifiedName}", "#showWalletUI")
                    val wsArgs = call.arguments<String>() ?: return null
                    val wsParams = gson.fromJson(wsArgs, WalletServicesJson::class.java)
                    Log.d(wsParams.toString(), "#wsParams")
                    val launchWalletCF = singleFactorAuth.showWalletUI(
                        chainConfig = wsParams.chainConfig,
                        path = wsParams.path
                    )
                    launchWalletCF.get()
                    return null
                } catch (e: NotImplementedError) {
                    throw Error(e)
                } catch (e: Throwable) {
                    throw Error(e)
                }
            }

            "request" -> {
                try {
                    Log.d("${SingleFactorAuthFlutterPlugin::class.qualifiedName}", "#request")
                    val requestArgs = call.arguments<String>() ?: return null
                    val reqParams = gson.fromJson(requestArgs, RequestJson::class.java)
                    Log.d(reqParams.toString(), "#reqParams")
                    val requestCF = singleFactorAuth.request(
                        chainConfig = reqParams.chainConfig,
                        method = reqParams.method,
                        requestParams = convertListToJsonArray(reqParams.requestParams),
                        path = reqParams.path,
                        appState = reqParams.appState
                    )
                    return gson.toJson(requestCF.get())
                } catch (e: NotImplementedError) {
                    throw Error(e)
                } catch (e: Throwable) {
                    throw Error(e)
                }
            }


        }
        throw NotImplementedError()
    }

    private fun convertListToJsonArray(list: List<Any?>): JsonArray {
        val jsonArray = JsonArray()
        val gson = Gson()

        list.forEach { item ->
            val jsonElement: JsonElement = when (item) {
                is Number -> JsonPrimitive(item)
                is String -> JsonPrimitive(item)
                is Boolean -> JsonPrimitive(item)
                is Map<*, *> -> gson.toJsonTree(item)
                is List<*> -> convertListToJsonArray(item)
                null -> JsonPrimitive("")
                else -> throw IllegalArgumentException("Unsupported type: ${item::class.java}")
            }
            jsonArray.add(jsonElement)
        }
        return jsonArray
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivity() {
        activity = null
    }
}

data class WalletServicesJson(
    val chainConfig: ChainConfig,
    val path: String? = "wallet"
)

data class RequestJson(
    val chainConfig: ChainConfig,
    val method: String,
    val requestParams: List<Any?>,
    val path: String? = "wallet/request",
    val appState: String? = null
)
