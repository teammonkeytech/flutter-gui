import 'package:flutter/material.dart';
import 'package:gui_flutter/GlobalAppState.dart';
import 'package:provider/provider.dart';

import 'ServerChannelSelector.dart';
import 'MessagesScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GlobalAppState(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.dark(),
        ),
        home: const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    Widget page;
    switch (selectedIndex) {
      case 0:
        page = ServerChannelSelector();
        break;
      case 1:
        page = MessagesScreen();
        break;
      default:
        throw UnimplementedError("No widget for $selectedIndex");
    }

    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
          body: Row(
        children: [
          SafeArea(
              child: NavigationRail(
                  extended: constraints.maxWidth >= 600,
                  selectedIndex: selectedIndex,
                  onDestinationSelected: (value) {
                    setState(() => selectedIndex = value);
                  },
                  destinations: [
                NavigationRailDestination(
                  icon: const Icon(Icons.attach_file),
                  label: const Text('Server/Channel'),
                ),
                NavigationRailDestination(
                  icon: const Icon(Icons.article),
                  label: const Text('Text'),
                ),
              ])),
          Expanded(
              child: Container(
            child: page,
          ))
        ],
      ));
    });
  }
}
