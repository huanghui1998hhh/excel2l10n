import '../excel/excel.dart';
import '../settings.dart';
import 'platform.dart';

class Feishu implements Platform {
  const Feishu({
    required this.appId,
    required this.appSecret,
    required this.spreadsheetToken,
  });

  final String appId;
  final String appSecret;
  final String spreadsheetToken;

  @override
  Future<void> prepare() {
    dio.options.baseUrl = 'https://open.feishu.cn/open-apis';

    return dio.post(
      '/auth/v3/app_access_token/internal',
      data: {
        'app_id': appId,
        'app_secret': appSecret,
      },
    ).then(
      (response) {
        dio.options.headers['Authorization'] =
            'Bearer ${response.data['app_access_token'] as String}';
      },
    );
  }

  @override
  Future<List<Sheet>> getSheets() =>
      dio.get('/sheets/v3/spreadsheets/$spreadsheetToken/sheets/query').then(
            (response) => (response.data['data']['sheets'] as List)
                .map((e) => Sheet(e['sheet_id'], e['title']))
                .toList(),
          );

  @override
  Future<L10nSheet> getL10nSheet(Sheet sheet) => dio
      .get('/sheets/v2/spreadsheets/$spreadsheetToken/values/${sheet.id}')
      .then(
        (response) => L10nSheet(
          sheet,
          (response.data['data']['valueRange']['values'] as List)
              .map(
                (e) => (e as List).map<String?>((e) {
                  if (e is String?) {
                    return e;
                  }
                  return null;
                }).toList(),
              )
              .toList(),
        ),
      );
}
