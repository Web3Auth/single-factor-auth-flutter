import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:single_factor_auth_flutter/input.dart';
import 'package:single_factor_auth_flutter/single_factor_auth_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _SingleFactorAuthFlutterPlugin = SingleFactAuthFlutter();
  String _result = '';
  bool logoutVisible = false;
  TorusNetwork torusNetwork = TorusNetwork.testnet;

  @override
  void initState() {
    super.initState();
    initSdk();
  }

  Future<void> initSdk() async {
    if (Platform.isAndroid) {
      init().then((value) => initialize());
    } else if (Platform.isIOS) {
      init();
      initialize();
    } else {}
  }

  Future<void> init() async {
    await _SingleFactorAuthFlutterPlugin.init(
        Web3AuthNetwork(network: torusNetwork));
  }

  Future<void> initialize() async {
    print("initialize() called");
    final String torusKey = await _SingleFactorAuthFlutterPlugin.initialize();
    if (torusKey.isNotEmpty) {
      setState(() {
        _result = "Private Key : $torusKey";
      });
    }
  }

  @override
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
                        onPressed: _getKey(getAggregrateKey),
                        child: const Text('GetTorusKey')),
                    ElevatedButton(
                        onPressed: _initialize(),
                        child: const Text('Get Session Response')),
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

  VoidCallback _getKey(Future<String> Function() method) {
    return () async {
      try {
        final String response = await method();
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

  VoidCallback _initialize() {
    return () async {
      try {
        final String response =
            await _SingleFactorAuthFlutterPlugin.initialize();
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

  Future<String> getKey() {
    return _SingleFactorAuthFlutterPlugin.getKey(LoginParams(
        verifier: 'torus-test-health',
        verifierId: 'hello@tor.us',
        idToken: Utils().es256Token("hello@tor.us")));
  }

  Future<String> getAggregrateKey() {
    return _SingleFactorAuthFlutterPlugin.getAggregateKey(LoginParams(
        verifier: 'torus-test-health',
        verifierId: 'hello@tor.us',
        idToken: Utils().es256Token("hello@tor.us"),
        aggregateVerifier: 'torus-test-health-aggregate'));
  }
}
