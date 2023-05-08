import 'package:encrypt/encrypt.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {
  final plainText = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit';
  final Key key = Key.fromUtf8('my 32 length key................');
  final IV iv = IV.fromLength(16);

  final encrypter = Encrypter(AES(key));

  final encrypted = encrypter.encrypt(plainText, iv: iv);
  final decrypted = encrypter.decrypt(encrypted, iv: iv);
  print(key.bytes);
  print(iv.bytes);

  print(decrypted);
  print(encrypted.base64);
}
