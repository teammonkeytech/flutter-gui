import 'package:encrypt/encrypt.dart';
import 'package:pointycastle/asymmetric/api.dart';

import 'constants.dart';
import 'utility.dart';

class User {
  Future<String> usn;
  Future<int> uid; // User ID
  Future<RSAPublicKey> pubKey;

  static const baseURL = 'http://$hostname:$port/api';

  User({String? usn, int? uid, RSAPublicKey? pubKey})
      : usn = usn != null
            ? Future<String>.value(usn)
            : postJsonRequest('$baseURL/user/usn', {'uid': uid})
                .then((response) => response.body),
        uid = uid != null
            ? Future<int>.value(uid)
            : postJsonRequest('$baseURL/user/id', {'usn': usn})
                .then((response) => int.parse(response.body)),
        pubKey = pubKey != null
            ? Future<RSAPublicKey>.value(pubKey)
            : postJsonRequest('$baseURL/user/pubKey', {'uid': uid})
                .then((response) => response.body as RSAPublicKey);

  Future<String> get getUsn => usn;
  Future<int> get getUid => uid;
  Future<RSAPublicKey> get getPubKey => pubKey;
}

class LocalUser extends User {
  // Inherited: String usn
  String pwd;
  RSA keys;

  static const baseURL = 'http://$hostname:$port/api';

  LocalUser({required String usn, required this.pwd, required this.keys})
      : super(usn: usn, uid: null, pubKey: keys.publicKey);

  postRequest(String path, Map data) {
    return;
  }

  String get getPwd => pwd;
  RSA get getKeys => keys;

  void auth() async {
    pubKey = Future<RSAPublicKey>.value(keys.publicKey);
    var pg = await postJsonRequest('$baseURL/user/auth',
        {"usn": await getUsn, "pwd": getPwd, "pubKey": getPubKey});
    print(pg.body);
  }
}
