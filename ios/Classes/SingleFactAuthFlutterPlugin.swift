import Flutter
import UIKit
import SingleFactorAuth

public class SingleFactAuthFlutterPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "single_fact_auth_flutter", binaryMessenger: registrar.messenger())
    let instance = SingleFactAuthFlutterPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  private func getNetwork(_ network: String) -> TorusNetwork {
    switch network {
      case "mainnet":
          return TorusNetwork.MAINNET
      case "testnet":
          return TorusNetwork.TESTNET
      case "aqua":
          return TorusNetwork.AQUA
      case "cyan":
          return TorusNetwork.CYAN
      case "celeste":
          return TorusNetwork.CELESTE
      default:
          return TorusNetwork.MAINNET
      }
  }


  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
      case "getPlatformVersion":
        result("iOS " + UIDevice.current.systemVersion)
        break
      case "getTorusKey":
        let args = call.arguments as! [String]
        let singleFactorAuthArgs = SingleFactorAuthArgs(network: self.getNetwork(args[0]))
        let singleFactorAuth = SingleFactorAuth(singleFactorAuthArgs: singleFactorAuthArgs)
        let loginParams = LoginParams(verifier: args[1], verifierId: args[2],  idToken: args[3])
        async {
          do {
            let torusKeyCF = try await singleFactorAuth.getKey(loginParams: loginParams)
            result(torusKeyCF.map { $0.toJson() })
          } catch {
            result(FlutterError(code: "key_not_generated", message: "Key not generated", details: nil))
          }
        }
        break
      case "getAggregateTorusKey":
        let args = call.arguments as! [String]
        let singleFactorAuthArgs = SingleFactorAuthArgs(network: self.getNetwork(args[0]))
        let singleFactorAuth = SingleFactorAuth(singleFactorAuthArgs: singleFactorAuthArgs)
        let loginParams = LoginParams(verifier: args[1], verifierId: args[2],  idToken: args[3], subVerifierInfoArray: [TorusSubVerifierInfo(verifier: args[1], idToken: args[3])])
        async {
          do {
            let torusKeyCF = try await singleFactorAuth.getKey(loginParams: loginParams)
            result(torusKeyCF.map { $0.toJson() })
          } catch {
            result(FlutterError(code: "key_not_generated", message: "Key not generated", details: nil))
          }
        }
        break
      default:
        break
    }
  }
}
