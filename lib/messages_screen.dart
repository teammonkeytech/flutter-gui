import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gui_flutter/global_app_state.dart';

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
                    var appState = context.watch<GlobalAppState>();
                    print("building");
                    List<String>? message =
                        appState.messages?.getMessage(index);
                    if (message == null) return null;
                    return Row(
                      children: [
                        const Icon(Icons.keyboard_arrow_right),
                        Expanded(
                            child: Column(children: [
                          Text(
                            message[0],
                            selectionColor: const Color(0xFFFF0000),
                          ),
                          Text(message[1]),
                        ]))
                      ],
                    );
                  })),
          SafeArea(
              child: Row(children: [
            IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () => appState.fetchMessages()),
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
                appState.messages?.sendMessage(controller.text);
                print(controller.text);
                controller.clear();
              },
            )
          ]))
        ]));
  }
}
