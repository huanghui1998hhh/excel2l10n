## 0.0.1

* Implement platform [feishu](https://open.feishu.cn/).
* Implement target [getx](https://pub.dev/packages/get#translations).

## 0.0.2

* Basic implement for target [arb](https://github.com/google/app-resource-bundle/wiki/ApplicationResourceBundleSpecification).

  **Currently supported:**

  * `description`
  * Only `String` type `placeholders`

## 0.0.3

* Basic implement target [localizations](https://docs.flutter.dev/ui/accessibility-and-internationalization/internationalization).

  **What's different with target `arb`:**

  * No need to generate `.arb` file, directly generate `.dart` file.
  * Generate `TextSpan` for `placeholders`. It means you can use `Text.rich` to display the value.
  * Other features supported are the same as target `arb`.

## 0.1.0

* Relaxing dart version restrictions 3.5.3->3.3.0

## 0.1.1

* Add feature **escaping** for target `localizations`
