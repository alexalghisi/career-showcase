import 'package:desk/ink.dart';
import 'package:desk/shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TerminalView extends StatefulWidget {
  const TerminalView({super.key});

  @override
  State<TerminalView> createState() => _TerminalViewState();
}

class _TerminalViewState extends State<TerminalView> {
  final _input = TextEditingController();
  final _scroll = ScrollController();
  final _field = FocusNode();
  final _history = <String>[];
  var _shell = Shell.boot();
  var _recall = 0;

  @override
  void dispose() {
    _input.dispose();
    _scroll.dispose();
    _field.dispose();
    super.dispose();
  }

  void _follow() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scroll.hasClients) {
        return;
      }
      _scroll.jumpTo(_scroll.position.maxScrollExtent);
    });
  }

  void _submit(String raw) {
    final trimmed = raw.trim();
    final next = _shell.run(raw);
    if (trimmed.isNotEmpty) {
      _history.add(trimmed);
      _recall = _history.length;
    }
    setState(() {
      _shell = Shell(lines: next.lines);
      _input.clear();
    });
    _follow();
    _field.requestFocus();
    if (next.openHinge && mounted) {
      Navigator.of(context).pushNamed('/hinge');
    }
  }

  void _recallOlder() {
    if (_history.isEmpty) {
      return;
    }
    _recall = (_recall - 1).clamp(0, _history.length - 1);
    _input.value = TextEditingValue(
      text: _history[_recall],
      selection: TextSelection.collapsed(offset: _history[_recall].length),
    );
  }

  void _recallNewer() {
    if (_history.isEmpty) {
      return;
    }
    if (_recall >= _history.length - 1) {
      _recall = _history.length;
      _input.clear();
      return;
    }
    _recall += 1;
    final text = _history[_recall];
    _input.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DeskInk.desk,
      body: SafeArea(
        child: CallbackShortcuts(
          bindings: {
            const SingleActivator(LogicalKeyboardKey.arrowUp): _recallOlder,
            const SingleActivator(LogicalKeyboardKey.arrowDown): _recallNewer,
          },
          child: Column(
            children: [
              Expanded(child: _scrollback()),
              const Divider(height: 1, color: Color(0xFF2A2822)),
              _promptRow(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _scrollback() {
    return SelectionArea(
      child: SingleChildScrollView(
        key: const Key('transcript'),
        controller: _scroll,
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var index = 0; index < _shell.lines.length; index++)
              _line(index, _shell.lines[index]),
          ],
        ),
      ),
    );
  }

  Widget _line(int index, TranscriptLine line) {
    return Text(
      line.text.isEmpty ? ' ' : line.text,
      key: ValueKey('line-$index-${line.kind.name}-${line.text}'),
      style: TextStyle(
        fontFamily: 'monospace',
        fontSize: 14.5,
        height: 1.45,
        color: _color(line.kind),
      ),
    );
  }

  Widget _promptRow() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'alexalghisi@cluj:~\$',
            key: Key('prompt'),
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 14.5,
              color: DeskInk.amber,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              key: const Key('command-field'),
              focusNode: _field,
              controller: _input,
              autofocus: true,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 14.5,
                color: DeskInk.bone,
              ),
              cursorColor: DeskInk.amber,
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(
                isCollapsed: true,
                border: InputBorder.none,
                hintText: 'help',
                hintStyle: TextStyle(
                  fontFamily: 'monospace',
                  color: DeskInk.dim,
                ),
              ),
              onSubmitted: _submit,
            ),
          ),
        ],
      ),
    );
  }

  Color _color(LineKind kind) {
    switch (kind) {
      case LineKind.heading:
        return DeskInk.moss;
      case LineKind.prompt:
        return DeskInk.amber;
      case LineKind.error:
        return DeskInk.rust;
      case LineKind.dim:
        return DeskInk.dim;
      case LineKind.plain:
        return DeskInk.bone;
    }
  }
}
