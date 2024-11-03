import '../exporter/exporter.dart';
import 'target.dart';

class Arb extends Target {
  Arb.withSheetData(super.sheetData) : super.withSheetData();

  @override
  List<Exporter> get exporters => throw UnimplementedError();
}
