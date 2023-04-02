import 'dart:convert' show json;

import 'bubble.dart';
import 'user.dart';
import 'utility.dart';

class Messages {
  final LocalUser user;
  final Bubble bubble;
  final String baseURL;

  List<List<String>> messages = [];

  void init() {}

  Messages({required this.user, required this.bubble, required url})
      : baseURL = '$url/api';

  void retrieve() async {
    dynamic messages_;
    var response = await postJsonRequest('$baseURL/bubble/messageRequest',
        {'uid': await user.uid, 'bid': bubble.bid});
    messages_ = json.decode(response.body);
    for (var message in messages_) {
      if (message["recipientUID"] == user.uid) {
        messages.add([
          await NonLocalUser.uid(
                  uid: message['authUID'],
                  url: baseURL.substring(0, baseURL.length - '/api'.length))
              .username,
          user.decrypt(message['content'])
        ]);
      }
    }
  }

  void sendMessage(String message) async {
    User recipient;
    for (final uid in bubble.uids) {
      recipient = NonLocalUser.uid(
          uid: uid, url: baseURL.substring(0, baseURL.length - '/api'.length));
      postJsonRequest('$baseURL/msg/commit', {
        'authUID': user.uid,
        'recipientUID': recipient.uid,
        'bid': bubble.bid,
        'content': recipient.encrypt(message),
        'sig': '\u0000',
      });
    }
  }

  List<String>? getMessage(int index) {
    if (index >= messages.length) {
      retrieve();
      return index >= messages.length ? null : messages[index];
    }
    return messages[index];
  }
}
