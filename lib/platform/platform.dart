import '../excel/excel.dart';
import '../settings.dart';
import 'feishu.dart';

abstract class Platform {
  factory Platform() {
    final platformNode = Settings.map['platform'];
    final name = switch (platformNode) {
      final String e => e,
      {'name': final String e} => e,
      _ => throw const _PlatformSettingsError(),
    };

    try {
      switch (name) {
        case 'feishu':
          return Feishu(
            appId: platformNode['app_id'],
            appSecret: platformNode['app_secret'],
            spreadsheetToken: platformNode['spreadsheet_token'],
          );
      }
    } catch (e) {
      throw _PlatformSettingsError(name);
    }

    throw UnimplementedError('Unsupported platform: $name');
  }

  /// Do some preparation work before using the platform.
  ///
  /// Like modify [dio], to set baseUrl, get access token & set to headers, etc.
  Future<void> prepare();

  /// Get all sheets data from the platform. Like [Sheet.id] and [Sheet.title].
  ///
  /// An excel file may contain multiple sheets.
  Future<List<Sheet>> getSheets();

  /// Get the l10n data by [Sheet].
  Future<L10nSheet> getL10nSheet(Sheet sheet);
}

class _PlatformSettingsError extends FormatException {
  const _PlatformSettingsError([String? platform])
      : super('Yaml platform($platform) settings error');
}
