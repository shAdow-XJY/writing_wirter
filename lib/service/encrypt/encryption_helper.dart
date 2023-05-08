import 'dart:convert';
import 'package:encrypt/encrypt.dart';

const String keyStr = "6HVeIB+EvAg5VaviRUiXZQKqwsr3Rv7m6DCL80dEqDk=";
const String ivStr = "Ik8bBgyBwgMC341LXQWooQ==";
// 创建 Key 和 IV 实例
final Key key = Key(base64.decode(keyStr));
final IV iv = IV(base64.decode(ivStr));

class EncryptionHelper {

  static Encrypter encryptionHelper = Encrypter(AES(key));

  static String getEncryptedString(String decryptedStr) {
    final encrypted = encryptionHelper.encrypt(decryptedStr, iv: iv);
    return encrypted.base64;
  }

  static String getDecryptedString(String encryptedStr) {
    final encrypted = Encrypted.fromBase64(encryptedStr);
    return encryptionHelper.decrypt(encrypted, iv: iv);
  }
}