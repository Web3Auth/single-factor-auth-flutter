package com.web3auth.single_fact_auth_flutter

import android.content.Context
import android.content.Intent
import androidx.annotation.NonNull
import com.github.web3auth.singlefactorauth.SingleFactorAuth
import com.github.web3auth.singlefactorauth.types.LoginParams
import com.github.web3auth.singlefactorauth.types.SingleFactorAuthArgs
import com.github.web3auth.singlefactorauth.types.TorusSubVerifierInfo
import com.google.gson.Gson
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.PluginRegistry
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import org.json.JSONObject
import org.torusresearch.fetchnodedetails.types.TorusNetwork
import java.math.BigInteger

/** SingleFactAuthFlutterPlugin */
class SingleFactAuthFlutterPlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private lateinit var context: Context
  private lateinit var singleFactorAuth: SingleFactorAuth
  private lateinit var singleFactorAuthArgs: SingleFactorAuthArgs
  private lateinit var loginParams: LoginParams
  private var gson: Gson = Gson()

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "single_fact_auth_flutter")
    channel.setMethodCallHandler(this)
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  private fun getNetwork(network: String): TorusNetwork {
      return when(network) {
          "mainnet" -> TorusNetwork.MAINNET
          "testnet" -> TorusNetwork.TESTNET
          "aqua" -> TorusNetwork.AQUA
          "cyan" -> TorusNetwork.CYAN
          "celeste" -> TorusNetwork.CELESTE
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
            "getTorusKey" -> {
                val initArgs = call.arguments<String>()
                val params = gson.fromJson(initArgs, Web3AuthOptions::class.java)
                singleFactorAuthArgs = SingleFactorAuthArgs(getNetwork(params.network))
                singleFactorAuth = SingleFactorAuth(singleFactorAuthArgs)
                loginParams = LoginParams(
                    params.verifier, params.email,
                    params.idToken,
                    arrayOf(TorusSubVerifierInfo(params.email,
                        params.idToken
                    )))
                val torusKeyCF = singleFactorAuth.getKey(loginParams)
                torusKeyCF.join()
                var privateKey = BigInteger.ZERO
                torusKeyCF.whenComplete { key, error ->
                    if (error == null) {
                        privateKey = key.privateKey
                    } else {
                        throw Error(error)
                    }
                }
                return privateKey.toString(16)
            }
        }
        throw NotImplementedError()
    }  
}
