import 'dart:convert';

import 'constants.dart';
import 'utility.dart';
import 'user.dart';

class Bubble {
  int? bid; // Bubble ID
  var uids = Future<Map<String, dynamic>>.value({});

  static const baseURL = 'http://$hostname:$port/api';

  Bubble({this.bid}) {
    if (bid != null) {
      connect();
    }
  }

  int? get getBid => bid;
  Future<Map<String, dynamic>> get getUids async =>
      (await uids).isEmpty ? connect() : uids;

  Future<Map<String, dynamic>> connect() async {
    uids = postJsonRequest('$baseURL/bubble/uids', {"bid": bid})
        .then((response) => json.decode(response.body));
    return await uids;
  }

  Future<void> invite(User user) async {
    var status = postJsonRequest(
        '$baseURL/bubble/invite', {'bid': getBid, 'uid': user.getUid});
    print((await status).body);
  }

  void newBubble(User user) async {
    bid = int.parse(
        (await postJsonRequest('$baseURL/bubble/new', {'uid': user.getUid}))
            .body);
  }

  msgRequest(LocalUser localUser) {}
}
