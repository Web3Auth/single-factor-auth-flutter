import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:single_factor_auth_flutter/input.dart';
import 'package:single_factor_auth_flutter/output.dart';
import 'package:single_factor_auth_flutter/single_factor_auth_flutter.dart';
import './utils.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _singleFactorAuthFlutterPlugin = SingleFactAuthFlutter();
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
      await init();
      initialize();
    } else if (Platform.isIOS) {
      await init();
      initialize();
    } else {}
  }

  Future<void> init() async {
    await _singleFactorAuthFlutterPlugin
        .init(Web3AuthNetwork(network: torusNetwork));
  }

  Future<void> initialize() async {
    log("initialize() called");
    final TorusKey? torusKey =
        await _singleFactorAuthFlutterPlugin.initialize();
    if (torusKey != null) {
      setState(() {
        _result = "Private Key : ${torusKey.privateKey}";
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
                      child: const Text('GetTorusKey'),
                    ),
                    ElevatedButton(
                      onPressed: () => _initialize(),
                      child: const Text('Get Session Response'),
                    ),
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

  VoidCallback _getKey(Future<TorusKey> Function() method) {
    return () async {
      try {
        final TorusKey response = await method();
        setState(() {
          _result = "Private Key : ${response.privateKey}";
          log(response.publicAddress);
        });
      } on PrivateKeyNotGeneratedException {
        log("Private key not generated");
      } on UnKnownException {
        log("Unknown exception occurred");
      }
    };
  }

  Future<void> _initialize() async {
    try {
      final TorusKey? response =
          await _singleFactorAuthFlutterPlugin.initialize();
      setState(() {
        _result = "Private Key : ${response?.privateKey}";
        log(response!.publicAddress);
      });
    } on PrivateKeyNotGeneratedException {
      log("Private key not generated");
    } on UnKnownException {
      log("Unknown exception occurred");
    }
  }

  Future<TorusKey> getKey() {
    return _singleFactorAuthFlutterPlugin.getKey(
      LoginParams(
        verifier: 'torus-test-health',
        verifierId: 'hello@tor.us',
        idToken: Utils().es256Token("hello@tor.us"),
      ),
    );
  }

  Future<TorusKey> getAggregrateKey() {
    return _singleFactorAuthFlutterPlugin.getAggregateKey(
      LoginParams(
        verifier: 'torus-test-health',
        verifierId: 'hello@tor.us',
        idToken: Utils().es256Token("hello@tor.us"),
        aggregateVerifier: 'torus-test-health-aggregate',
      ),
    );
  }
}
