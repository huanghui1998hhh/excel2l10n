import 'dart:io';

import '../excel/excel.dart';
import '../settings.dart';

/// One exporter for one file
abstract class Exporter {
  const Exporter();

  String get fileName;
  String? get extensionName;

  Future<void> exportWith(L10nSheet sheetData) async {
    File outputFile = File(
      '${Settings.outputDirPath}/$fileName${extensionName == null ? '' : '.$extensionName'}',
    );
    outputFile = await outputFile.create(recursive: true);
    await buildFile(outputFile, sheetData);
  }

  Future<void> buildFile(File outputFile, L10nSheet sheetData);
}
