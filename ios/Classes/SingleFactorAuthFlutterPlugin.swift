import Flutter
import UIKit
import FetchNodeDetails
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
            return .MAINNET
        case "testnet":
            return .TESTNET
        case "aqua":
            return .AQUA
        case "cyan":
            return .CYAN
        case "sapphire_devnet":
            return .SAPPHIRE_DEVNET
        case "sapphire_mainnet":
            return .SAPPHIRE_MAINNET
        default:
            return .SAPPHIRE_MAINNET
        }
    }
    
    var decoder = JSONDecoder()
    var encoder = JSONEncoder()
    var web3AuthOptions: Web3AuthOptions?
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
                    return result(throwParamMissingError(param: args))
                }
                
                let params = try self.decoder.decode(InitParams.self, from: data)
                
                web3AuthOptions = Web3AuthOptions(
                    clientId: params.clientId,
                    web3AuthNetwork: self.getNetwork(params.network),
                    sessionTime: params.sessionTime ?? 86400
                )
                
                let singleFactorAuth =  try SingleFactorAuth(
                    params: web3AuthOptions!
                )
                
                self.singleFactorAuth = singleFactorAuth
                return result(nil)
                
            case "initialize":
                do {
                    try await singleFactorAuth?.initialize()
                    return result(nil)
                } catch {
                    result(FlutterError(
                                code: (error as NSError).domain,
                                message: error.localizedDescription,
                                details: String(describing: error)
                           ))
                }
                break
                
            case "connect":
                let args = call.arguments as? String
                guard let data = args?.data(using: .utf8) else {
                    return result(throwParamMissingError(param: args))
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
                    result(FlutterError(
                                code: (error as NSError).domain,
                                message: error.localizedDescription,
                                details: String(describing: error)
                            ))
                }
                break

            case "logout":
                do {
                    try await singleFactorAuth?.logout()
                    return result(nil)
                } catch {
                    result(FlutterError(
                                 code: (error as NSError).domain,
                                 message: error.localizedDescription,
                                 details: String(describing: error)
                           ))
                }
                break

            case "getSessionData":
                do {
                    let sessionData = singleFactorAuth?.getSessionData()
                    if let sessionData = sessionData {
                        let resultData = try encoder.encode(sessionData)
                        let resultJson = String(decoding: resultData, as: UTF8.self)
                        return result(resultJson)
                    } else {
                        return result(nil)
                    }
                } catch {
                    result(FlutterError(
                                 code: (error as NSError).domain,
                                 message: error.localizedDescription,
                                 details: String(describing: error)
                           ))
                }
                break

            case "connected":
                let connected = singleFactorAuth?.connected() ?? false
                result(connected)
                break

            default:
                break
            }
        }
    }
    
    public func throwParamMissingError(param: String?) -> FlutterError {
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
