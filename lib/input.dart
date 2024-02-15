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

class Web3AuthNetwork {
  final TorusNetwork network;

  Web3AuthNetwork({required this.network});

  Map<String, dynamic> toJson() {
    return {
      'network': network.name,
    };
  }
}

enum TorusNetwork { mainnet, testnet, cyan, aqua }

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
