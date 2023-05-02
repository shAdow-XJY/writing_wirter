import 'dart:convert';
import 'dart:typed_data';

import 'package:encrypt/encrypt.dart';


void main() {
  final plainText = '{"heihei": "aaa", "niu": "null"}';

  final Key key = Key.fromSecureRandom(32);
  final IV iv = IV.fromSecureRandom(16);

  final Uint8List keyBytes = key.bytes;
  final Uint8List ivBytes = iv.bytes;
  print(keyBytes);
  print(ivBytes);

  final String keyStr = base64.encode(keyBytes);
  final String ivStr = base64.encode(ivBytes);
  print(keyStr);
  print(ivStr);

  // 从保存的 keyStr 和 ivStr 中还原 keyBytes 和 ivBytes
  final Uint8List _keyBytes = base64.decode(keyStr);
  final Uint8List _ivBytes = base64.decode(ivStr);
  print(_keyBytes);
  print(_ivBytes);

  // 创建 Key 和 IV 实例
  final _key = Key(_keyBytes);
  final _iv = IV(_ivBytes);

  final encrypter = Encrypter(AES(_key));

  final encrypted = encrypter.encrypt(plainText, iv: _iv);
  final decrypted = encrypter.decrypt(encrypted, iv: _iv);

  print(decrypted);
  print(encrypted.base64);
}
