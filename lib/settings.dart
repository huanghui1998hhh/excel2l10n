import 'dart:io';
import 'package:dio/dio.dart';
import 'package:yaml/yaml.dart';

final dio = Dio();

abstract class Settings {
  static final map = loadYaml(File('excel2l10n.yaml').readAsStringSync());
  static String get outputDirPath => map['output_dir'] ?? 'output';
}
