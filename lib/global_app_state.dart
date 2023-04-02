import 'dart:io' show Directory;

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart'
    show getApplicationDocumentsDirectory;

import 'bubble.dart';
import 'messages.dart';
import 'user.dart';

class GlobalAppState extends ChangeNotifier {
  String? _serverAddress;
  String? _channel;

  LocalUser? user;
  Messages? messages;

  late Directory localDir;

  void connectToServer(
      {required String username,
      required String password,
      required String bid,
      required String url,
      bool newChannel = false}) async {
    localDir = await getApplicationDocumentsDirectory();

    user = LocalUser(
        username: username, password: password, url: url, localDir: localDir)
      ..init();
    messages = Messages(
        user: user!,
        // If a new channel was requested, ask server for a new channel.
        // Otherwise try connecting to an old channel.
        bubble: newChannel
            ? (Bubble.newBubble(user!, url)..initNewBubble())
            : (Bubble.connect(int.parse(bid), url)..initConnect()),
        url: url)
      ..init();
    messages?.retrieve();
    notifyListeners();
  }

  void fetchMessages() {
    messages?.retrieve();
    notifyListeners();
  }

  bool get isServerAddressSet => !(_serverAddress == null);
  bool get isChannelSet => !(_channel == null);

  String get serverAddress => _serverAddress ?? "";
  String get channel => _channel ?? "";

  set setServerAddress(String address) {
    if (validateAddress(address)) {
      _serverAddress = address;
      notifyListeners();
    }
  }

  set setChannel(String channel) {
    if (validateChannel(channel)) {
      _channel = channel;
      notifyListeners();
    }
  }

  static bool validateAddress(String? address) {
    // TODO: Validate address format
    if (address == null) return false;

    var uri = Uri.tryParse(address);
    if (uri == null) return false;

    return uri.isScheme('HTTP');
  }

  static bool validateChannel(String? channel) {
    if (channel == null) return false;
    return int.tryParse(channel) != null;
  }
}
