import 'dart:convert';
import 'dart:io';

import 'package:encrypt/encrypt.dart';
import 'package:pointycastle/asymmetric/api.dart';
import 'package:http/http.dart';

import 'constants.dart';
import 'utility.dart';

class User {
  String usn;
  int uid; // User ID
  RSAPublicKey pubKey;

  static const baseURL = 'http://$hostname:$port/api';

  static postJsonRequest(String url, Map<String, dynamic> jsonMap) async {
    return await post(Uri.parse(url),
        body: jsonMap, headers: {"content-type": "application/json"});
  }

  User({String? usn, int? uid, RSAPublicKey? pubKey})
      : usn = usn ?? postJsonRequest('$baseURL/user/usn', {'uid': uid}),
        uid = uid ?? postJsonRequest('$baseURL/user/id', {'usn': usn}),
        pubKey =
            pubKey ?? postJsonRequest('$baseURL/user/pubKey', {'uid': uid});

  String get getUsn => usn;
  int get getUid => uid;
  RSAPublicKey get getPubKey => pubKey;
}

class LocalUser extends User {
  // Inherited: String usn
  String pwd;
  RSA keys;

  LocalUser({required super.usn, required this.pwd, required this.keys})
      : super(uid: null, pubKey: keys.publicKey);

  postRequest(String path, Map data) {
    var signer = 1;
  }

  String get getPwd => pwd;
  RSA get getKeys => keys;

  void auth() async {
    pubKey = keys.publicKey as RSAPublicKey;
    var data = {"usn": getUsn, "pwd": getPwd, "pubKey": getPubKey};
    //var pg = await ;
    //print(pg.body);
  }
}
