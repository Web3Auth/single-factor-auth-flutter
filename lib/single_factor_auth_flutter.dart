import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:single_factor_auth_flutter/input.dart';
import 'package:single_factor_auth_flutter/output.dart';

import 'single_factor_auth_flutter_platform_interface.dart';

class SingleFactAuthFlutter {
  static const MethodChannel _channel =
      MethodChannel('single_factor_auth_flutter');

  Future<String?> getPlatformVersion() {
    return SingleFactAuthFlutterPlatform.instance.getPlatformVersion();
  }

  Future<void> init(SFAParams initParams) async {
    Map<String, dynamic> initParamsJson = initParams.toJson();
    initParamsJson.removeWhere((key, value) => value == null);
    await _channel.invokeMethod('init', jsonEncode(initParamsJson));
  }

  Future<SFAKey?> initialize() async {
    try {
      final String? sfaKeyJson = await _channel.invokeMethod(
        'initialize',
      );

      if (sfaKeyJson != null) {
        return sfaKeyFromJson(sfaKeyJson);
      }
      return null;
    } on PlatformException catch (e) {
      throw _hanldePlatformException(e);
    }
  }

  Future<SFAKey> connect(LoginParams loginParams) async {
    try {
      Map<String, dynamic> loginParamsJson = loginParams.toJson();
      loginParamsJson.removeWhere((key, value) => value == null);
      final String torusKeyJson = await _channel.invokeMethod(
        'connect',
        jsonEncode(loginParams),
      );
      return sfaKeyFromJson(torusKeyJson);
    } on PlatformException catch (e) {
      throw _hanldePlatformException(e);
    }
  }

  Future<bool> isSessionIdExists() async {
    try {
      bool response = await _channel.invokeMethod('isSessionIdExists');
      return response;
    } on PlatformException catch (e) {
      throw _hanldePlatformException(e);
    }
  }

  Exception _hanldePlatformException(PlatformException e) {
    switch (e.code) {
      case "UserCancelledException":
        throw UserCancelledException();
      case "NoAllowedBrowserFoundException":
        throw UnKnownException(e.message);
      case "key_not_generated":
        throw PrivateKeyNotGeneratedException();
      case "missing_param":
        throw MissingParamException(paramName: e.message!);
      default:
        throw e;
    }
  }
}
