import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'single_fact_auth_flutter_platform_interface.dart';

/// An implementation of [SingleFactAuthFlutterPlatform] that uses method channels.
class MethodChannelSingleFactAuthFlutter extends SingleFactAuthFlutterPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('single_fact_auth_flutter');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
