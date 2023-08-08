package com.web3auth.single_fact_auth_flutter

import android.content.Context
import android.util.Log
import androidx.annotation.NonNull
import com.google.gson.Gson
import com.web3auth.singlefactorauth.SingleFactorAuth
import com.web3auth.singlefactorauth.types.LoginParams
import com.web3auth.singlefactorauth.types.SingleFactorAuthArgs
import com.web3auth.singlefactorauth.types.TorusSubVerifierInfo
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import org.torusresearch.fetchnodedetails.types.TorusNetwork

/** SingleFactAuthFlutterPlugin */
class SingleFactAuthFlutterPlugin : FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private lateinit var context: Context
    private lateinit var singleFactorAuth: SingleFactorAuth
    private lateinit var singleFactorAuthArgs: SingleFactorAuthArgs
    private lateinit var loginParams: LoginParams
    private var gson: Gson = Gson()

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "single_fact_auth_flutter")
        channel.setMethodCallHandler(this)
        context = flutterPluginBinding.applicationContext
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    private fun getNetwork(network: String): TorusNetwork {
        return when (network) {
            "mainnet" -> TorusNetwork.MAINNET
            "testnet" -> TorusNetwork.TESTNET
            "aqua" -> TorusNetwork.AQUA
            "cyan" -> TorusNetwork.CYAN
            else -> TorusNetwork.MAINNET
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
                val params = gson.fromJson(initArgs, Web3AuthNetwork::class.java)
                singleFactorAuthArgs = SingleFactorAuthArgs(getNetwork(params.network))
                singleFactorAuth = SingleFactorAuth(singleFactorAuthArgs)
                return null
            }

            "initialize" -> {
                try {
                    val torusKeyCF = singleFactorAuth.initialize(context)
                    Log.d("${SingleFactAuthFlutterPlugin::class.qualifiedName}", "#initialize")
                    return if (torusKeyCF.get() != null) {
                        gson.toJson(torusKeyCF.get())
                    } else {
                        ""
                    }
                } catch (e: Throwable) {
                    throw Error(e)
                }
            }

            "getTorusKey" -> {
                try {
                    val initArgs = call.arguments<String>()
                    val params = gson.fromJson(initArgs, Web3AuthOptions::class.java)
                    loginParams = LoginParams(
                        params.verifier, params.email,
                        params.idToken
                    )
                    val torusKeyCF = singleFactorAuth.getKey(loginParams, context)
                    Log.d("${SingleFactAuthFlutterPlugin::class.qualifiedName}", "#getTorusKey")
                    return gson.toJson(torusKeyCF.get())
                } catch (e: Throwable) {
                    throw Error(e)
                }
            }

            "getAggregateTorusKey" -> {
                try {
                    val initArgs = call.arguments<String>()
                    val params = gson.fromJson(initArgs, Web3AuthOptions::class.java)
                    loginParams = LoginParams(
                        params.aggregateVerifier.toString(), params.email,
                        params.idToken,
                        arrayOf(
                            TorusSubVerifierInfo(
                                params.verifier,
                                params.idToken
                            )
                        )
                    )
                    val torusKeyCF = singleFactorAuth.getKey(loginParams, context)
                    Log.d(
                        "${SingleFactAuthFlutterPlugin::class.qualifiedName}",
                        "#getAggregateTorusKey"
                    )
                    return gson.toJson(torusKeyCF.get())
                } catch (e: Throwable) {
                    throw Error(e)
                }
            }
        }
        throw NotImplementedError()
    }
}
