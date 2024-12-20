import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:single_factor_auth_flutter/enums.dart';
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
  final _singleFactorAuthFlutterPlugin = SingleFactorAuthFlutter();
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
      getSessionData();
    } else if (Platform.isIOS) {
      await init();
      getSessionData();
    } else {}
  }

  Future<void> init() async {
    await _singleFactorAuthFlutterPlugin.init(Web3AuthOptions(
        network: web3AuthNetwork,
        clientId: 'YOUR_CLIENT_ID',
        sessionTime: 86400,
        redirectUrl: Uri.parse("com.torus")));
  }

  Future<void> getSessionData() async {
    log("getSessionData() called");
    final SessionData? sessionData =
        await _singleFactorAuthFlutterPlugin.getSessionData();
    if (sessionData?.publicAddress != null) {
      setState(() {
        _result = "Session Data: ${sessionData.toString()}";
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
                      'Get SFAKey',
                      style: TextStyle(fontSize: 12),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: _getKey(getKey),
                      child: const Text('Get SFAKey'),
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

  VoidCallback _getKey(Future<SessionData> Function() method) {
    return () async {
      try {
        final SessionData sessionData = await method();
        setState(() {
          _result = "Session Data: ${sessionData.toString()}";
          log("Full Session Data: ${sessionData.toString()}");
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
      final SessionData? sessionData =
          await _singleFactorAuthFlutterPlugin.getSessionData();

      setState(() {
        _result = "Session Data: ${sessionData.toString()}";
      });
    } on UnKnownException {
      log("Unknown exception occurred");
    } catch (e, stackTrace) {
      log("An unexpected error occurred: $e");
      log("Stack trace: $stackTrace");
    }
  }

  //Get key example
  Future<SessionData> getKey() {
    return _singleFactorAuthFlutterPlugin.connect(LoginParams(
      verifier: 'torus-test-health',
      verifierId: 'hello@tor.us',
      idToken: Utils().es256Token("hello@tor.us"),
    ));
  }

  //Aggregate verifier key example
  Future<SessionData> getAggregateKey() {
    return _singleFactorAuthFlutterPlugin.connect(LoginParams(
        verifier: 'torus-aggregate-sapphire-mainnet',
        verifierId: 'devnettestuser@tor.us',
        idToken: Utils().es256Token("devnettestuser@tor.us"),
        subVerifierInfoArray: [
          TorusSubVerifierInfo(
              'torus-test-health', Utils().es256Token("devnettestuser@tor.us"))
        ]));
  }

  //Logout example
  Future<void> logout() {
    return _singleFactorAuthFlutterPlugin.logout();
  }
}
