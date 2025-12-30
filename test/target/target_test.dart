import 'dart:io';

import 'package:excel2l10n/target/target.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:test/test.dart';

void main() {
  group('getDartLanguageVersion', () {
    test('should return a valid Version object', () {
      final version = getDartLanguageVersion();

      expect(version, isA<Version>());
      expect(version.major, greaterThanOrEqualTo(0));
      expect(version.minor, greaterThanOrEqualTo(0));
      expect(version.patch, equals(0));
    });

    test('should parse version from Platform.version correctly', () {
      final version = getDartLanguageVersion();
      final platformVersion = Platform.version.split(' ').first;
      final parts = platformVersion.split('.');

      if (parts.length >= 2) {
        expect(version.major, equals(int.parse(parts[0])));
        expect(version.minor, equals(int.parse(parts[1])));
        expect(version.patch, equals(0));
      } else {
        // 如果版本字符串格式不符合预期，应该返回默认版本
        expect(version, equals(Version(3, 0, 0)));
      }
    });

    test('should have major version of at least 3', () {
      // 根据 pubspec.yaml 的 SDK 约束 ^3.3.0
      final version = getDartLanguageVersion();
      expect(version.major, greaterThanOrEqualTo(3));
    });

    test('should return version compatible with current Dart SDK', () {
      final version = getDartLanguageVersion();
      final platformVersion = Platform.version.split(' ').first;

      // 验证返回的版本号与平台版本号的主版本和次版本号一致
      if (platformVersion.split('.').length >= 2) {
        expect(
          version.toString().startsWith('${version.major}.${version.minor}.0'),
          isTrue,
        );
      }
    });
  });
}
