# excel2l10n

[![pub package](https://img.shields.io/pub/v/excel2l10n.svg)](https://pub.dev/packages/excel2l10n)

A tool to convert excel to l10n files.

## Installation

```console
dart pub add dev:excel2l10n
```

## Usage

1. Create a file named `excel2l10n.yaml` in your project root like this:

    ```yaml
    platform:
        # Currently only supports feishu
        name: feishu
        # Get it on https://open.feishu.cn/
        app_id: cli_xxxxxxxxxxxxxxxx
        # Get it on https://open.feishu.cn/
        app_secret: xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
        # It's your spreadsheet's token, usually in your spreadsheet url, 
        # like https://xxxxxxxxxx.feishu.cn/sheets/:spreadsheet_token
        spreadsheet_token: xxxxxxxxxxxxxxxxxxxxxxxxxxx
    # Currently supports getx and arb
    target: arb
    # The output directory
    output_dir: output
    ```

    If your target has additional settings, you can add them in the `target` section like this:

    ```yaml
    target:
        name: arb
        # Other settings
    ```

    1. Details for target **arb**:

        * `genL10nYaml: true`: Whether to generate `l10n.yaml` file.

    1. Details for target **localizations**:

        * No need to generate `.arb` file, directly generate `.dart` file.
        * Generate `TextSpan` for `placeholders`. It means you can use `Text.rich` to display the value.

1. Your table should look like this:

    | key | description | en | zh | ... |
    |-|-|-|-|-|
    | hello | Greeting in home page | Hello! | 你好！  | ... |

    The front two columns are required, and the rest are languages you want to support.

    Do not have empty columns in the middle.

1. Run the following command in your terminal:

    ```console
    dart run excel2l10n
    ```
