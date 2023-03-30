import 'dart:io';

import 'package:encrypt/encrypt.dart';
import 'package:pointycastle/asymmetric/api.dart';
import 'package:http/http.dart';

import 'constants.dart';

class User {
  late String usn;
  late int uid;
  late RSAPublicKey pubKey;

  var client = Client();

  static const uri_base = "http://$hostname:$port/api/user/";

  User(String? usn, int? uid, RSAPublicKey? pubKey) {
    this.usn = usn ??
        client.post(Uri.parse("${uri_base}uid"), body: {"uid": uid}).toString();
    try {
      this.uid = uid ??
          int.parse(client.post(Uri.parse("${uri_base}usn"),
              body: {"usn": usn}).toString());
    } on FormatException {
      throw HttpException("Server returned non-integer for UID");
    }
    var r = RSAKeyParser();
    this.pubKey = pubKey ??
        r.parse(client.post(Uri.parse("${uri_base}usn"),
            body: {"uid": uid}).toString()) as RSAPublicKey;
  }

  get getUsn => usn;
  get getUid => uid;
  get getPubKey => pubKey;
}

class LocalUser extends User {
  String usn;
  String pwd;
  RSA keys;

  LocalUser({required this.usn, required this.pwd, required this.keys})
      : super(usn, null, keys.publicKey);

  postRequest(String path, Map data) {
    var signer = 1;
  }

  get getPwd => pwd;
  get getKeys => keys;

  void auth() async {
    pubKey = keys.publicKey as RSAPublicKey;
    var data = {"usn": getUsn, "pwd": getPwd, "pubKey": getPubKey};
    var pg = await client.post(Uri.parse("${User.uri_base}auth"), body: data);
    print(pg.body);
  }
}
