import 'package:flutter/material.dart';
import 'package:gui_flutter/global_app_state.dart';
import 'package:provider/provider.dart';

class SelectorScreen extends StatefulWidget {
  @override
  State<SelectorScreen> createState() => _SelectorScreenState();
}

class _SelectorScreenState extends State<SelectorScreen> {
  List<bool> isSelected = [false, true];
  final serverAddress = TextEditingController(text: "http://127.0.0.1:5000"),
      channel = TextEditingController(text: '1'),
      username = TextEditingController(text: "test"),
      password = TextEditingController(text: "test");

  /* @override
  void initState() {
    super.initState();
    // We first set empty text form fields, then we can go back and put in
    // default values once the widget has loaded
    // The following function has access to the build context
    Future.delayed(Duration.zero, () {
      var appState = context.watch<GlobalAppState>();
      serverAddress.text = appState.serverAddress;
      channel.text = appState.channel;
    });
  } */

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<GlobalAppState>();
    final formKey = GlobalKey<FormState>();

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: SingleChildScrollView(
        child: Center(
          child: Form(
            key: formKey,
            child: Column(children: [
              _FormField(
                appState: appState,
                formText: "Server URL",
                formErrorText: "Invalid URL",
                validator: GlobalAppState.validateAddress,
                controller: serverAddress,
              ),
              _FormField(
                appState: appState,
                formText: "Channel ID",
                formErrorText: "Invalid Channel ID",
                validator: (text) =>
                    isSelected[0] || GlobalAppState.validateChannel(text),
                controller: channel,
              ),
              ToggleButtons(
                isSelected: isSelected,
                onPressed: (int index) => setState(() {
                  for (int i = 0; i < isSelected.length; i++) {
                    if (i == index) {
                      isSelected[i] = true;
                    } else {
                      isSelected[i] = false;
                    }
                  }
                }),
                children: const [
                  Padding(
                      padding: EdgeInsets.all(5.0), child: Text("New Channel")),
                  Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Text("Existing Channel")),
                ],
              ),
              _FormField(
                appState: appState,
                formText: "Username",
                controller: username,
              ),
              _FormField(
                appState: appState,
                formText: "Password",
                controller: password,
              ),
              ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      appState.connectToServer(
                          username: username.text,
                          password: password.text,
                          bid: channel.text,
                          url: serverAddress.text);

                      /* serverAddress.dispose();
                      channel.dispose();
                      username.dispose();
                      password.dispose(); */
                    }
                  },
                  child: const Text("Connect"))
            ]),
          ),
        ),
      ),
    );
  }
}

class _FormField extends StatelessWidget {
  const _FormField({
    //super.key,
    required this.appState,
    required this.formText,
    this.formErrorText,
    this.validator,
    required this.controller,
  });

  final GlobalAppState appState;
  final String formText;
  final String? formErrorText;
  final bool Function(String?)? validator;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const SizedBox(height: 10),
      Text(formText),
      TextFormField(
        controller: controller,
        validator: validator == null
            ? null
            : (str) => validator!(str) ? null : formErrorText,
        autovalidateMode: AutovalidateMode.disabled,
      ),
      const SizedBox(height: 10),
    ]);
  }
}
