import 'package:encrypt/encrypt.dart';
import 'package:http/http.dart';
import 'package:pointycastle/asymmetric/api.dart';

//import 'package:pointycastle';

import 'constants.dart';
import 'utility.dart';

class LocalUser extends User {
  static const baseURL = 'http://$hostname:$port/api';
  // Inherited: String usn
  String pwd;

  RSA keys;

  LocalUser({required String usn, required this.pwd, required this.keys})
      : super(usn: usn, uid: null, pubKey: keys.publicKey);

  RSA get getKeys => keys;
  String get getPwd => pwd;

  void auth() async {
    pubKey = Future<RSAPublicKey>.value(keys.publicKey);
    var pg = await postJsonRequest('$baseURL/user/auth',
        {"usn": await getUsn, "pwd": getPwd, "pubKey": getPubKey});
    print(pg.body);
  }

  Future<Response> postRequest(String path, Map<String, dynamic> data) async {
    // TODO: Write function
    return Future<Response>.value(Response('h', 200));
  }
}

class User {
  static const baseURL = 'http://$hostname:$port/api';
  Future<String> usn;
  Future<int> uid; // User ID

  Future<RSAPublicKey> pubKey;

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

  Future<RSAPublicKey> get getPubKey => pubKey;
  Future<int> get getUid => uid;
  Future<String> get getUsn => usn;
}
