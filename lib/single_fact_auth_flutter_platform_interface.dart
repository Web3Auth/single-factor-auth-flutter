import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'single_fact_auth_flutter_method_channel.dart';

abstract class SingleFactAuthFlutterPlatform extends PlatformInterface {
  /// Constructs a SingleFactAuthFlutterPlatform.
  SingleFactAuthFlutterPlatform() : super(token: _token);

  static final Object _token = Object();

  static SingleFactAuthFlutterPlatform _instance = MethodChannelSingleFactAuthFlutter();

  /// The default instance of [SingleFactAuthFlutterPlatform] to use.
  ///
  /// Defaults to [MethodChannelSingleFactAuthFlutter].
  static SingleFactAuthFlutterPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [SingleFactAuthFlutterPlatform] when
  /// they register themselves.
  static set instance(SingleFactAuthFlutterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
