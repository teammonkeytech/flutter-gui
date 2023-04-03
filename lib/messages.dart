import 'dart:convert' show json;

import 'package:mutex/mutex.dart';

import 'bubble.dart';
import 'user.dart';
import 'utility.dart';

class Messages {
  final LocalUser user;
  final Bubble bubble;
  final String baseURL;

  final mutex = Mutex();

  List<List<String>> messages = [];

  Future<void> init() async {}

  Messages({required this.user, required this.bubble, required url})
      : baseURL = '$url/api';

  Future<void> retrieve() async {
    await mutex.protect(() async {
      messages = [];
      final List<dynamic> messages_;
      NonLocalUser nonLocalUser;
      var response = await postJsonRequest('$baseURL/bubble/messageRequest',
          {'uid': await user.uid, 'bid': bubble.bid});
      messages_ = json.decode(response.body);
      print("Retrieved ${messages_.length} messages");
      for (final message in messages_) {
        if (message["recipientUID"] == await user.uid) {
          nonLocalUser = NonLocalUser.uid(
              uid: message['authUID'],
              url: baseURL.substring(0, baseURL.length - '/api'.length));
          await nonLocalUser.initUid();
          messages.add(
              [await nonLocalUser.username, user.decrypt(message['content'])]);
        }
      }
      print("Processed ${messages.length} messages");
      print(messages);
      print(messages_.length);
    });
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
