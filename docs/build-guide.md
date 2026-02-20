# ファームウェア ビルド & フラッシュガイド

## 概要

Keyball39 のカスタムファームウェアを Docker でビルドし、QMK Toolbox でフラッシュする手順を説明します。

## KVM 切り替え問題の修正

KVM スイッチで PC を切り替えた際に Keyball が認識されなくなる問題に対処するため、以下の変更を行っています。

### 変更内容

QMK の OS Detection 機能を有効化し、USB ホストが変わった際にキーボードが自動的にリセットされるようにします。

**`qmk_firmware/keyboards/keyball/keyball39/keymaps/via/rules.mk`**

```makefile
OS_DETECTION_ENABLE = yes
FORCE_NKRO = no
```

**`qmk_firmware/keyboards/keyball/keyball39/keymaps/via/config.h`**

```c
#define OS_DETECTION_KEYBOARD_RESET
```

- `OS_DETECTION_ENABLE`: USB ホストの OS を検出する機能を有効化
- `OS_DETECTION_KEYBOARD_RESET`: OS の変更 (= KVM 切り替え) を検出した際にキーボードをリセット
- `FORCE_NKRO = no`: OS Detection と NKRO の競合を防止

> **Note:** `NKRO_ENABLE = no` は `keyball39/rules.mk` で既に設定済みのため、キーマップ側での追加は不要です。

### 参考

- [ayuma (@ayuma_x) - X](https://x.com/ayuma_x/status/1922158305645932652) - KVM 切り替え問題の解決方法 (OS Detection + KEYBOARD_RESET の設定)

## ビルド (Docker)

GitHub Actions と同じ `ghcr.io/qmk/qmk_cli` イメージを使用して、ローカルでファームウェアをビルドします。GitHub Actions の実行を待たずに、手元で素早くビルド・検証できます。

### 前提条件

- Docker Desktop

### Docker 環境の構成

| ファイル | 役割 |
|---|---|
| `Dockerfile` | QMK CLI + QMK Firmware 0.22.14 をセットアップしたイメージ |
| `compose.yml` | ソースをマウントしてビルドスクリプトを実行 |
| `bin/docker-build.sh` | キーボード・キーマップを引数で受け取りコンパイルするスクリプト |
| `.dockerignore` | `.git/`, `tmp/` をビルドコンテキストから除外 |

### デフォルトビルド (keyball39:via)

```bash
docker compose run --rm build
```

### キーボード・キーマップを指定してビルド

```bash
docker compose run --rm build bash bin/docker-build.sh keyball61 via
```

### ビルド成果物

`tmp/` ディレクトリに `.hex` ファイルが生成されます。

```
tmp/keyball_keyball39_via.hex
```

### 参考

- [Keyball のファームウェアを Docker でローカルで簡単にビルドする - Zenn](https://zenn.dev/tomori_k/articles/735de6e8a7b084)

## フラッシュ (QMK Toolbox)

### 前提条件

- [QMK Toolbox](https://github.com/qmk/qmk_toolbox/releases) をダウンロード

### 手順

1. QMK Toolbox を起動
2. **Local file** に `tmp/keyball_keyball39_via.hex` を選択
3. **MCU** を `ATmega32U4` に設定
4. Keyball39 のリセットボタンを **ダブルタップ**
5. ログに `Caterina device connected` と表示される
6. **Flash** ボタンをクリック
7. `avrdude done. Thank you.` と表示されたら完了

### 注意事項

- **左右それぞれにフラッシュが必要です** (スプリットキーボードのため)
- リセットボタンのダブルタップ後、ブートローダーが有効な時間は約8秒です
- USB ケーブルを差し替えて左手側・右手側それぞれで同じ手順を繰り返してください
