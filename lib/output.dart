import 'dart:convert';

SFAKey sfaKeyFromJson(String string) => SFAKey.fromJson(
      jsonDecode(string),
    );

class SFAKey {
  final String privateKey;
  final String publicAddress;

  SFAKey({required this.privateKey, required this.publicAddress});

  factory SFAKey.fromJson(Map<String, dynamic> json) {
    return SFAKey(
      privateKey: json['privateKey'],
      publicAddress: json['publicAddress'],
    );
  }
}
