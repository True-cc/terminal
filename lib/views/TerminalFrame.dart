import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pty/pty.dart';
import 'package:xterm/flutter.dart';
import 'package:xterm/xterm.dart';

class TerminalFrame extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TerminalFrameState();
  }

}

class TerminalFrameState extends State<TerminalFrame> {

  late Terminal _terminal;
  late PseudoTerminal _console;

  @override
  void initState() {
    _console = PseudoTerminal.start(
      r'cmd',
      ['-l'],
      environment: {'TERM': 'xterm-256color'},
    );
    _terminal = Terminal(
        onInput: (msg) {
          _console.write(msg);
          _terminal.write(msg);
          print(msg);
        },
        maxLines: 10000,
        platform: PlatformBehaviors.windows
    );
    //_terminal.debug.enable();
    _terminal.setBlinkingCursor(true);
    _console.out.listen((event) {
      _console.write("echo hi");
      print(event);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(55.0),
        child: AppBar(
          elevation: 0.0,
          bottom: PreferredSize(
            preferredSize:
            Size.fromHeight(55.0),
            child: Row(
            children: [
              MaterialButton(onPressed: () {
                _console.write("echo hi");
              }, child: Text("PRESS ME"),)
            ],
          )),
        )),
      body: CupertinoScrollbar(
        child: TerminalView(
          terminal: _terminal,
          onResize: _console.resize,
        ),
      ),
    );
  }

}