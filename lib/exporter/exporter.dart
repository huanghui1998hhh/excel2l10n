import 'dart:io';

import '../excel/excel.dart';
import '../settings.dart';

abstract class BaseExporter {
  const BaseExporter();

  String get fileName;
  String? get extensionName;

  String get fullFileName =>
      '$fileName${extensionName == null ? '' : '.$extensionName'}';

  Future<void> exportWith(L10nSheet sheetData);
}

/// One exporter for one file
abstract class Exporter extends BaseExporter {
  const Exporter();

  @override
  String get fileName;
  @override
  String? get extensionName;

  @override
  Future<void> exportWith(L10nSheet sheetData) async {
    File outputFile = File(
      '${Settings.outputDirPath}/$fullFileName',
    );
    outputFile = await outputFile.create(recursive: true);
    await buildFile(outputFile, sheetData);
  }

  Future<void> buildFile(File outputFile, L10nSheet sheetData);
}

abstract class NoOverrideExporter extends Exporter {
  const NoOverrideExporter();

  @override
  Future<void> exportWith(L10nSheet sheetData) async {
    File outputFile = File(
      '${Settings.outputDirPath}/$fullFileName',
    );
    if (outputFile.existsSync()) {
      return;
    }
    outputFile = await outputFile.create(recursive: true);
    await buildFile(outputFile, sheetData);
  }
}
