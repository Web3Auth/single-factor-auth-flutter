
import 'dart:collection';
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
  WhiteLabelData? whiteLabel;
  Map<String, String>? originData;
  BuildEnv buildEnv;
  String? redirectUrl;
  String? walletSdkUrl;

  Web3AuthOptions({
    required this.network,
    required this.clientId,
    this.sessionTime = 86400,
    this.whiteLabel,
    this.originData,
    BuildEnv? buildEnv,
    this.redirectUrl,
    String? walletSdkUrl,
  })  : buildEnv = buildEnv ?? BuildEnv.production,
        walletSdkUrl =
            walletSdkUrl ?? getWalletSdkUrl(buildEnv ?? BuildEnv.production);

  Map<String, dynamic> toJson() {
    return {
      'network': network.name,
      'clientId': clientId,
      'sessionTime': sessionTime,
      'whiteLabel': whiteLabel?.toJson(),
      "originData": originData,
      'buildEnv': buildEnv.name,
      'redirectUrl': redirectUrl.toString(),
      'walletSdkUrl': walletSdkUrl,
    };
  }
}

String getWalletSdkUrl(BuildEnv? buildEnv) {
  const String walletServicesVersion = "v4";
  switch (buildEnv) {
    case BuildEnv.staging:
      return "https://staging-wallet.web3auth.io/$walletServicesVersion";
    case BuildEnv.testing:
      return "https://develop-wallet.web3auth.io";
    case BuildEnv.production:
    default:
      return "https://wallet.web3auth.io/$walletServicesVersion";
  }
}

class WhiteLabelData {
  /// Display name for the app in the UI.
  final String? appName;

  /// App logo to be used in dark mode.
  final String? logoLight;

  /// App logo to be used in light mode.
  final String? logoDark;

  /// Language which will be used by Web3Auth, app will use browser language if not specified.
  ///
  /// Default language is [Language.en]. Checkout [Language] for supported languages.
  final Language? defaultLanguage;

  /// Theme mode for the login modal
  ///
  /// Default value is [ThemeModes.auto].
  final ThemeModes? mode;

  /// Used to customize the theme of the login modal.
  final HashMap? theme;

  /// Url to be used in the Modal
  final String? appUrl;

  /// Use logo loader.
  ///
  /// If [logoDark] and [logoLight] are null, the default Web3Auth logo
  /// will be used for the loader.
  final bool? useLogoLoader;

  WhiteLabelData({
    this.appName,
    this.logoLight,
    this.logoDark,
    this.defaultLanguage = Language.en,
    this.mode = ThemeModes.auto,
    this.theme,
    this.appUrl,
    this.useLogoLoader = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'appName': appName,
      'logoLight': logoLight,
      'logoDark': logoDark,
      'defaultLanguage': defaultLanguage?.name,
      'mode': mode?.name,
      'theme': theme,
      'appUrl': appUrl,
      'useLogoLoader': useLogoLoader
    };
  }
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
