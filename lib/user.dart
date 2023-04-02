import 'dart:io' as io;

import 'package:basic_utils/basic_utils.dart'
    show CryptoUtils, RSAPublicKey, RSAPrivateKey;
import 'package:http/http.dart' show Response;

import 'utility.dart';

abstract class User {
  Future<String> get username;
  Future<int> get uid;
  RSAPublicKey get pubKey;

  String encrypt(String ciphertext) {
    return CryptoUtils.rsaEncrypt(ciphertext, pubKey);
  }
}

class LocalUser extends User {
  final String _username;
  int _uid = -1;

  @override
  Future<String> get username => Future<String>.value(_username);
  @override
  Future<int> get uid => Future<int>.value(_uid);

  final String baseURL;

  late final RSAPrivateKey key;
  @override
  late final RSAPublicKey pubKey;
  final String password;

  io.Directory localDir;

  LocalUser(
      {required String username,
      required this.password,
      required String url,
      required this.localDir})
      : _username = username,
        baseURL = '$url/api';

  void init() async {
    try {
      var response =
          await postJsonRequest('$baseURL/user/id', {'usn': _username});
      _uid = int.parse(response.body);
    } on FormatException catch (exception) {
      throw UnsupportedError("Invalid username: ${exception.message}");
    }

    var file = io.File('${localDir.toString()}/private_key.pem');
    // FIXME: I think browsers cannot technically read and store files
    if (await file.exists()) {
      key = CryptoUtils.rsaPrivateKeyFromPem(await file.readAsString());
      pubKey = RSAPublicKey(key.modulus!, key.publicExponent!);
    } else {
      final key_ = CryptoUtils.generateRSAKeyPair();
      key = key_.privateKey as RSAPrivateKey;
      pubKey = key_.publicKey as RSAPublicKey;
      await file.writeAsString(CryptoUtils.encodeRSAPrivateKeyToPem(key));
    }
  }

  void authenticate() async {
    print(await postJsonRequest('$baseURL/user/auth', {
      'usn': _username,
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
  late int _uid = -1;
  @override
  late final RSAPublicKey pubKey;
  final String baseURL;

  // Get username as required
  @override
  Future<String> get username async {
    if (_username == null) {
      _username =
          (await postJsonRequest('$baseURL/user/usn', {'uid': _uid})).body;
      return _username!;
    } else {
      return _username!;
    }
  }

  @override
  Future<int> get uid => Future<int>.value(_uid);

  void initUsn() async {
    Response response;
    response = await postJsonRequest('$baseURL/user/id', {'usn': username});
    _uid = int.parse(response.body);
    response = await postJsonRequest('$baseURL/user/pubKey', {'uid': _uid});
    pubKey = CryptoUtils.rsaPublicKeyFromPem(response.body);
  }

  NonLocalUser.usn({required username, required url})
      : baseURL = '$url/api',
        _username = username;

  void initUid() async {
    Response response =
        await postJsonRequest('$baseURL/user/pubKey', {'uid': _uid});
    pubKey = CryptoUtils.rsaPublicKeyFromPem(response.body);
  }

  NonLocalUser.uid({required int uid, required url})
      : _uid = uid,
        baseURL = '$url/api';
}
