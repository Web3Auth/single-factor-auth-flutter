import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:single_fact_auth_flutter/input.dart';

import 'single_fact_auth_flutter_platform_interface.dart';

class SingleFactAuthFlutter {
  static const MethodChannel _channel =
      MethodChannel('single_fact_auth_flutter');

  Future<String?> getPlatformVersion() {
    return SingleFactAuthFlutterPlatform.instance.getPlatformVersion();
  }

  Future<void> init(Web3AuthNetwork initParams) async {
    Map<String, dynamic> initParamsJson = initParams.toJson();
    initParamsJson.removeWhere((key, value) => value == null);
    await _channel.invokeMethod('init', jsonEncode(initParamsJson));
  }

  Future<String> initialize() async {
    try {
      final String privKey =
          await _channel.invokeMethod('initialize', jsonEncode({}));
      return privKey;
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

  Future<String> getTorusKey(Web3AuthOptions web3authOptions) async {
    try {
      Map<String, dynamic> loginParamsJson = web3authOptions.toJson();
      loginParamsJson.removeWhere((key, value) => value == null);
      final String privateKey = await _channel.invokeMethod(
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

  Future<String> getAggregateTorusKey(Web3AuthOptions web3authOptions) async {
    try {
      Map<String, dynamic> loginParamsJson = web3authOptions.toJson();
      loginParamsJson.removeWhere((key, value) => value == null);
      final String privateKey = await _channel.invokeMethod(
          'getAggregateTorusKey', jsonEncode(web3authOptions));
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
