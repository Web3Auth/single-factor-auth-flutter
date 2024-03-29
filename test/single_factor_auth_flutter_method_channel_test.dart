import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:single_factor_auth_flutter/single_factor_auth_flutter_method_channel.dart';

void main() {
  MethodChannelSingleFactAuthFlutter platform =
      MethodChannelSingleFactAuthFlutter();
  const MethodChannel channel = MethodChannel('single_factor_auth_flutter');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
