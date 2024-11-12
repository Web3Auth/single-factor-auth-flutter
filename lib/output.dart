import 'dart:convert';

SFAKey sfaKeyFromJson(String string) => SFAKey.fromJson(
      jsonDecode(string),
    );

class SFAKey {
  final String privateKey;
  final String publicAddress;
  String? error;

  SFAKey({required this.privateKey, required this.publicAddress, this.error});

  factory SFAKey.fromJson(Map<String, dynamic> json) {
    return SFAKey(
      error: json['error'] ?? null,
      privateKey: json['privateKey'] ?? "",
      publicAddress: json['publicAddress'] ?? "",
    );
  }
}
