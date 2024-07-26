import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class EncryptionService {
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  final _key = utf8.encode('my32lengthsupersecretnooneknows1'); // 32 bytes key

  // Method to encrypt data using AES
  Future<String> encryptData(String data) async {
    final key = sha256.convert(_key).bytes;
    final iv = IV.fromLength(16); // Initialization vector
    final encrypter = Encrypter(AES(Key(Uint8List.fromList(key))));
    final encrypted = encrypter.encrypt(data, iv: iv);

    return encrypted.base64;
  }

  // Method to decrypt data using AES
  Future<String> decryptData(String encryptedData) async {
    final key = sha256.convert(_key).bytes;
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(Key(Uint8List.fromList(key))));
    final decrypted = encrypter.decrypt(Encrypted.fromBase64(encryptedData), iv: iv);

    return decrypted;
  }
}