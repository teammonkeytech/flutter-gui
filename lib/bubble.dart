import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'constants.dart';

class Bubble {
  int? bid;
  Map<String, dynamic> uids = {};

  Bubble({this.bid}) {
    if (bid != null) {
      connect();
    }
  }

  get getBid => bid;
  get getUids => uids.isEmpty ? connect() : uids;

  Future<Map<String, dynamic>> connect() async {
    var client = http.Client();
    var uri = Uri.parse("http://$hostname:$port/api/bubble/uids");
    var response = await client.post(uri, body: {"bid": bid.toString()});
    uids = convert.jsonDecode(response.body) as Map<String, dynamic>;
    return uids;
  }

  void invite(user) {}
}
