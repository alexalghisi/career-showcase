import 'package:desk/profile.dart';

enum LineKind { plain, heading, prompt, error, dim }

class TranscriptLine {
  const TranscriptLine(this.text, [this.kind = LineKind.plain]);

  final String text;
  final LineKind kind;
}

class Shell {
  const Shell({required this.lines, this.openHinge = false});

  final List<TranscriptLine> lines;
  final bool openHinge;

  factory Shell.boot() {
    return Shell(lines: aboutLines());
  }

  Shell run(String raw) {
    final command = raw.trim();
    if (command.isEmpty) {
      return Shell(lines: lines);
    }
    final body = _dispatch(command);
    return Shell(
      lines: body.replace ? body.lines : [...lines, ...body.lines],
      openHinge: body.openHinge,
    );
  }
}

class _Dispatch {
  const _Dispatch(this.lines, {this.openHinge = false, this.replace = false});

  final List<TranscriptLine> lines;
  final bool openHinge;
  final bool replace;
}

const _promptHost = 'alexalghisi@cluj:~\$';

_Dispatch _dispatch(String command) {
  final key = command.toLowerCase();
  switch (key) {
    case 'help':
    case '?':
      return _Dispatch(_headed(command, _helpLines()));
    case 'whoami':
      return _Dispatch(_headed(command, _whoamiLines()));
    case 'cat':
    case 'cat about_me.txt':
    case 'about':
      return _Dispatch([
        TranscriptLine('$_promptHost $command', LineKind.prompt),
        ...aboutLines().skip(1),
      ]);
    case 'experience':
    case 'work':
    case 'jobs':
      return _Dispatch(_headed(command, _experienceLines()));
    case 'education':
    case 'school':
      return _Dispatch(_headed(command, _studyLines()));
    case 'stack':
    case 'tools':
      return _Dispatch(_headed(command, _stackLines()));
    case 'projects':
    case 'workbench':
      return _Dispatch(_headed(command, _workLines()));
    case 'languages':
      return _Dispatch(_headed(command, _spokenLines()));
    case 'awards':
    case 'olympiad':
      return _Dispatch(_headed(command, _markLines()));
    case 'contact':
    case 'links':
      return _Dispatch(_headed(command, _linkLines()));
    case 'clear':
      return const _Dispatch([], replace: true);
    case 'hinge':
    case 'open':
    case 'open hinge':
      return _Dispatch([
        TranscriptLine('$_promptHost $command', LineKind.prompt),
        const TranscriptLine('opening the sheet.', LineKind.dim),
      ], openHinge: true);
    default:
      return _Dispatch([
        TranscriptLine('$_promptHost $command', LineKind.prompt),
        TranscriptLine(
          'desk: no such command "$command". type help.',
          LineKind.error,
        ),
      ]);
  }
}

List<TranscriptLine> _headed(String command, List<TranscriptLine> body) {
  return [
    TranscriptLine('$_promptHost $command', LineKind.prompt),
    const TranscriptLine(''),
    ...body,
  ];
}

List<TranscriptLine> aboutLines() {
  return [
    const TranscriptLine('$_promptHost cat about_me.txt', LineKind.prompt),
    const TranscriptLine(''),
    const TranscriptLine('# whoami', LineKind.heading),
    const TranscriptLine(''),
    TranscriptLine(profile.name),
    const TranscriptLine(''),
    ...profile.blurb.map(TranscriptLine.new),
    const TranscriptLine(''),
    const TranscriptLine('## professional experience', LineKind.heading),
    const TranscriptLine(''),
    ..._experienceLines(),
    const TranscriptLine('## education', LineKind.heading),
    const TranscriptLine(''),
    ..._studyLines(),
    const TranscriptLine('## tech stack', LineKind.heading),
    const TranscriptLine(''),
    ..._stackLines(),
    const TranscriptLine('## things with my name on them', LineKind.heading),
    const TranscriptLine(''),
    ..._workLines(),
    const TranscriptLine('## awards', LineKind.heading),
    const TranscriptLine(''),
    ..._markLines(),
    const TranscriptLine('## languages', LineKind.heading),
    const TranscriptLine(''),
    ..._spokenLines(),
    const TranscriptLine('## contact', LineKind.heading),
    const TranscriptLine(''),
    ..._linkLines(),
    const TranscriptLine(''),
    const TranscriptLine('type help. hinge opens the sheet.', LineKind.dim),
  ];
}

List<TranscriptLine> _whoamiLines() {
  return [
    const TranscriptLine('# whoami', LineKind.heading),
    TranscriptLine(profile.name),
    ...profile.blurb.map(TranscriptLine.new),
  ];
}

List<TranscriptLine> _experienceLines() {
  final lines = <TranscriptLine>[];
  for (final role in profile.roles) {
    lines.add(TranscriptLine('${_span(role.span)}${role.org} — ${role.title}'));
    for (final line in role.lines) {
      lines.add(TranscriptLine('${_gap}Role: $line'));
    }
    lines.add(TranscriptLine('$_gap${role.tools.join(', ')}.', LineKind.dim));
    lines.add(const TranscriptLine(''));
  }
  return lines;
}

List<TranscriptLine> _studyLines() {
  return [
    for (final study in profile.studies) ...[
      TranscriptLine('${_span(study.span)}${study.school}'),
      TranscriptLine('$_gap${study.detail}'),
      const TranscriptLine(''),
    ],
  ];
}

List<TranscriptLine> _stackLines() {
  return [
    for (final row in profile.stack) TranscriptLine(row),
    const TranscriptLine(''),
  ];
}

List<TranscriptLine> _workLines() {
  return [
    for (final work in profile.works) ...[
      TranscriptLine(work.name),
      TranscriptLine('$_gap${work.detail}'),
      TranscriptLine('$_gap${work.link}', LineKind.dim),
      const TranscriptLine(''),
    ],
  ];
}

List<TranscriptLine> _markLines() {
  return [
    for (final mark in profile.marks) ...[
      TranscriptLine(mark.title),
      TranscriptLine('$_gap${mark.detail}'),
      const TranscriptLine(''),
    ],
  ];
}

List<TranscriptLine> _spokenLines() {
  return [
    for (final tongue in profile.spoken)
      TranscriptLine('${tongue.name.padRight(12)}${tongue.level}'),
    const TranscriptLine(''),
  ];
}

List<TranscriptLine> _linkLines() {
  return [for (final link in profile.links) TranscriptLine(link)];
}

List<TranscriptLine> _helpLines() {
  const rows = [
    'help         this list',
    'whoami       name and a short bio',
    'experience   roles, newest first',
    'education    schools',
    'stack        what I actually use',
    'projects     things with my name on them',
    'languages    spoken',
    'awards       olympiad and the bac',
    'contact      where to find me',
    'cat          print about_me.txt again',
    'hinge        open the sheet',
    'clear        wipe the scrollback',
  ];
  return [for (final row in rows) TranscriptLine(row)];
}

const _column = 12;

String _span(String span) => span.padRight(_column);

const _gap = '            ';
