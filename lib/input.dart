class LoginParams {
  final String verifier;
  final String verifierId;
  final String idToken;
  List<TorusSubVerifierInfo>? subVerifierInfoArray;

  LoginParams({
    required this.verifier,
    required this.verifierId,
    required this.idToken,
    this.subVerifierInfoArray, //Optional
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'verifier': verifier,
      'verifierId': verifierId,
      'idToken': idToken,
    };

    if (subVerifierInfoArray != null) {
      data['subVerifierInfoArray'] = subVerifierInfoArray!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

class TorusSubVerifierInfo {
  String verifier;
  String idToken;

  TorusSubVerifierInfo(this.verifier, this.idToken);

  Map<String, dynamic> toJson() {
    return {
      'verifier': verifier,
      'idToken': idToken,
    };
  }
}

class SFAParams {
  final Web3AuthNetwork network;
  final String clientId;
  final int sessionTime;

  SFAParams(
      {required this.network,
      required this.clientId,
      this.sessionTime = 86400});

  Map<String, dynamic> toJson() {
    return {
      'network': network.name,
      'clientId': clientId,
      'sessionTime': sessionTime,
    };
  }
}

enum Web3AuthNetwork {
  mainnet,
  testnet,
  cyan,
  aqua,
  celeste,
  sapphire_devnet,
  sapphire_mainnet
}

class ChainConfig {
  final ChainNamespace chainNamespace;
  final int? decimals;
  final String? blockExplorerUrl;
  final String chainId;
  final String? displayName;
  final String? logo;
  final String rpcTarget;
  final String? ticker;
  final String? tickerName;

  ChainConfig({
    this.chainNamespace = ChainNamespace.eip155,
    this.decimals = 18,
    this.blockExplorerUrl,
    required this.chainId,
    this.displayName,
    this.logo,
    required this.rpcTarget,
    this.ticker,
    this.tickerName,
  });

  Map<String, dynamic> toJson() {
    return {
      'chainNamespace': chainNamespace.name,
      'decimals': decimals,
      'blockExplorerUrl': blockExplorerUrl,
      'chainId': chainId,
      'displayName': displayName,
      'logo': logo,
      'rpcTarget': rpcTarget,
      'ticker': ticker,
      'tickerName': tickerName
    };
  }
}

class SignResponse {
  final bool success;
  final String? result;
  final String? error;

  SignResponse({
    required this.success,
    this.result,
    this.error,
  });

  @override
  String toString() {
    return "{success=$success, result = $result, error=$error}";
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'result': result, 'error': error};
  }

  SignResponse.fromJson(Map<String, dynamic> json)
      : success = json['success'],
        result = json['result'],
        error = json['error'];
}

class UserCancelledException implements Exception {}

class PrivateKeyNotGeneratedException implements Exception {}

class MissingParamException implements Exception {
  final String paramName;

  MissingParamException({required this.paramName});
}

class UnKnownException implements Exception {
  final String? message;

  UnKnownException(this.message);
}

enum BuildEnv { production, staging, testing }

enum ChainNamespace { eip155, solana }

enum Language { en, de, ja, ko, zh, es, fr, pt, nl, tr }

enum ThemeModes { light, dark, auto }
