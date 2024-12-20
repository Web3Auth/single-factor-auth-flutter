import 'enums.dart';

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

class Web3AuthOptions {
  final Web3AuthNetwork network;
  final String clientId;
  final int sessionTime;

  Web3AuthOptions(
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
