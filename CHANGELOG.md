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

## 0.1.1+1

* Fix **escaping** error when build get String method for target `localizations`

## 0.1.2

* Add feature **extension** for target `localizations`.

    You can write your `excel2l10n.yaml` like this:

      ```yaml
      target:
        name: localizations
        genExtension: true
      ```

    to additional generate a base class for your `localizations` class.

    You can write your own localizations as a supplement. And it will not be 
    overwritten by subsequent generation operations.

## 0.1.2+1

* Fix **extension** error when build extension mixin for target `localizations`

## 0.1.3

* Optimize generating `TextSpan` for target `localizations`.
It will not generate `TextSpan(text: '')`.
