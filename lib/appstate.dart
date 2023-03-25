import 'dart:html';
import 'dart:js_util';

import 'package:flutter/material.dart';

class GlobalAppState extends ChangeNotifier {
  String? _serverAddress;
  String? _channel;

  bool get isServerAddressSet => !(_serverAddress == null);
  bool get isChannelSet => !(_channel == null);

  String? get serverAddress => _serverAddress;
  String? get channel => _channel;

  bool setServerAddress(String address) {
    if (!_validateAddress(address)) {
      return false;
    } else {
      _serverAddress = address;
      return true;
    }
  }

  bool setChannel(String channel) {
    if (!_validateChannel(channel)) {
      return false;
    } else {
      _channel = channel;
      return true;
    }
  }

  bool _validateAddress(String? address) {
    // TODO: Validate address format
    return address != null && address != "";
  }

  bool _validateChannel(String? channel) {
    // TODO: Validate channel format
    return channel != null;
  }
}
