import 'dart:collection';

import '../excel/excel.dart';
import '../exporter/exporter.dart';
import '../settings.dart';
import 'arb.dart';
import 'getx.dart';
import 'localizations.dart';

abstract class Target {
  factory Target(L10nSheet sheetData) {
    Target? result;

    final targetNode = Settings.map['target'];
    final name = switch (targetNode) {
      final String e => e,
      {'name': final String e} => e,
      _ => throw const _TargetSettingsError(),
    };

    T possibleTargetValue<T>(String key, {required T defaultValue}) {
      if (targetNode is MapBase) {
        return targetNode[key] ?? defaultValue;
      } else {
        return defaultValue;
      }
    }

    try {
      switch (name) {
        case 'getx':
          result = GetX.withSheetData(sheetData);
        case 'arb':
          result = Arb.withSheetData(
            sheetData,
            genL10nYaml: possibleTargetValue(
              'genL10nYaml',
              defaultValue: false,
            ),
          );
        case 'localizations':
          result = Localizations.withSheetData(
            sheetData,
            className: possibleTargetValue(
              'className',
              defaultValue: 'L',
            ),
            outputFileName: possibleTargetValue(
              'outputFileName',
              defaultValue: 'app_localizations',
            ),
            genExtension: possibleTargetValue(
              'genExtension',
              defaultValue: false,
            ),
          );
      }
    } catch (e) {
      throw _TargetSettingsError(name);
    }
    if (result == null) {
      throw UnimplementedError('Unsupported target: $name');
    }
    current = result;
    return result;
  }
  const Target.withSheetData(this.sheetData);

  static late final Target current;

  final L10nSheet sheetData;
  List<BaseExporter> get exporters;

  Future<void> export() async =>
      Future.wait(exporters.map((e) => e.exportWith(sheetData)));
}

class _TargetSettingsError extends FormatException {
  const _TargetSettingsError([String? target])
      : super('Yaml target($target) settings error');
}
