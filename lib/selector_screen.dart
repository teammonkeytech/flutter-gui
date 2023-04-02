import 'package:flutter/material.dart';
import 'package:gui_flutter/global_app_state.dart';
import 'package:provider/provider.dart';

class SelectorScreen extends StatefulWidget {
  @override
  State<SelectorScreen> createState() => _SelectorScreenState();
}

class _SelectorScreenState extends State<SelectorScreen> {
  List<bool> isSelected = [false, true];
  // TODO: preinitialize serverAddress and channel with current values
  var serverAddress = TextEditingController(),
      channel = TextEditingController(),
      username = TextEditingController(),
      password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<GlobalAppState>();
    final formKey = GlobalKey<FormState>();

    return Padding(
      padding: const EdgeInsets.all(12.0),
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
              formErrorText: "Invalid ID",
              validator: GlobalAppState.validateChannel,
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
              formErrorText: "",
              validator: (_) => true,
              controller: username,
            ),
            _FormField(
              appState: appState,
              formText: "Password",
              formErrorText: "",
              validator: (_) => true,
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

                    serverAddress.dispose();
                    channel.dispose();
                    username.dispose();
                    password.dispose();
                  }
                },
                child: const Text("Connect"))
          ]),
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
    required this.formErrorText,
    required this.validator,
    required this.controller,
  });

  final GlobalAppState appState;
  final String formText;
  final String formErrorText;
  final bool Function(String?) validator;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const SizedBox(height: 10),
      Text(formText),
      TextFormField(
        controller: controller,
        validator: (str) => validator(str) ? null : formErrorText,
        autovalidateMode: AutovalidateMode.disabled,
      ),
      const SizedBox(height: 10),
    ]);
  }
}
