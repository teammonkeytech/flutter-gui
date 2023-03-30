import 'package:flutter/material.dart';

class MessagesScreen extends StatelessWidget {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(children: [
          Expanded(
              child: ListView.builder(
                  reverse: true,
                  // TODO: retrieve messages lazily
                  itemBuilder: (context, index) => index <= 1
                      ? Text("A")
                      : index < 10
                          ? Text("B")
                          : null)),
          SafeArea(
              child: Row(children: [
            Expanded(
                child: TextField(
                    controller: controller,
                    onSubmitted: (value) {
                      // TODO: submit text in `controller`
                      print(controller.text);
                      controller.clear();
                    })),
            IconButton(
              icon: Icon(Icons.arrow_circle_up),
              onPressed: () {
                // TODO: submit text in `controller`
                print(controller.text);
                controller.clear();
              },
            )
          ]))
        ]));
  }
}
