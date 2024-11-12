import 'dart:async';
import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/services.dart';
import 'package:single_factor_auth_flutter/input.dart';
import 'package:single_factor_auth_flutter/output.dart';

import 'single_factor_auth_flutter_platform_interface.dart';

class SingleFactorAuthFlutter {
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

  Future<void> initialize() async {
    try {
      await _channel.invokeMethod('initialize');
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
        jsonEncode(loginParamsJson),
      );
      return sfaKeyFromJson(torusKeyJson);
    } on PlatformException catch (e) {
      throw _hanldePlatformException(e);
    }
  }

  Future<SFAKey> getSessionData() async {
    try {
      final String torusKeyJson = await _channel.invokeMethod('getSessionData');
      return sfaKeyFromJson(torusKeyJson);
    } on PlatformException catch (e) {
      throw _hanldePlatformException(e);
    }
  }

  Future<bool> logout() async {
    try {
      final bool result = await _channel.invokeMethod('logout');
      return result;
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
