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
    
    private func getNetwork(_ network: String) -> Web3AuthNetwork {
        switch network {
        case "mainnet":
            return Web3AuthNetwork.MAINNET
        case "testnet":
            return Web3AuthNetwork.TESTNET
        case "aqua":
            return Web3AuthNetwork.AQUA
        case "cyan":
            return Web3AuthNetwork.CYAN
        default:
            return Web3AuthNetwork.MAINNET
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
                    web3AuthClientId: params.clientid,
                    network: self.getNetwork(params.network)
                )
                
                let singleFactorAuth =  SingleFactorAuth(
                    singleFactorAuthArgs: singleFactorAuthArgs!
                )
                
                self.singleFactorAuth = singleFactorAuth
                return result(nil)
                
            case "initialize":
                do {
                    guard let torusKeyCF = try await singleFactorAuth?.initialize() else {
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
                
                guard let aggregateVerifier = params.aggregateVerifier else {
                   return result(throwParamMissingError(param: "aggregateVerifier"))
                }
                
                let loginParams = LoginParams(
                    verifier: params.aggregateVerifier!,
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
    
    public func throwParamMissingError(param: String) -> FlutterError {
        return FlutterError(
            code: "missing_param", message: param, details: nil
        )
    }
    
}

struct InitParams: Codable {
    var network: String
    var clientid: String
}

struct getTorusKeyParams: Codable {
    var verifier: String
    var verifierId: String
    var idToken: String
    var aggregateVerifier: String?
}
