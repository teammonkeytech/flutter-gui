import 'dart:io' as io;

import 'package:basic_utils/basic_utils.dart'
    show CryptoUtils, RSAPublicKey, RSAPrivateKey;

import 'utility.dart';

abstract class User {
  String get username;
  int get uid;
  RSAPublicKey get pubKey;

  String encrypt(String ciphertext) {
    return CryptoUtils.rsaEncrypt(ciphertext, pubKey);
  }
}

class LocalUser extends User {
  @override
  final String username;
  @override
  late final int uid;

  final String baseURL;

  late final RSAPrivateKey key;
  @override
  late final RSAPublicKey pubKey;
  final String password;

  LocalUser(
      {required this.username, required this.password, required String url})
      : baseURL = '$url/api' {
    try {
      postJsonRequest('$baseURL/user/id', {'usn': username})
          .then((response) => uid = int.parse(response.body));
    } on FormatException catch (exception) {
      throw UnsupportedError("Invalid username: ${exception.message}");
    }

    var file = io.File('private_key.pem');
    file.exists().then((exists) {
      if (exists) {
        file
            .readAsString()
            .then((keyRepr) => key = CryptoUtils.rsaPrivateKeyFromPem(keyRepr));
        pubKey = RSAPublicKey(key.modulus!, key.publicExponent!);
      } else {
        final key_ = CryptoUtils.generateRSAKeyPair();
        key = key_.privateKey as RSAPrivateKey;
        pubKey = key_.publicKey as RSAPublicKey;
        file.writeAsString(CryptoUtils.encodeRSAPrivateKeyToPem(key));
      }
    });
  }

  void authenticate() {
    print(postJsonRequest('$baseURL/user/auth', {
      'usn': username,
      'pwd': password,
      'pubKey': CryptoUtils.encodeRSAPublicKeyToPem(pubKey)
    }));
  }

  String decrypt(String ciphertext) {
    return CryptoUtils.rsaDecrypt(ciphertext, key);
  }
}

class NonLocalUser extends User {
  late String? _username;
  @override
  late final int uid;
  @override
  late final RSAPublicKey pubKey;
  final String baseURL;

  // Get username as required
  @override
  String get username {
    if (_username == null) {
      postJsonRequest('$baseURL/user/usn', {'uid': uid})
          .then((response) => _username = response.body);
      return _username!;
    } else {
      return _username!;
    }
  }

  NonLocalUser.usn({required username, required url})
      : baseURL = '$url/api',
        _username = username {
    postJsonRequest('$baseURL/user/id', {'usn': username})
        .then((response) => uid = int.parse(response.body));
    postJsonRequest('$baseURL/user/pubKey', {'uid': uid}).then(
        (response) => pubKey = CryptoUtils.rsaPublicKeyFromPem(response.body));
  }

  NonLocalUser.uid({required this.uid, required url}) : baseURL = '$url/api' {
    postJsonRequest('$baseURL/user/pubKey', {'uid': uid}).then(
        (response) => pubKey = CryptoUtils.rsaPublicKeyFromPem(response.body));
  }
}
