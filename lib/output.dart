
class SessionData {
  final String privateKey;
  final String publicAddress;
  final List<String>? signatures;
  final UserInfo? userInfo;

  SessionData({
    required this.privateKey,
    required this.publicAddress,
    this.signatures,
    this.userInfo,
  });

  // Factory constructor to create an instance from a JSON map
  factory SessionData.fromJson(Map<String, dynamic> json) {
    return SessionData(
      privateKey: json['privKey'],
      publicAddress: json['publicAddress'],
      signatures: json['signatures'] != null
          ? List<String>.from(json['signatures'])
          : null,
      userInfo:
          json['userInfo'] != null ? UserInfo.fromJson(json['userInfo']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'privateKey': privateKey,
      'publicAddress': publicAddress,
      'signatures': signatures,
      'userInfo': userInfo?.toJson(),
    };
  }

  @override
  String toString() {
    return 'SessionData(privateKey: $privateKey, publicAddress: $publicAddress, signatures: ${signatures?.toString()}, userInfo: ${userInfo?.toString()})';
  }
}

class UserInfo {
  final String email;
  final String name;
  final String profileImage;
  final String? aggregateVerifier;
  final String verifier;
  final String verifierId;
  final LoginType typeOfLogin;
  final String? ref;
  final String? accessToken;
  final String? idToken;
  final String? extraParams;
  final String? extraParamsPassed;
  final TorusGenericContainer state;

  UserInfo({
    required this.email,
    required this.name,
    required this.profileImage,
    this.aggregateVerifier,
    required this.verifier,
    required this.verifierId,
    required this.typeOfLogin,
    this.ref,
    this.accessToken,
    this.idToken,
    this.extraParams,
    this.extraParamsPassed,
    required this.state,
  });

  // Factory constructor to create an instance from a JSON map
  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      email: json['email'],
      name: json['name'],
      profileImage: json['profileImage'],
      aggregateVerifier: json['aggregateVerifier'],
      verifier: json['verifier'],
      verifierId: json['verifierId'],
      typeOfLogin: LoginTypeExtension.fromJson(json['typeOfLogin']),
      ref: json['ref'],
      accessToken: json['accessToken'],
      idToken: json['idToken'],
      extraParams: json['extraParams'],
      extraParamsPassed: json['extraParamsPassed'],
      state: TorusGenericContainer.fromJson(json['state']),
    );
  }

  // Method to convert an instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'name': name,
      'profileImage': profileImage,
      'aggregateVerifier': aggregateVerifier,
      'verifier': verifier,
      'verifierId': verifierId,
      'typeOfLogin': typeOfLogin.toJson(),
      'ref': ref,
      'accessToken': accessToken,
      'idToken': idToken,
      'extraParams': extraParams,
      'extraParamsPassed': extraParamsPassed,
      'state': state.toJson(),
    };
  }

  @override
  String toString() {
    return 'UserInfo(email: $email, name: $name, profileImage: $profileImage, aggregateVerifier: $aggregateVerifier, verifier: $verifier, verifierId: $verifierId, typeOfLogin: ${typeOfLogin.toString()}, ref: $ref, accessToken: $accessToken, idToken: $idToken, extraParams: $extraParams, extraParamsPassed: $extraParamsPassed, state: ${state.toString()})';
  }
}

enum LoginType {
  google,
  facebook,
  discord,
  reddit,
  twitch,
  apple,
  github,
  linkedin,
  twitter,
  weibo,
  line,
  email_password,
  email_passwordless,
  sms_passwordless,
  jwt;
}

extension LoginTypeExtension on LoginType {
  String toJson() {
    return toString().split('.').last;
  }

  static LoginType fromJson(String value) {
    return LoginType.values.firstWhere(
      (type) => type.toJson() == value,
      orElse: () => throw ArgumentError('Invalid LoginType: $value'),
    );
  }
}

class SessionToken {
  final String token;
  final String signature;
  final String nodePubx;
  final String nodePuby;

  SessionToken({
    required this.token,
    required this.signature,
    required this.nodePubx,
    required this.nodePuby,
  });

  factory SessionToken.fromJson(Map<String, dynamic> json) {
    return SessionToken(
      token: json['token'] as String,
      signature: json['signature'] as String,
      nodePubx: json['node_pubx'] as String,
      nodePuby: json['node_puby'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'signature': signature,
      'node_pubx': nodePubx,
      'node_puby': nodePuby,
    };
  }

  @override
  String toString() {
    return 'SessionToken(token: $token, signature: $signature, nodePubx: $nodePubx, nodePuby: $nodePuby)';
  }
}

class TorusGenericContainer {
  final Map<String, String> params;

  TorusGenericContainer({required this.params});

  factory TorusGenericContainer.fromJson(Map<String, dynamic> json) {
    return TorusGenericContainer(
      params: Map<String, String>.from(json['params']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'params': params,
    };
  }

  @override
  String toString() {
    return 'TorusGenericContainer(params: $params)';
  }
}
