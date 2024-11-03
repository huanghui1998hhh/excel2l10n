import 'package:excel2l10n/platform/platform.dart';
import 'package:excel2l10n/target/target.dart';

void main(List<String> arguments) async {
  final platform = Platform();
  await platform.prepare();
  final sheets = await platform.getSheets();
  final sheetsData = (await Future.wait(sheets.map(platform.getL10nSheet)))
      .reduce((a, b) => a + b);
  await Target(sheetsData).export();
}
