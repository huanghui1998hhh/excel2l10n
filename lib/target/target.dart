import '../excel/excel.dart';
import '../exporter/exporter.dart';
import '../settings.dart';
import 'arb.dart';
import 'getx.dart';

abstract class Target {
  factory Target(L10nSheet sheetData) {
    final targetNode = Settings.map['target'];
    final name = switch (targetNode) {
      final String e => e,
      {'name': final String e} => e,
      _ => throw const _TargetSettingsError(),
    };

    try {
      switch (name) {
        case 'getx':
          return GetX.withSheetData(sheetData);
        case 'arb':
          return Arb.withSheetData(
            sheetData,
            genL10nYaml: switch (targetNode) {
                  {'genL10nYaml': final bool? e} => e,
                  _ => null,
                } ??
                false,
          );
      }
    } catch (e) {
      throw _TargetSettingsError(name);
    }

    throw UnimplementedError('Unsupported target: $name');
  }
  const Target.withSheetData(this.sheetData);

  final L10nSheet sheetData;
  List<BaseExporter> get exporters;

  Future<void> export() async =>
      Future.wait(exporters.map((e) => e.exportWith(sheetData)));
}

class _TargetSettingsError extends FormatException {
  const _TargetSettingsError([String? target])
      : super('Yaml target($target) settings error');
}
