import 'package:http/http.dart' show Response;
import 'package:cryptography/cryptography.dart';
import 'package:rsa_pkcs/rsa_pkcs.dart';
import 'dart:convert';

//import 'package:pointycastle';

import 'constants.dart';
import 'utility.dart';

class LocalUser extends User {
  static const baseURL = 'http://$hostname:$port/api';
  // Inherited: String usn
  String pwd;
  var signer = RsaSsaPkcs1v15.sha256();

  RsaKeyPair keys;

  LocalUser({required String usn, required this.pwd, required this.keys})
      : super(usn: usn, uid: null, pubKey: keys.extractPublicKey());

  RsaKeyPair get getKeys => keys;
  String get getPwd => pwd;

  void auth() async {
    // login/authenticate
    pubKey = keys.extractPublicKey();
    var pg = await postJsonRequest('$baseURL/user/auth',
        {"usn": await getUsn, "pwd": getPwd, "pubKey": getPubKey});
    print(pg.body);
  }

  Future<Response> postRequest(String path, Map<String, dynamic> data) async {
    // TODO: Write function
    var signer = RsaSsaPkcs1v15.sha256();
    var signature = await signer.signString(json.encode(data),
        keyPair: await keys.extract());
    //return Future<Response>.value(Response('h', 200));
    return postJsonRequest('$protocol://$hostname:$port/$path',
        {'uid': getUid, 'apiSig': base64.encode(signature.bytes)});
  }

  Future<String> sign(String content) async {
    var encoded = utf8.encode(content);
    var algorithm = Sha256();
    var hash = await algorithm.hash(encoded);
    return base64.encode(hash.bytes);
  }
}

class User {
  static const baseURL = 'http://$hostname:$port/api';
  Future<String> usn;
  Future<int> uid; // User ID

  Future<RsaPublicKey> pubKey;

  User({String? usn, int? uid, Future<RsaPublicKey>? pubKey})
      : usn = usn != null
            ? Future<String>.value(usn)
            : postJsonRequest('$baseURL/user/usn', {'uid': uid})
                .then((response) => response.body),
        uid = uid != null
            ? Future<int>.value(uid)
            : postJsonRequest('$baseURL/user/id', {'usn': usn})
                .then((response) => int.parse(response.body)),
        pubKey = pubKey ??
            postJsonRequest('$baseURL/user/pubKey', {'uid': uid})
                .then((response) => response.body as RsaPublicKey);

  Future<RsaPublicKey> get getPubKey => pubKey;
  Future<int> get getUid => uid;
  Future<String> get getUsn => usn;
}
