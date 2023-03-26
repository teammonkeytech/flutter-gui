import 'package:flutter/material.dart';
import 'package:gui_flutter/GlobalAppState.dart';
import 'package:provider/provider.dart';

class ServerChannelSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<GlobalAppState>();

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Center(
        child: Form(
          child: Column(children: [
            SizedBox(height: 10),
            Text("Server URL"),
            TextFormField(
              initialValue: appState.serverAddress,
              onChanged: (str) => appState.setServerAddress = str,
              validator: (str) =>
                  GlobalAppState.validateAddress(str) ? null : "Invalid URL",
            ),
            SizedBox(height: 20),
            Text("Channel Name"),
            TextFormField(
              initialValue: appState.channel,
              onChanged: (str) => appState.setChannel = str,
              validator: (str) => GlobalAppState.validateChannel(str)
                  ? null
                  : "Invalid channel",
            )
          ]),
        ),
      ),
    );
  }
}
