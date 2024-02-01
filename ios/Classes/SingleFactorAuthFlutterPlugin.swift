import Flutter
import UIKit
import SingleFactorAuth

public class SingleFactorAuthFlutterPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(
            name: "single_factor_auth_flutter", 
            binaryMessenger: registrar.messenger()
        )
        
        let instance = SingleFactorAuthFlutterPlugin()
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
        default:
            return TorusNetwork.MAINNET
        }
    }
    
    var decoder = JSONDecoder()
    var encoder = JSONEncoder()
    var singleFactorAuthArgs: SingleFactorAuthArgs?
    var singleFactorAuth: SingleFactorAuth?
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        Task {
            switch call.method {
            case "getPlatformVersion":
                await result("iOS " + UIDevice.current.systemVersion)
                break
            case "init":
                let args = call.arguments as? String
                guard let data = args?.data(using: .utf8) else {
                    return result(throwKeyNotGeneratedError())
                }
                
                let params = try self.decoder.decode(InitParams.self, from: data)
                
                singleFactorAuthArgs = SingleFactorAuthArgs(
                    network: self.getNetwork(params.network)
                )
                
                let singleFactorAuth =  SingleFactorAuth(
                    singleFactorAuthArgs: singleFactorAuthArgs!
                )
                
                self.singleFactorAuth = singleFactorAuth
                return result(nil)
                
            case "initialize":
                do {
                    guard let torusKeyCF = await singleFactorAuth?.initialize() else {
                        return result(nil)
                    }
                    
                    let resultData: Data = try encoder.encode(torusKeyCF)
                    let resultJson = String(decoding: resultData, as: UTF8.self)
                    return result(resultJson)
                } catch {
                    result(throwKeyNotGeneratedError())
                }
                
            case "getTorusKey":
                let args = call.arguments as? String
                guard let data = args?.data(using: .utf8) else {
                    return result(throwKeyNotGeneratedError())
                }
                let params = try self.decoder.decode(getTorusKeyParams.self, from: data)
                
                let loginParams = LoginParams(
                    verifier: params.verifier,
                    verifierId: params.verifierId,
                    idToken: params.idToken
                )
                
                do {
                    let torusKeyCF = try await singleFactorAuth?.getKey(
                        loginParams: loginParams
                    )
                    
                    let resultData = try encoder.encode(torusKeyCF)
                    let resultJson = String(decoding: resultData, as: UTF8.self)
                    return result(resultJson)
                } catch {
                    result(throwKeyNotGeneratedError())
                }
                break
                
            case "getAggregateTorusKey":
                let args = call.arguments as? String
                guard let data = args?.data(using: .utf8) else {
                    return result(throwKeyNotGeneratedError())
                }
                
                let params = try self.decoder.decode(getTorusKeyParams.self, from: data)
                
                let loginParams = LoginParams(
                    verifier: params.aggregateVerifier,
                    verifierId: params.verifierId,
                    idToken: params.idToken,
                    subVerifierInfoArray: [
                        TorusSubVerifierInfo(
                            verifier: params.verifier,
                            idToken: params.idToken
                        )
                    ])
                
                do {
                    let torusKeyCF = try await singleFactorAuth?.getKey(
                        loginParams: loginParams
                    )
                    
                    let resultData = try encoder.encode(torusKeyCF)
                    let resultJson = String(decoding: resultData, as: UTF8.self)
                    return result(resultJson)
                } catch {
                    result(throwKeyNotGeneratedError())
                }
                break
            default:
                break
            }
        }
    }
    
    public func throwKeyNotGeneratedError() -> FlutterError {
        return FlutterError(
            code: "key_not_generated", message: "Key not generated", details: nil
        )
    }
    
}

struct InitParams: Codable {
    var network: String
}

struct getTorusKeyParams: Codable {
    var verifier: String
    var verifierId: String
    var idToken: String
    var aggregateVerifier: String
}
