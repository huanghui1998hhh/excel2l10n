import 'dart:io';

import 'package:dart_style/dart_style.dart';

import '../excel/excel.dart';
import '../exporter/exporter.dart';
import 'target.dart';

class Localizations extends Target {
  Localizations.withSheetData(super.sheetData)
      : exporters = [
          const _Localizations(),
          for (final language in sheetData.languages)
            _LocalizationsLanguage(language),
        ],
        super.withSheetData();

  @override
  final List<Exporter> exporters;
}

class _Localizations extends Exporter {
  const _Localizations();

  @override
  String get fileName => 'app_localizations';

  @override
  String? get extensionName => 'dart';

  String get className => 'L';

  @override
  Future<void> buildFile(File outputFile, L10nSheet sheetData) async {
    final buffer = StringBuffer();

    buffer.writeln('''
// coverage:ignore-file
// ignore_for_file: type=lint

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;
''');

    final languages = sheetData.languages;
    for (final language in languages) {
      buffer.writeln("import 'app_localizations_$language.dart';");
    }
    buffer.writeln();

    buffer.writeln('''
abstract class $className {
  $className(String locale) : localeName = intl.Intl.canonicalizedLocale(locale);

  final String localeName;

  static $className of(BuildContext context) {
    return Localizations.of<$className>(context, $className) ?? $className${languages.first.firstUpperCase}();
  }

  static const LocalizationsDelegate<$className> delegate = _${className}Delegate();

  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  static const List<Locale> supportedLocales = <Locale>[
''');
    for (final language in languages) {
      buffer.writeln("    Locale('$language'),");
    }

    buffer.writeln('  ];');
    buffer.writeln();

    for (final e in sheetData.data.entries) {
      final key = e.key;
      final row = e.value;
      final placeholderMatches = row.placeholderMatches;
      if (row.description != null) {
        buffer.writeln('  /// ${row.description}');
      }
      if (placeholderMatches.isEmpty) {
        buffer.writeln('  String get $key;');
      } else {
        buffer.writeln(
          '  String $key(${placeholderMatches.map((e) => 'String ${e.group(1)}').join(', ')});',
        );
        buffer.writeln();
        buffer.writeln(
          '  TextSpan ${key}Span(${placeholderMatches.map((e) => 'TextSpan ${e.group(1)}').join(', ')});',
        );
      }
      buffer.writeln();
    }

    buffer.writeln('}');
    buffer.writeln();

    buffer.writeln('''
class _${className}Delegate extends LocalizationsDelegate<$className> {
  const _${className}Delegate();

  @override
  Future<$className> load(Locale locale) {
    return SynchronousFuture<$className>(lookup$className(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[${languages.map((e) => "'$e'").join(', ')}].contains(locale.languageCode);

  @override
  bool shouldReload(_${className}Delegate old) => false;
}

''');

    buffer.write('''
$className lookup$className(Locale locale) {
  switch (locale.languageCode) {
''');
    for (final language in languages) {
      buffer.writeln(
        "    case '$language': return $className${language.firstUpperCase}();",
      );
    }
    buffer.writeln(r'''
  }

  throw FlutterError(
    'L.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}

''');

    await outputFile.writeAsString(DartFormatter().format(buffer.toString()));
  }
}

extension on String {
  String get firstUpperCase => this[0].toUpperCase() + substring(1);
}

final _placeholderReg = RegExp(r'\{(\w+)\}');

extension on DataRow {
  Iterable<RegExpMatch> get placeholderMatches =>
      _placeholderReg.allMatches(data.values.first!);
}

class _LocalizationsLanguage extends Exporter {
  const _LocalizationsLanguage(this.language);

  @override
  String get fileName => 'app_localizations_$language';

  @override
  String? get extensionName => 'dart';

  String get className => 'L';

  final String language;

  @override
  Future<void> buildFile(File outputFile, L10nSheet sheetData) async {
    final buffer = StringBuffer();
    buffer.writeln('// coverage:ignore-file');
    buffer.writeln('// ignore_for_file: type=lint');
    buffer.writeln();
    buffer.writeln("import 'package:flutter/painting.dart';");
    buffer.writeln("import 'app_localizations.dart';");
    buffer.writeln();
    final thisFileClassName = '$className${language.firstUpperCase}';
    buffer.writeln(
      'class $thisFileClassName extends $className {',
    );
    buffer.writeln(
      "  $thisFileClassName([String locale = '$language']) : super(locale);",
    );
    buffer.writeln();

    for (final e in sheetData.data.entries) {
      final key = e.key;
      final row = e.value;
      final value =
          row.data[language] ?? row.data.values.firstWhere((e) => e != null);
      if (value == null) {
        throw Exception('Value for $key all languages is null');
      }
      final placeholderMatches = row.placeholderMatches;
      buffer.writeln('  @override');
      if (placeholderMatches.isEmpty) {
        buffer.writeln("  String get $key => '$value';");
      } else {
        buffer.writeln(
          "String $key(${placeholderMatches.map((e) => 'String ${e.group(1)}').join(', ')}) => '${value.replaceAllMapped(_placeholderReg, (match) => '\${${match.group(1)}}')}';",
        );
        buffer.writeln();
        buffer.writeln('  @override');
        buffer.writeln(
          "  TextSpan ${key}Span(${placeholderMatches.map((e) => 'TextSpan ${e.group(1)}').join(', ')}) => TextSpan(children: [${value.splitMapJoin(_placeholderReg, onMatch: (match) => '${match.group(1)},', onNonMatch: (e) => "TextSpan(text: '$e'),")}],);",
        );
      }
      buffer.writeln();
    }
    buffer.writeln('}');
    buffer.writeln();

    await outputFile.writeAsString(DartFormatter().format(buffer.toString()));
  }
}
