class LoginParams {
  final String verifier;
  final String verifierId;
  final String idToken;
  final String? aggregateVerifier;

  LoginParams({
    required this.verifier,
    required this.verifierId,
    required this.idToken,
    this.aggregateVerifier,
  });

  Map<String, dynamic> toJson() {
    return {
      'verifier': verifier,
      'verifierId': verifierId,
      'idToken': idToken,
      'aggregateVerifier': aggregateVerifier,
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
