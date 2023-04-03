import 'dart:convert' show json;

import 'user.dart';
import 'utility.dart';

class Bubble {
  late final int bid; // Bubble ID
  List<int> uids = []; // User IDs
  final User? firstUser;

  final String baseURL;

  Future<void> initConnect() async {
    uids = await fetchUids();
  }

  Bubble.connect(this.bid, String url)
      : baseURL = '$url/api',
        firstUser = null;

  Future<void> initNewBubble() async {
    assert(firstUser != null,
        "Call the newBubble constructor before this function");
    var response = await postJsonRequest(
        '$baseURL/bubble/new', {'uid': await firstUser!.uid});
    print('New bubble: ${response.body}');
    bid = int.parse(response.body);
    uids = [await firstUser!.uid];
    await fetchUids();
  }

  Bubble.newBubble(User user, String url)
      : baseURL = '$url/api',
        firstUser = user;

  Future<List<int>> fetchUids() async {
    List<int> uids;
    try {
      var response =
          await postJsonRequest('$baseURL/bubble/uids', {"bid": bid});
      uids = json.decode(response.body).cast<int>();
      print("fetched uids: $uids");
      return uids;
    } on FormatException {
      throw RoomDoesNotExist();
    }
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
