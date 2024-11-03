import '../excel/excel.dart';
import '../exporter/exporter.dart';
import '../settings.dart';
import 'arb.dart';
import 'getx.dart';

abstract class Target {
  factory Target(L10nSheet sheetData) {
    switch (Settings.map['target']) {
      case 'getx':
        return GetX.withSheetData(sheetData);
      case 'arb':
      default:
        return Arb.withSheetData(sheetData);
    }
  }
  const Target.withSheetData(this.sheetData);

  final L10nSheet sheetData;
  List<Exporter> get exporters;

  Future<void> export() async =>
      Future.wait(exporters.map((e) => e.exportWith(sheetData)));
}
