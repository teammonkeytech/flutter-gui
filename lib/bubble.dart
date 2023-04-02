import 'dart:convert' show json;

import 'user.dart';
import 'utility.dart';

class Bubble {
  late final int bid; // Bubble ID
  //var uids = Future<Map<String, dynamic>>.value({});
  late List<int> uids; // User IDs

  final String baseURL;

  Bubble.connect({required this.bid, required String url})
      : baseURL = '$url/api' {
    uids = fetchUids();
  }

  Bubble.new(String url, User user)
      : baseURL = '$url/api',
        uids = [user.uid] {
    postJsonRequest('$url/bubble/new', {'uid': user.uid})
        .then((response) => bid = int.parse(response.body));
  }

  List<int> fetchUids() {
    dynamic uids;
    try {
      postJsonRequest('$baseURL/bubble/uids', {"bid": bid}).then((response) {
        var response_ = json.decode(response.body);
        assert(response_ is List<int>,
            "bubble uids requested is not list of ints");
        uids = response;
        return uids;
      });
    } on FormatException {
      throw RoomDoesNotExist();
    }
    return uids;
  }

  void invite(LocalUser user) {
    postJsonRequest('$baseURL/bubble/invite', {'bid': bid, 'uid': user.uid})
        .then((response) {
      if (response.body == "Bubble $bid not found") {
        throw RoomDoesNotExist();
      }
    });
  }
}

class RoomDoesNotExist implements Exception {}
