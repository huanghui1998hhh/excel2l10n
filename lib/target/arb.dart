import 'dart:convert';
import 'dart:io';

import '../excel/excel.dart';
import '../exporter/exporter.dart';
import '../settings.dart';
import 'target.dart';

class Arb extends Target {
  Arb.withSheetData(super.sheetData, {required bool genL10nYaml})
      : exporters = [
          if (genL10nYaml) const _L10nYaml(),
          for (final language in sheetData.languages) _ArbHelper(language),
        ],
        super.withSheetData();

  @override
  final List<BaseExporter> exporters;
}

class _L10nYaml extends BaseExporter {
  const _L10nYaml();

  @override
  String get fileName => 'l10n';

  @override
  String? get extensionName => 'yaml';

  String get outputClassName => 'L';

  @override
  Future<void> exportWith(L10nSheet sheetData) async {
    File outputFile = File(fullFileName);
    outputFile = await outputFile.create(recursive: true);

    await outputFile.writeAsString('''
arb-dir: ${Settings.outputDirPath}
output-dir: ${Settings.outputDirPath}/gen
template-arb-file: app_${sheetData.languages.first}.arb
synthetic-package: false
output-class: $outputClassName
''');
  }
}

class _ArbHelper extends Exporter {
  const _ArbHelper(this.language);

  @override
  String get fileName => 'app_$language';

  @override
  String? get extensionName => 'arb';

  final String language;

  @override
  Future<void> buildFile(File outputFile, L10nSheet sheetData) async {
    final arbTemplate = <String, dynamic>{};
    arbTemplate['@@locale'] = language;

    for (final entry in sheetData.data.entries) {
      final value = entry.value.data[language];
      if (value == null) continue;
      final key = entry.key;
      arbTemplate[key] = value;
      arbTemplate['@$key'] = entry.value.toMetadata(language);
    }

    await outputFile
        .writeAsString(const JsonEncoder.withIndent('  ').convert(arbTemplate));
  }
}

final _placeholderReg = RegExp(r'\{(\w+)\}');

extension on DataRow {
  dynamic toMetadata(String language) {
    final placeholders = _placeholderReg.allMatches(data[language]!);

    return {
      if (description != null) 'description': description,
      if (placeholders.isNotEmpty)
        'placeholders': {
          for (final match in placeholders) match.group(1): {'type': 'String'},
        },
    };
  }
}
