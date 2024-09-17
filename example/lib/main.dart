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
  Web3AuthNetwork web3AuthNetwork = Web3AuthNetwork.sapphire_mainnet;

  @override
  void initState() {
    super.initState();
    initSdk();
  }

  Future<void> initSdk() async {
    if (Platform.isAndroid) {
      await init();
      if (await _singleFactorAuthFlutterPlugin.isSessionIdExists()) {
        initialize();
      }
    } else if (Platform.isIOS) {
      await init();
      if (await _singleFactorAuthFlutterPlugin.isSessionIdExists()) {
        initialize();
      }
    } else {}
  }

  Future<void> init() async {
    await _singleFactorAuthFlutterPlugin.init(SFAParams(
        network: web3AuthNetwork,
        clientid: 'YOUR_CLIENT_ID',
        sessionTime: 86400));
  }

  Future<void> initialize() async {
    log("initialize() called");
    final SFAKey? sfaKey = await _singleFactorAuthFlutterPlugin.initialize();
    if (sfaKey != null) {
      setState(() {
        _result =
            "Public Add : ${sfaKey.publicAddress} , Private Key : ${sfaKey.privateKey}";
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
                      'Get Web3AuthKey',
                      style: TextStyle(fontSize: 12),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: _getKey(getKey),
                      child: const Text('Web3AuthKey'),
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

  VoidCallback _getKey(Future<SFAKey> Function() method) {
    return () async {
      try {
        final SFAKey response = await method();
        setState(() {
          _result =
              "Public Add : ${response.publicAddress} , Private Key : ${response.privateKey}";
          log(response.publicAddress);
        });
      } on MissingParamException catch (error) {
        log("Missing Param: ${error.paramName}");
      } on PrivateKeyNotGeneratedException {
        log("Private key not generated");
      } on UnKnownException {
        log("Unknown exception occurred");
      }
    };
  }

  Future<void> _initialize() async {
    try {
      final SFAKey? response =
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

  Future<SFAKey> getKey() {
    return _singleFactorAuthFlutterPlugin.connect(LoginParams(
        verifier: 'torus-test-health',
        verifierId: 'hello@tor.us',
        idToken: Utils().es256Token("hello@tor.us"),
    ));
  }
}
