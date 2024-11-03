class L10nSheet {
  factory L10nSheet(Sheet sheet, List<List<String?>> data) {
    final map = <String, DataRow>{};
    List<String>? headers;
    try {
      headers = data.firstOrNull?.map((e) => e!).toList();
    } catch (e) {
      throw _SheetHeaderFormatError('$sheet');
    }
    if (headers == null) {
      return const L10nSheet.empty();
    }
    if (headers case ['key', 'description', ...final List<String> languages]) {
      for (var i = 1; i < data.length; i++) {
        final row = data[i];
        final key = row.firstOrNull;
        if (key != null) {
          if (map[key] != null) {
            print(
              'warning: Key "$key" in sheet "$sheet" is duplicated, '
              'the latter one will be kept',
            );
          }
          map[key] = DataRow(
            source: sheet,
            description: row[1],
            data: {
              for (var j = 2; j < row.length; j++) headers[j]: row[j],
            },
          );
        } else {
          print(
            'warning: The key in row ${i + 1} of sheet "$sheet" is empty',
          );
        }
      }

      return L10nSheet.raw(map, languages);
    }
    throw _SheetHeaderFormatError('$sheet');
  }

  const L10nSheet.empty()
      : data = const {},
        languages = const [];

  L10nSheet.raw(this.data, this.languages);

  // {
  //   'key': {
  //     'description': 'description',
  //     'en': 'value',
  //     'zh': 'value',
  //   }
  // }
  final Map<String, DataRow> data;
  final List<String> languages;

  L10nSheet operator +(L10nSheet other) {
    final mergedData = {...data};
    for (final entry in other.data.entries) {
      final currentIfExists = mergedData[entry.key];
      if (currentIfExists != null) {
        print(
          'warning: key "${entry.key}" exists in both sheet '
          '"${currentIfExists.source}" and sheet "${entry.value.source}", '
          'the one in sheet "${entry.value.source}" will be kept',
        );
      }

      mergedData[entry.key] = entry.value;
    }

    return L10nSheet.raw(
      mergedData,
      Set.of(languages + other.languages).toList(),
    );
  }

  @override
  String toString() => data.toString();
}

class DataRow {
  const DataRow({
    required this.source,
    required this.description,
    required this.data,
  });

  final Sheet source;
  final String? description;
  final Map<String, String?> data;
}

class Sheet {
  const Sheet(this.id, this.title);

  final String id;
  final String title;

  @override
  String toString() => title;
}

class _SheetHeaderFormatError extends FormatException {
  const _SheetHeaderFormatError(String sheetName)
      : super('Sheet "$sheetName" headers format error');
}
