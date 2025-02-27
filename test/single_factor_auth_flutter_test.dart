import 'package:flutter_test/flutter_test.dart';
import 'package:single_factor_auth_flutter/single_factor_auth_flutter_platform_interface.dart';
import 'package:single_factor_auth_flutter/single_factor_auth_flutter_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockSingleFactAuthFlutterPlatform
    with MockPlatformInterfaceMixin
    implements SingleFactAuthFlutterPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final SingleFactAuthFlutterPlatform initialPlatform =
      SingleFactAuthFlutterPlatform.instance;

  test('$MethodChannelSingleFactAuthFlutter is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelSingleFactAuthFlutter>());
  });

  test('getPlatformVersion', () async {
    SingleFactAuthFlutter SingleFactorAuthFlutterPlugin =
        SingleFactAuthFlutter();
    MockSingleFactAuthFlutterPlatform fakePlatform =
        MockSingleFactAuthFlutterPlatform();
    SingleFactAuthFlutterPlatform.instance = fakePlatform;

    expect(await SingleFactorAuthFlutterPlugin.getPlatformVersion(), '42');
  });
}
