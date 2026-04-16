# Design System

このリポジトリの Typst/Touying スライドで使うデザインシステムです。**色・タイポの実装の正は常に `template/style.typ`**。利用例は `template/main.typ`（全パターン）または `template/main-minimal.typ`（最小例）、運用ルールは `docs/style-guide.md` に置きます。

## Brand Identity

### Colors

| Token | Value | Role |
| --- | --- | --- |
| Primary | `#2C2A4A` | 見出し、章タイトル、強い情報階層 |
| Secondary | `#DADAD8` | スライド背景（`surface_base`） |
| Accent | `#B89B4F` | 強調、アクセント線、数値強調（`accent_base`、旧ドキュメントの Tertiary と同一役割） |
| Neutral Surface | `#EFEEEC` | カード、通常パネル |
| Ink | `#2B2F3A` | 本文（実装は `text_primary`） |
| Muted | `#5A6070` | 補足テキスト（実装は `text_secondary`） |
| Line | `#C8C8C5` | 境界線（実装は `border`） |
| Success | `#3A7D44` | 改善後、良い状態 |
| Warning | `#C78B2A` | 注意、警告 |
| Danger | `#B94A48` | 問題、Before、避けたい状態 |

surface は `#EFEEEC` と `#DADAD8` の2段階に絞ります。アクセントは **Accent** を中心に使い、1スライドあたり1から2箇所に抑えます。Primary と Secondary の面積を多めに取り、アクセントは視線誘導のために使います。

### Typography

- Headlines: `Manrope`
- Body Text: `Inter`
- Portable default: `Noto Sans CJK JP`

Typst実装では、警告なしでビルドできる可搬性を優先し、標準トークンは `Noto Sans CJK JP` を使います。`Manrope` / `Inter` を導入した環境では、`template/style.typ` の `fonts` を差し替えることでブランド寄りの英字組版にできます。

## UI Elements

## Type Scale

| Token | Range |
| --- | --- |
| Display | 48から64pt |
| Title | 32から40pt |
| Heading | 24から28pt |
| Body | 17から20pt |
| Caption | 13から14pt |

行間と字間は `template/style.typ` の `leading` / `tracking` で固定します。日本語のtrackingは `0pt` です。

## Constraints

- カードタイトルは最大2行
- カード本文は最大3行または60文字
- 1カラムあたりbulletは最大3
- 1スライドの要素数は最大6
- アイコンは24pt、32pt、48ptのいずれか
- 背景画像はoverlay必須、テキスト幅60%以下

### Roundedness

角丸は控えめにします。カードやコールアウトは `3pt` を基準とし、装飾より情報のまとまりを優先します。

### Spacing

標準余白は `8pt`、カード内余白は `12pt` を基準にします。詰まる場合は文字を小さくする前に、項目削減、2カラム化、別スライド化を検討します。
