import 'dart:html';
import 'dart:js_util';

import 'package:flutter/material.dart';

class GlobalAppState extends ChangeNotifier {
  String? _serverAddress;
  String? _channel;

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
    return channel != null;
  }
}
