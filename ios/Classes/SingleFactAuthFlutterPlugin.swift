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
    
    var decoder = JSONDecoder()
    var encoder = JSONEncoder()
    var singleFactorAuthArgs:SingleFactorAuthArgs?
    var singleFactorAuth:SingleFactorAuth?

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        Task{
            switch call.method {
            case "getPlatformVersion":
                await result("iOS " + UIDevice.current.systemVersion)
                break
            case "init":
                let args = call.arguments as? String
                guard let data = args?.data(using: .utf8) else{return result(FlutterError(code: "key_not_generated", message: "Key not generated", details: nil))}
                let params = try self.decoder.decode(InitParams.self, from: data)
                singleFactorAuthArgs = SingleFactorAuthArgs(network: self.getNetwork(params.network))
                let singleFactorAuth = await SingleFactorAuth(singleFactorAuthArgs: singleFactorAuthArgs!)
                self.singleFactorAuth = singleFactorAuth
                return
                break
            case "initialize":
                var resultMap: String = ""
                do {
                    let torusKeyCF = try await singleFactorAuth?.initialize()
                    let resultData = try encoder.encode(torusKeyCF)
                    resultMap = String(decoding: resultData, as: UTF8.self)
                    return result(resultMap)
                } catch {
                    result(FlutterError(code: "key_not_generated", message: "Key not generated", details: nil))
                }
                break
            case "getTorusKey":
                var resultMap: String = ""
                let args = call.arguments as? String
                guard let data = args?.data(using: .utf8) else{return result(FlutterError(code: "key_not_generated", message: "Key not generated", details: nil))}
                let params = try self.decoder.decode(getTorusKeyParams.self, from: data)
                print(params)
               
                let loginParams = LoginParams(verifier: params.verifier, verifierId: params.email,  idToken: params.idToken)
                do {
                    let torusKeyCF = try await singleFactorAuth?.getKey(loginParams: loginParams)
                    let resultData = try encoder.encode(torusKeyCF)
                    resultMap = String(decoding: resultData, as: UTF8.self)
                    return result(resultMap)
                } catch {
                    result(FlutterError(code: "key_not_generated", message: "Key not generated", details: nil))
                }
                break
            default:
                break
            }
        }
  }
}

struct InitParams:Codable{
var network:String
}

struct getTorusKeyParams:Codable{
var verifier:String
var email:String
var idToken:String
}
