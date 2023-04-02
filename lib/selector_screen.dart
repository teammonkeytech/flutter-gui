import 'package:flutter/material.dart';
import 'package:gui_flutter/global_app_state.dart';
import 'package:provider/provider.dart';

class SelectorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<GlobalAppState>();

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Center(
        child: Form(
          child: Column(children: [
            _FormField(
              appState: appState,
              formText: "Server URL",
              formErrorText: "Invalid URL",
              validator: GlobalAppState.validateAddress,
            ),
            _FormField(
                appState: appState,
                formText: "Channel ID",
                formErrorText: "Invalid ID",
                validator: GlobalAppState.validateChannel),
            _FormField(
                appState: appState,
                formText: "Username",
                formErrorText: "",
                validator: (_) => true),
            _FormField(
                appState: appState,
                formText: "Password",
                formErrorText: "",
                validator: (_) => true),
            ElevatedButton(onPressed: () {}, child: const Text("Connect"))
          ]),
        ),
      ),
    );
  }
}

class _FormField extends StatelessWidget {
  const _FormField({
    super.key,
    required this.appState,
    required this.formText,
    required this.formErrorText,
    required this.validator,
  });

  final GlobalAppState appState;
  final String formText;
  final String formErrorText;
  final bool Function(String?) validator;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const SizedBox(height: 10),
      Text(formText),
      TextFormField(
        initialValue: appState.serverAddress,
        validator: (str) => validator(str) ? null : formErrorText,
        autovalidateMode: AutovalidateMode.disabled,
      ),
      const SizedBox(height: 10),
    ]);
  }
}
