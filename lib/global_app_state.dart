import 'package:flutter/material.dart';
import 'package:gui_flutter/bubble.dart';
import 'package:gui_flutter/messages.dart';
import 'package:gui_flutter/user.dart';

class GlobalAppState extends ChangeNotifier {
  String? _serverAddress;
  String? _channel;

  LocalUser? user;
  Messages? messages;

  void connectToServer(
      {required String username,
      required String password,
      required String bid,
      required String url,
      bool newChannel = false}) {
    user = LocalUser(username: username, password: password, url: url);
    messages = Messages(user: user!, bubble: Bubble(url, user!), url: url);
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
    return address != null && address != "" && address != "Hello";
  }

  static bool validateChannel(String? channel) {
    if (channel == null) return false;
    return int.tryParse(channel) != null;
  }
}
