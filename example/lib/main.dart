import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:single_fact_auth_flutter/input.dart';
import 'package:single_fact_auth_flutter/single_fact_auth_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _singleFactAuthFlutterPlugin = SingleFactAuthFlutter();
  String _result = '';
  bool logoutVisible = false;

  @override
  void initState() {
    super.initState();
    //initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await _singleFactAuthFlutterPlugin.getPlatformVersion() ??
              'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('SingleFactorAuthFlutter Example'),
        ),
        body: SingleChildScrollView(
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
              ),
              Visibility(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    const Icon(
                      Icons.flutter_dash,
                      size: 80,
                      color: Color(0xFF1389fd),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    const Text(
                      'Web3Auth',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 36,
                          color: Color(0xFF0364ff)),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'Welcome to SingleFactorAuthFlutter Demo',
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'Get TorusKey',
                      style: TextStyle(fontSize: 12),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                        onPressed: _torusKey(testnetTorusKey),
                        child: const Text('TestnetTorusKey')),
                    ElevatedButton(
                        onPressed: _torusKey(getAggregrateTorusKey),
                        child: const Text('TestnetAggregateTorusKey')),
                    ElevatedButton(
                        onPressed: _torusKey(aquaTorusKey),
                        child: const Text('AquaTorusKey')),
                    ElevatedButton(
                        onPressed: _torusKey(cyanTorusKey),
                        child: const Text('CyanTorusKey')),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(_result),
              )
            ],
          )),
        ),
      ),
    );
  }

  VoidCallback _torusKey(Future<String?> Function() method) {
    return () async {
      try {
        final String? response = await method();
        setState(() {
          _result = "Private Key : $response";
        });
      } on UserCancelledException {
        print("User cancelled.");
      } on UnKnownException {
        print("Unknown exception occurred");
      }
    };
  }

  Future<String?> testnetTorusKey() {
    return _singleFactAuthFlutterPlugin.getTorusKey(Web3AuthOptions(
        network: TorusNetwork.testnet,
        verifier: 'torus-test-health',
        email: 'hello@tor.us',
        idToken: Utils().es256Token("hello@tor.us")));
  }

  Future<String?> getAggregrateTorusKey() {
    return _singleFactAuthFlutterPlugin.getAggregateTorusKey(Web3AuthOptions(
        network: TorusNetwork.testnet,
        verifier: 'torus-test-health',
        email: 'hello@tor.us',
        idToken: Utils().es256Token("hello@tor.us"),
        aggregateVerifier: 'torus-test-health-aggregate'));
  }

  Future<String?> aquaTorusKey() {
    return _singleFactAuthFlutterPlugin.getTorusKey(Web3AuthOptions(
        network: TorusNetwork.aqua,
        verifier: 'torus-test-health',
        email: 'hello@tor.us',
        idToken: Utils().es256Token("hello@tor.us")));
  }

  Future<String?> cyanTorusKey() {
    return _singleFactAuthFlutterPlugin.getTorusKey(Web3AuthOptions(
        network: TorusNetwork.cyan,
        verifier: 'torus-test-health',
        email: 'hello@tor.us',
        idToken: Utils().es256Token("hello@tor.us")));
  }
}
