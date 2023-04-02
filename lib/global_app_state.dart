import 'package:flutter/material.dart';
import 'package:gui_flutter/messages.dart';
import 'package:gui_flutter/user.dart';

class GlobalAppState extends ChangeNotifier {
  String? _serverAddress;
  String? _channel;

  late LocalUser user;
  late Messages messages;

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
    // TODO: Validate channel format
    return channel != null && channel != "";
  }
}
