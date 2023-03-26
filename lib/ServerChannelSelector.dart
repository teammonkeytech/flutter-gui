import 'package:flutter/material.dart';
import 'package:gui_flutter/GlobalAppState.dart';
import 'package:provider/provider.dart';

class ServerChannelSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<GlobalAppState>();

    return Center(
      child: Column(children: [
        SizedBox(height: 10),
        Text("Server URL"),
        TextFormField(
          initialValue: appState.serverAddress,
          onChanged: (str) => appState.setServerAddress = str,
        ),
        SizedBox(height: 20),
        Text("Channel Name"),
        TextFormField(
          initialValue: appState.channel,
          onChanged: (str) => appState.setChannel = str,
        )
      ]),
    );
  }
}
