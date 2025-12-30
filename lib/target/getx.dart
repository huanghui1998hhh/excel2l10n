import 'dart:convert';
import 'dart:io';

import '../excel/excel.dart';
import '../exporter/exporter.dart';
import 'target.dart';

class GetX extends Target {
  GetX.withSheetData(super.sheetData) : super.withSheetData();

  @override
  List<Exporter> get exporters => const [
        _GetHelper(),
        _GetTranslations(),
      ];
}

/// A file that contains the helper class for whole translation keys.
///
/// It like this:
/// ```dart
/// abstract class L {
///   static const key = 'value';
/// }
/// ```
class _GetHelper extends Exporter {
  const _GetHelper();

  @override
  String get fileName => 'locales_helper';

  @override
  String? get extensionName => 'g.dart';

  String get className => 'L';

  @override
  Future<void> buildFile(File outputFile, L10nSheet sheetData) async {
    final buffer = StringBuffer();
    buffer.writeln('abstract class $className {');
    final reg = RegExp(r'^[a-zA-Z0-9_]+$');
    for (final entry in sheetData.data.entries) {
      final keyTemp = entry.key.replaceAll(' ', '_');
      if (!reg.hasMatch(keyTemp)) continue;
      if (entry.value.description != null) {
        buffer.writeln('  /// ${entry.value.description}');
      }
      buffer.writeln("  static const $keyTemp = '${entry.key}';");
    }
    buffer.writeln('}');

    await outputFile.writeAsString(dartFormatter.format(buffer.toString()));
  }
}

class _GetTranslations extends Exporter {
  const _GetTranslations();

  @override
  String get fileName => 'locales';

  @override
  String? get extensionName => 'g.dart';

  String get className => 'MyLocale';

  @override
  Future<void> buildFile(File outputFile, L10nSheet sheetData) async {
    final buffer = StringBuffer();
    buffer.writeln('// coverage:ignore-file');
    buffer.writeln('// ignore_for_file: type=lint');
    buffer.writeln();
    buffer.writeln("import 'package:get/get.dart';");
    buffer.writeln();
    buffer.writeln('class $className extends Translations {');
    buffer.writeln('  @override');
    final mapDataTemp = <String, Map<String, String>>{};
    for (final language in sheetData.languages) {
      final temp = <String, String>{};
      for (final e in sheetData.data.entries) {
        final value = e.value.data[language];
        if (value == null) continue;
        temp[e.key] = value;
      }
      mapDataTemp[language] = temp;
    }
    final mapString = const JsonEncoder.withIndent('  ').convert(mapDataTemp);
    buffer
        .writeln('  Map<String, Map<String, String>> get keys => $mapString;');
    buffer.writeln('}');

    await outputFile.writeAsString(dartFormatter.format(buffer.toString()));
  }
}
