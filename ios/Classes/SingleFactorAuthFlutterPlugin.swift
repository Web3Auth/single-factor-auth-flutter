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
            return .legacy(.MAINNET)
        case "testnet":
            return .legacy(.TESTNET)
        case "aqua":
            return .legacy(.AQUA)
        case "cyan":
            return .legacy(.CYAN)
        case "sapphire_devnet":
            return .sapphire(.SAPPHIRE_DEVNET)
        case "sapphire_mainnet":
            return .sapphire(.SAPPHIRE_MAINNET)
        default:
            return .sapphire(.SAPPHIRE_MAINNET)
        }
    }
    
    var decoder = JSONDecoder()
    var encoder = JSONEncoder()
    var sfaParams: SFAParams?
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
                
                sfaParams = SFAParams(
                    web3AuthClientId: params.clientId,
                    network: self.getNetwork(params.network),
                    sessionTime: params.sessionTime ?? 86400
                )
                
                let singleFactorAuth =  try SingleFactorAuth(
                    params: sfaParams!
                )
                
                self.singleFactorAuth = singleFactorAuth
                return result(nil)
                break
                
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
                break
                
            case "connect":
                let args = call.arguments as? String
                guard let data = args?.data(using: .utf8) else {
                    return result(throwKeyNotGeneratedError())
                }

                let loginParams = try self.decoder.decode(LoginParams.self, from: data)
                
                do {
                  
                    let torusKeyCF = try await singleFactorAuth?.connect(
                        loginParams: loginParams
                    )
                    
                    let resultData = try encoder.encode(torusKeyCF)
                    let resultJson = String(decoding: resultData, as: UTF8.self)
                    return result(resultJson)
                } catch {
                    result(throwKeyNotGeneratedError())
                }
                break

            case "logout":
                do {
                    let logoutResult = try await singleFactorAuth?.logout()
                    return result(logoutResult)
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
    var clientId: String
    var sessionTime: Int? = 86400
}

struct getTorusKeyParams: Codable {
    var verifier: String
    var verifierId: String
    var idToken: String
    var aggregateVerifier: String?
}
