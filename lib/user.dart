import 'dart:io' as io;

import 'package:basic_utils/basic_utils.dart'
    show CryptoUtils, RSAPublicKey, RSAPrivateKey;
import 'package:http/http.dart' show Response;

import 'utility.dart' as util;

abstract class User {
  Future<String> get username;
  Future<int> get uid;
  RSAPublicKey get pubKey;

  String encrypt(String plaintext) {
    return util.encrypt(plaintext, pubKey);
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

  late RSAPrivateKey key;
  @override
  late RSAPublicKey pubKey;
  final String password;

  io.Directory localDir;

  LocalUser(
      {required String username,
      required this.password,
      required String url,
      required this.localDir})
      : _username = username,
        baseURL = '$url/api';

  Future<void> init() async {
    // We obtain the public/private key first
    var file = io.File('${localDir.path}/private_key.pem');
    // FIXME: I think browsers cannot technically read and store files in their
    // own private directories
    if (await file.exists()) {
      key = CryptoUtils.rsaPrivateKeyFromPem(await file.readAsString());
      pubKey = RSAPublicKey(key.modulus!, key.publicExponent!);
    } else {
      await file.create();
      final key_ = CryptoUtils.generateRSAKeyPair();
      key = key_.privateKey as RSAPrivateKey;
      pubKey = key_.publicKey as RSAPublicKey;
      await file.writeAsString(CryptoUtils.encodeRSAPrivateKeyToPem(key));
    }

    // Then authenticate with the server
    try {
      await authenticate();
      var response =
          await util.postJsonRequest('$baseURL/user/id', {'usn': _username});
      print(response.body);
      _uid = int.parse(response.body);
    } on FormatException catch (exception) {
      throw UnsupportedError("Invalid username: ${exception.message}");
    }
  }

  Future<void> authenticate() async {
    print((await util.postJsonRequest('$baseURL/user/auth', {
      'usn': _username,
      'pwd': password,
      'pubKey': CryptoUtils.encodeRSAPublicKeyToPem(pubKey)
    }))
        .body);
  }

  String decrypt(String ciphertext) {
    return util.decrypt(ciphertext, key);
  }

  @override
  String encrypt(String plaintext) {
    return util.encrypt(plaintext, pubKey);
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
          (await util.postJsonRequest('$baseURL/user/usn', {'uid': _uid})).body;
      return _username!;
    } else {
      return _username!;
    }
  }

  @override
  Future<int> get uid => Future<int>.value(_uid);

  Future<void> initUsn() async {
    Response response;
    response =
        await util.postJsonRequest('$baseURL/user/pubKey', {'uid': _uid});
    pubKey = CryptoUtils.rsaPublicKeyFromPem(response.body);
    response =
        await util.postJsonRequest('$baseURL/user/id', {'usn': username});
    _uid = int.parse(response.body);
  }

  NonLocalUser.usn({required username, required url})
      : baseURL = '$url/api',
        _username = username;

  Future<void> initUid() async {
    Response response =
        await util.postJsonRequest('$baseURL/user/pubKey', {'uid': _uid});
    pubKey = CryptoUtils.rsaPublicKeyFromPem(response.body);
  }

  NonLocalUser.uid({required int uid, required url})
      : _uid = uid,
        _username = null,
        baseURL = '$url/api';

  @override
  String encrypt(String plaintext) {
    return util.encrypt(plaintext, pubKey);
  }
}
