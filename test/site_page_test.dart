import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('the public page is a cv with a portrait and a highlight column', () {
    final page = File('site/index.html').readAsStringSync();
    final css = File('site/styles.css').readAsStringSync();

    expect(File('site/portrait.png').existsSync(), isTrue);
    expect(File('site/Alghisi_Alessandro_Paolo_Resume_2026.pdf').existsSync(), isTrue);
    expect(page, contains('<h1>Alessandro Paolo Alghisi</h1>'));
    expect(page, contains('alt="Alessandro Paolo Alghisi"'));
    expect(page, contains('<h2>For HR</h2>'));
    expect(page, contains('Bayut and Zameen, 2017–2024.'));
    expect(page, contains('Sector Labs'));
    expect(page, contains('Raw Geeks'));
    expect(page, contains('Babeș-Bolyai University'));
    expect(page, contains('alexalghisi@gmail.com'));
    expect(page, contains('https://alexalghisi.github.io/'));
    expect(page, contains('application/ld+json'));
    expect(page, contains('linkedin.com/in/alghisi'));
    expect(page, isNot(contains('alexalghisi@cluj')));
    expect(page, isNot(contains('career-showcase')));
    expect(page, isNot(contains('flutter_bootstrap.js')));
    expect(css, contains('grid-column: 2'));
    expect(css, contains('minmax(0, 1fr) 300px'));
  });
}
