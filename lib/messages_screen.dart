import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'global_app_state.dart';
import 'messages.dart';

class MessagesScreen extends StatelessWidget {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<GlobalAppState>();

    return Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(children: [
          Expanded(
              child: ListView.builder(
                  reverse: true,
                  itemBuilder: (context, index) {
                    print("Building items");
                    //var appState = context.watch<GlobalAppState>();
                    Messages? messages = appState.messages;
                    List<String>? message = messages?.getMessage(index);
                    if (message == null) return null;
                    return Container(
                      margin: const EdgeInsets.all(1.0),
                      padding: const EdgeInsets.all(2.0),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.blueAccent)),
                      child: Row(
                        children: [
                          const Icon(Icons.keyboard_arrow_right),
                          Expanded(
                              child: Column(children: [
                            Text(
                              '$index; ${message[0]}',
                              selectionColor: const Color(0xFFFF0000),
                            ),
                            Text(message[1]),
                          ]))
                        ],
                      ),
                    );
                  })),
          SafeArea(
              child: Row(children: [
            IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  print("Refresh requested");
                  appState.fetchMessages();
                }),
            Expanded(
                child: TextField(
                    controller: controller,
                    onSubmitted: (value) {
                      appState.messages?.sendMessage(controller.text);
                      print(controller.text);
                      controller.clear();
                    })),
            IconButton(
              icon: const Icon(Icons.arrow_circle_up),
              onPressed: () {
                print(appState.messages == null);
                print(appState.messages?.bubble.uids);
                appState.messages?.sendMessage(controller.text);
                print(controller.text);
                controller.clear();
              },
            )
          ]))
        ]));
  }
}
