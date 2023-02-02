import 'single_fact_auth_flutter_platform_interface.dart';
import 'dart:async';
import 'dart:convert';

import 'package:single_fact_auth_flutter/input.dart';
import 'package:flutter/services.dart';

class SingleFactAuthFlutter {
  static const MethodChannel _channel =
      MethodChannel('single_fact_auth_flutter');

  Future<String?> getPlatformVersion() {
    return SingleFactAuthFlutterPlatform.instance.getPlatformVersion();
  }

  Future<String?> getTorusKey(Web3AuthOptions web3authOptions) async {
    try {
      Map<String, dynamic> loginParamsJson = web3authOptions.toJson();
      loginParamsJson.removeWhere((key, value) => value == null);
      final String? privateKey = await _channel.invokeMethod(
          'getTorusKey', jsonEncode(web3authOptions));
      return privateKey;
    } on PlatformException catch (e) {
      switch (e.code) {
        case "UserCancelledException":
          throw UserCancelledException();
        case "NoAllowedBrowserFoundException":
          throw UnKnownException(e.message);
        default:
          rethrow;
      }
    }
  }
}
