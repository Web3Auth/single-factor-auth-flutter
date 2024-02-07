import 'dart:convert';

TorusKey torusKeyFromJson(String string) => TorusKey.fromJson(
      jsonDecode(string),
    );

class TorusKey {
  final String privateKey;
  final String publicAddress;

  TorusKey({required this.privateKey, required this.publicAddress});

  factory TorusKey.fromJson(Map<String, dynamic> json) {
    return TorusKey(
      privateKey: json['privateKey'],
      publicAddress: json['publicAddress'],
    );
  }
}
