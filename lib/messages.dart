import 'dart:convert' show json;

import 'bubble.dart';
import 'user.dart';
import 'utility.dart';

class Messages {
  final LocalUser user;
  final Bubble bubble;
  final String baseURL;

  List<List<String>> messages = [];

  Future<void> init() async {}

  Messages({required this.user, required this.bubble, required url})
      : baseURL = '$url/api';

  Future<void> retrieve() async {
    print("retrieving");
    dynamic messages_;
    NonLocalUser nonLocalUser;
    var response = await postJsonRequest('$baseURL/bubble/messageRequest',
        {'uid': await user.uid, 'bid': bubble.bid});
    messages_ = json.decode(response.body);
    for (var message in messages_) {
      print(
          'recipient uid: ${message["recipientUID"]}, ${message["recipientUID"].runtimeType}');
      print("user.uid: ${user.uid}");
      if (message["recipientUID"] == await user.uid) {
        print("message: $message");
        nonLocalUser = NonLocalUser.uid(
            uid: message['authUID'],
            url: baseURL.substring(0, baseURL.length - '/api'.length));
        await nonLocalUser.initUid();
        messages.add(
            [await nonLocalUser.username, user.decrypt(message['content'])]);
      }
    }
  }

  void sendMessage(String message) async {
    NonLocalUser recipient;
    await bubble.fetchUids();
    for (final uid in bubble.uids) {
      recipient = NonLocalUser.uid(
          uid: uid, url: baseURL.substring(0, baseURL.length - '/api'.length));
      await recipient.initUid();
      postJsonRequest('$baseURL/msg/commit', {
        'authUID': await user.uid,
        'recipientUID': await recipient.uid,
        'bid': bubble.bid,
        'content': recipient.encrypt(message),
        'sig': '\u0000',
      });
    }
    await retrieve();
  }

  List<String>? getMessage(int index) {
    if (index >= messages.length) {
      retrieve();
      return index >= messages.length ? null : messages[index];
    }
    return messages[index];
  }
}
