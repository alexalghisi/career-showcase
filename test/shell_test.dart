import 'package:desk/profile.dart';
import 'package:desk/shell.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('boot file names the person and the newest role', () {
    final boot = Shell.boot();
    final text = boot.lines.map((line) => line.text).join('\n');

    expect(boot.openHinge, isFalse);
    expect(text, contains('cat about_me.txt'));
    expect(text, contains(profile.name));
    expect(text, contains('Raw Geeks'));
    expect(text, contains('Babes-Bolyai University'));
    expect(text, contains('linkedin.com/in/alghisi'));
    expect(text, contains('github.com/alexalghisi'));
    expect(profile.roles.first.org, 'Raw Geeks');
    expect(profile.roles.last.org, 'Yardi Systems');
  });

  test('experience stays in profile order', () {
    final text = _run('experience');
    final sector = text.indexOf('Sector Labs');
    final yardi = text.indexOf('Yardi Systems');
    final chrome = text.indexOf('Google Chrome');

    expect(sector, greaterThan(0));
    expect(chrome, greaterThan(sector));
    expect(yardi, greaterThan(chrome));
    expect(text, contains('Bayut'));
    expect(text, contains('LoadRunner'));
  });

  test('section commands print the matching facts', () {
    expect(_run('education'), contains('Technical University of Cluj-Napoca'));
    expect(_run('stack'), contains('FastAPI'));
    expect(_run('projects'), contains('A11yDojo'));
    expect(_run('projects'), contains('1881603002'));
    expect(_run('languages'), contains('Italian'));
    expect(_run('awards'), contains('2013 and 2014'));
    expect(_run('contact'), contains('Cluj-Napoca'));
    expect(_run('whoami'), contains('national informatics olympiad'));
    expect(_run('help'), contains('hinge'));
  });

  test('aliases share a body with the canonical command', () {
    expect(_body('work'), _body('experience'));
    expect(_body('school'), _body('education'));
    expect(_body('links'), _body('contact'));
  });

  test('unknown input is an error and does not open the sheet', () {
    final shell = Shell.boot().run('sudo make me a sandwich');

    expect(shell.openHinge, isFalse);
    expect(
      shell.lines.map((line) => line.text).join('\n'),
      contains('no such command'),
    );
    expect(shell.lines.any((line) => line.kind == LineKind.error), isTrue);
  });

  test('empty input leaves the scrollback alone', () {
    final boot = Shell.boot();
    final next = boot.run('   ');

    expect(next.lines, boot.lines);
    expect(next.openHinge, isFalse);
  });

  test('clear wipes the scrollback', () {
    final shell = Shell.boot().run('clear');

    expect(shell.lines, isEmpty);
    expect(shell.openHinge, isFalse);
  });

  test('hinge asks the desk to open the sheet', () {
    final shell = Shell.boot().run('open hinge');

    expect(shell.openHinge, isTrue);
    expect(
      shell.lines.map((line) => line.text).join('\n'),
      contains('opening the sheet.'),
    );
  });

  test('every listed command returns without throwing', () {
    const commands = [
      'help',
      'whoami',
      'cat about_me.txt',
      'experience',
      'education',
      'stack',
      'projects',
      'languages',
      'awards',
      'contact',
      'hinge',
      'clear',
    ];
    for (final command in commands) {
      expect(() => Shell.boot().run(command), returnsNormally);
    }
  });
}

String _run(String command) {
  return Shell.boot().run(command).lines.map((line) => line.text).join('\n');
}

String _body(String command) {
  final lines = Shell.boot().run(command).lines;
  final boot = Shell.boot().lines.length;
  return lines.skip(boot + 1).map((line) => line.text).join('\n');
}
