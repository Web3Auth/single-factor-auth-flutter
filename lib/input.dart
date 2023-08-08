import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

class Web3AuthOptions {
  final String verifier;
  final String email;
  final String idToken;
  final String? aggregateVerifier;

  Web3AuthOptions({
    required this.verifier,
    required this.email,
    required this.idToken,
    this.aggregateVerifier,
  });

  Map<String, dynamic> toJson() {
    return {
      'verifier': verifier,
      'email': email,
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

class UnKnownException implements Exception {
  final String? message;

  UnKnownException(this.message);
}

class Utils {
  String es256Token(String email) {
    String token;

    /* Sign */ {
      // Create a json web token
      final jwt = JWT({
        "sub": "email|hello",
        "aud": "torus-key-test",
        "exp": DateTime.now().millisecond,
        "iat": DateTime.now().millisecond,
        "iss": "torus-key-test",
        "email": email,
        "nickname": email.split("@")[0],
        "name": email,
        "picture": "",
        "email_verified": true
      });

      // Sign it
      final key = ECPrivateKey("-----BEGIN PRIVATE KEY-----\n"
          "MEECAQAwEwYHKoZIzj0CAQYIKoZIzj0DAQcEJzAlAgEBBCCD7oLrcKae+jVZPGx52Cb/lKhdKxpXjl9eGNa1MlY57A=="
          "\n-----END PRIVATE KEY-----");
      token = jwt.sign(key, algorithm: JWTAlgorithm.ES256);

      print('Signed token: \n $token\n');
      return token;
    }
  }
}
