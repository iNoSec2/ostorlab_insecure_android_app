import 'package:flutter/material.dart';
import 'package:ostorlab_insecure_flutter_app/bug_rule_caller.dart';
import 'package:ostorlab_insecure_flutter_app/bugs/ecb_cipher_mode.dart';
import 'package:ostorlab_insecure_flutter_app/bugs/clear_text_traffic.dart';
import 'package:ostorlab_insecure_flutter_app/bugs/hardcoded_creds_in_url.dart';
import 'package:ostorlab_insecure_flutter_app/bugs/static_iv.dart';
import 'package:ostorlab_insecure_flutter_app/bugs/tls_traffic.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Insecure Module',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Insecure Module'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late TextEditingController _controller;
  String _output = '';

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: _output);
    _runAll();
  }

  void _runAll() async {
    setState(() {
      _output = 'Running ...\n';
      _controller.text = _output;
    });

    BugRuleCaller caller = BugRuleCaller(context);
    _output += 'Adding rules ...\n';
    caller.addRule(ECBCipher());
    caller.addRule(ClearTextTraffic());
    caller.addRule(TLSTraffic());
    caller.addRule(StaticIV());
    caller.addRule(HardcodedCredsInUrl());

    try {
      await caller.callRules();
      _output += await caller.listBugRules();
    } catch (e) {
      _output += e.toString();
    }

    setState(() {
      _controller.text = _output;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Output:',
            ),
            Expanded(
              child: SingleChildScrollView(
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(border: OutlineInputBorder()),
                  minLines: 15,
                  maxLines: null,
                  readOnly: true,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: _runAll,
                  child: Text('Run All'),
                ),
                SizedBox(width: 10),
              ],
            )
          ],
        ),
      ),
    );
  }
}