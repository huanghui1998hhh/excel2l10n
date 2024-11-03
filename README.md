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
    # Currently only supports getx
    target: getx
    # The output directory
    output_dir: output
    ```

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
