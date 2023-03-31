import 'package:cryptography/cryptography.dart';
import 'package:gui_flutter/utility.dart';
import 'dart:convert';

import 'user.dart';
import 'bubble.dart';
import 'constants.dart';

class Message {
  LocalUser author;
  Bubble bubble;
  String content;
  var signature;

  static const baseURL = 'http://$hostname:$port/api';

  Message({required this.author, required this.bubble, required this.content});

  void commit() async {
    var uids = await bubble.getUids;
    User recipient;
    var content_ = utf8.encode(content);
    AesCbc cipher = AesCbc.with256bits(macAlgorithm: MacAlgorithm.empty);
    SecretBox enciphered;
    for (int i = 0; i < uids.length; ++i) {
      recipient = User(uid: uids[i]);
      enciphered = await cipher.encrypt(content_,
          secretKey: await cipher.newSecretKey());
      postJsonRequest('$baseURL/msg/commit', {
        'authUID': author.getUid,
        'recipientUID': uids[i],
        'bid': bubble.getBid,
        'content': base64.encode(enciphered.cipherText),
        'sig':
            signature // TODO: confirm type of signature (perhaps by completing bubble.dart)
      });
    }
  }
}
