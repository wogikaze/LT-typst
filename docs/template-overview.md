# Template 概要

このドキュメントは、リポジトリ内 `template/` の**現状実装**を整理したものです。テンプレートの設計意図・制約・部品一覧を把握し、改修の判断材料にしてください。

関連ドキュメント:

| ファイル | 内容 |
| --- | --- |
| [style-guide.md](./style-guide.md) | デザイン判断・密度制約・NG例 |
| [DESIGN.md](../DESIGN.md) | ブランドカラー・タイポの要約 |
| [workflow.md](./workflow.md) | AI エージェントとの作業手順 |
| [slide-recipes.md](./slide-recipes.md) | **中間層（Recipes）— 自由度と覚えやすさのバランス** |
| [template/README.md](../template/README.md) | クイックスタート |

---

## 一言で言うと

**16:9 の講習会スライドを、Atomic Design で部品化した純 Typst テンプレート**です。

- スライド本文（`main.typ`）はレイアウト関数の呼び出しだけ
- 見た目の数値は `style.typ` に集約
- 再利用部品は `components.typ`、スライド構造は `layouts.typ`

> **注意:** ルート README や `typst.toml` には「Touying + Metropolis」と書かれていますが、**現行コードは Touying を import していません**。ページ設定・テーマ・レイアウトはすべて自前実装です。

---

## リポジトリ内の位置づけ

```text
LT-typst/
├── template/              ← デザインシステム本体（部品・トークン・カタログ）
│   ├── style.typ
│   ├── components.typ
│   ├── layouts.typ
│   ├── main.typ           ← 全レイアウトのカタログ（40枚弱）
│   └── main-minimal.typ   ← よく使う5パターンだけ
├── _template/             ← 新規デッキ用の薄いエントリ（template/ を import）
│   └── _template.typ
├── discord-bot/           ← 実際の講習スライド例
│   └── discord-bot.typ
└── docs/                  ← 設計・運用ドキュメント
```

| 用途 | 使うファイル | ビルド |
| --- | --- | --- |
| 部品・パターンを眺める | `template/main.typ` | `cd template && mise run build` |
| 最小例から Fork | `template/main-minimal.typ` | 同上 |
| リポジトリ規約で新規デッキ | `_template/` をコピー → `<dir>/<dir>.typ` | `mise run build <dir>` |
| 実例を参照 | `discord-bot/discord-bot.typ` | `mise run build discord-bot` |

---

## アーキテクチャ

### データの流れ

```text
main.typ
  #show: apply-theme          ← style.typ（ページ・グローバル show rules）
  #deck(( ... ))              ← layouts.typ（枚管理・ページ区切り）
    title-pattern(...)        ← layouts.typ（Organism / Template）
      card(...)               ← components.typ（Molecule）
        headline(...)         ← components.typ（Atom）
```

### Atomic Design 対応

| 層 | ファイル | 責務 |
| --- | --- | --- |
| **Tokens** | `style.typ` | 色、フォント、サイズ、余白、`limits`（密度上限） |
| **Atoms** | `components.typ` | `headline`, `prose`, `caption`, `chip`, `divider`, `number-badge` など |
| **Molecules** | `components.typ` | `card`, `callout`, `metric`, `image-card`, `step-item` など |
| **Organisms** | `layouts.typ` | `compare-pattern`, `steps-pattern`, `stats-pattern` など |
| **Templates** | `layouts.typ` | `deck`, `slide-frame`, 全面背景系パターン |

### 設計思想

1. **崩れにくさ優先** — カード高さ・文字量・要素数に上限を設け、PDF でのはみ出しを防ぐ
2. **1スライド1メッセージ** — 情報過多は別スライドへ分割する前提
3. **色は意味に使う** — `danger` / `success` / `warning` / `info` で状態を表現
4. **main.typ に装飾を書かない** — 新表現は部品かパターンとして追加

### 3段階の書き方（自由度の問題）

| Tier | 名前 | 例 | 向いている場面 |
| --- | --- | --- | --- |
| 1 | **Patterns** | `compare-pattern`, `title-pattern` | 意味が決まった定番スライド |
| 2 | **Recipes** | `cards-slide`, `figures-slide`, `stack-slide` | 件数可変・覚える関数は8個程度 |
| 3 | **Escape** | `content-slide` / `slide-frame` | 1枚だけ特殊 |

**Patterns だけだと自由度が低い**（横ステップ4固定など）。**slide-frame 直書きだと覚えることが多い**（`grid-cards`, `limits`, `box`+`image` 等）。日常のスライドは **Tier 2 Recipes** から書き始けるのがおすすめです。

詳細: [slide-recipes.md](./slide-recipes.md)

---

## ファイル詳細

### `style.typ` — デザイントークンとテーマ

**単一ソース（SSOT）** として、数値の正は常にここです。

| カテゴリ | 主な変数 | 内容 |
| --- | --- | --- |
| 色 | `colors`, `theme` | Primary `#2C2A4A`、Accent `#B89B4F`、Surface 2段階、semantic 色 |
| フォント | `fonts` | 既定は `Noto Sans CJK JP`（全階層）、コードは `Noto Sans Mono CJK JP` |
| サイズ | `sizes` | `display` 56pt 〜 `caption` 13pt |
| 余白 | `space` | `xs` 4pt 〜 `xl` 32pt |
| ページ | `page-width/height` | 13.333in × 7.5in（16:9）、マージン x:40pt y:28pt |
| 制約 | `limits` | 文字数・要素数・カード高さ・overlay 色など |

`apply-theme(body)` が `#show` ルールとして:

- ページサイズ・背景色
- 本文フォント・行間
- 見出し h1〜h3 のスタイル
- `emph` / `strong` / `link` / インライン・ブロック `raw` の見た目

を一括適用します。

### `components.typ` — 部品

#### Atoms

| 関数 | 用途 |
| --- | --- |
| `headline(body, size, fill)` | 太字見出し |
| `label(body, fill)` | ラベル（callout 見出し等） |
| `prose(body, muted, size)` | 本文 |
| `caption(body)` | 補足・出典 |
| `link-url(url, body)` | 外部リンク（`theme.info` 色） |
| `divider()` | 水平線 |
| `chip(body, ...)` | ピル型ラベル |
| `number-badge(number, ...)` | 番号バッジ |
| `keycap(body)` | キー表示 |
| `swatch(fill, ...)` | 色見本 |

#### Molecules

| 関数 | 用途 | 主なパラメータ |
| --- | --- | --- |
| `bullet-list(items)` | 箇条書き（`space.md` 間隔） | — |
| `card(title, body, ...)` | 基本カード | `tone`: default / primary / accent / success / warning / danger / info |
| `flat-card(title, body, ...)` | 枠のみのカード | — |
| `callout(title, body, kind)` | 左ボーダー強調 | `kind`: info / success / warning / danger |
| `icon-callout(title, body, kind)` | アイコン付き行 | 記号は ✓ / ! / × / i |
| `metric(value, label, ...)` | 数値強調 | `variant: "hero"` で大きく |
| `step-item(number, title, body, ...)` | 縦ステップ1行 | 固定高さ |
| `image-card(title, path, body, ...)` | 画像ヘッダー付きカード | `order` で番号バッジ |
| `code-card(title, code)` | コード入りカード | primary トーン |
| `quote-card(body, by)` | 引用 | — |
| `level-card(...)` | 5段階成熟度用 | — |
| `ratio-card(value, label, ...)` | 比率表示 | — |
| `qr-box(label, size)` | QR プレースホルダ（▦ 記号） | 実 QR ではない |
| `flow-arrow(direction, compact)` | ステップ間矢印 | down / right |

**tone システム:** `tone-stroke` / `tone-fill` で枠色・背景色をペアリング。`default` は neutral 面、`primary` 等は semantic 色の薄い fill + 濃い stroke。

**bounded:** 固定高さ + clip で文字溢れを防ぐ。フォントのインク欠け対策で上下 pad を入れている。

### `layouts.typ` — スライド構造

#### Templates（枚管理）

| 関数 | 用途 |
| --- | --- |
| `deck(slides, show-slide-no, hide-slide-no)` | スライド列をページ区切り。右下に `n / total` |
| `slide-frame(body, title, subtitle)` | 標準スライド枠（見出し + サブタイトル + 本文） |

`deck` の実装メモ:

- 各スライドを `block(breakable: false)` で囲み、番号は `place(bottom + right)` で重ねる
- 全面背景パターンは `set page` 不可のため `place` でフルブリード

#### Recipes（中間層 — 件数可変）

| 関数 | 用途 |
| --- | --- |
| `content-slide` | 自由配置（`slide-frame` の別名・意図の明示） |
| `list-slide` | 箇条書き中心 |
| `cards-slide` | N 枚カード（列数・高さは自動推定可） |
| `columns-slide` | N カラム（任意セル） |
| `figure-slide` | 画像1枚 + 任意キャプション |
| `figures-slide` | 枠付きスクショ複数 |
| `stack-slide` | 縦積み（prose / image / caption） |
| `callouts-slide` | callout 縦並び |
| `steps-slide` | 手順（縦は `steps-pattern` 委譲、横は件数可変） |

#### Organisms（レイアウトパターン — 固定構造）

`main.typ` に載っている全パターン:

| パターン | 意図 | 主な引数・備考 |
| --- | --- | --- |
| `title-pattern` | 表紙 | `aside` で右側にロゴ等 |
| `section-pattern` | 章開始 | 中央配置 |
| `closing-pattern` | 締め | 中央 + accent カード |
| `toc-pattern` | 目次 | `image` で2カラム可 |
| `summary-pattern` | 章まとめ | success callout 縦積み |
| `compare-pattern` | Before/After | 左 `danger`、右 `success` が既定。`visual` / `visual-height` で下に図を追加可 |
| `contrast-conclusion-pattern` | 対比 + 結論 | 下に conclusion callout |
| `text-image-pattern` | テキスト + 画像 | `reverse` で左右反転 |
| `card-row-pattern` | N カラムカード | `cols`, `cell-height` |
| `five-level-pattern` | 5段階成熟度 | 5列固定 |
| `steps-pattern` | 縦ステップ | 4件以上で自動タイト |
| `horizontal-steps-pattern` | 横4ステップ | **4件固定**（`steps.at(3)` 必須） |
| `timeline-pattern` | 時系列 | `(年, タイトル, 説明)` のタプル |
| `icon-list-pattern` | アイコン付きリスト | `(タイトル, 本文, kind)` |
| `glass-pattern` | 半透明パネル | 中央配置 |
| `gradient-panel-pattern` | 3パネル濃淡 | primary / info / accent |
| `full-image-pattern` | 全面背景画像 | overlay 60% 黒 |
| `side-image-pattern` | 右半分背景 | 左48%にテキスト |
| `quote-pattern` | 引用 | `by` で出典 |
| `split-visual-pattern` | 主従2画像 | 左大・右小 |
| `stats-pattern` | 3数値強調 | 左1つ hero、右2つ通常 |
| `center-message-pattern` | 中央メッセージ | 他要素なし |
| `qa-pattern` | Q&A 連絡先 | 3カラム flat-card |
| `qr-pattern` | QR 誘導 | プレースホルダ QR |
| `question-pattern` | 問いかけ | primary 全面 |
| `ratio-pattern` | 比率 | `cols: 2` で2+1 レイアウト |
| `mixed-pattern` | 数値 + 説明 | metric + card |
| `stacked-summary-pattern` | 縦積みまとめ | summary と類似 |

#### 低レベルヘルパ

| 関数 | 用途 |
| --- | --- |
| `grid-columns(cols)` | 1/2/3/4/5 列の fr 定義 |
| `grid-cards(cards, cols, gap, cell-height)` | カードグリッド。`cell-height` で等高 clip |

---

## 制約一覧（`limits` + style-guide）

| 対象 | 上限 |
| --- | --- |
| 1スライド本文 | 120〜180文字（目安） |
| 1スライド要素数 | 6 |
| 1カラム bullet | 3 |
| カードタイトル | 2行、1行16文字目安 |
| カード本文 | 3行または60文字 |
| テキスト最大幅 | 65%（背景画像スライド） |
| アイコン | 24 / 32 / 48 pt |

カード高さの既定:

| トークン | 値 | 使われ方 |
| --- | --- | --- |
| `card_height_sm` | 108pt | 4列、5段階 |
| `card_height_md` | 146pt | 3列既定 |
| `card_height_lg` | 192pt | 2列 |
| `card_height_image` | 192pt | 画像付きカード |

---

## カスタマイズの入口

| やりたいこと | 触るファイル |
| --- | --- |
| 色・フォント・ページサイズ | `style.typ` |
| 新しい部品（カード variants 等） | `components.typ` |
| 新しいスライド型 | `layouts.typ` → `main.typ` に例を追加 |
| 1枚だけ自由レイアウト | `slide-frame(...)` 内に `card` / `grid-cards` を直接書く（discord-bot が例） |
| ブランドフォント（Manrope / Inter） | `style.typ` の `fonts` を差し替え |

**推奨しない:** `main.typ` や各デッキに `#box` / `#grid` を直接書き続けること。パターン化できないか先に検討してください。

---

## 既知のギャップ・注意点

テンプレートに「納得がいかない」と感じるとき、以下が原因になりやすい点です。

### 1. ドキュメントと実装の不一致

| 記載 | 実態 |
| --- | --- |
| 「Touying + Metropolis」 | 未使用。純 Typst |
| ルート README の `_template/style.typ` 等 | 実体は `template/` 配下 |
| `@preview/touying` のネットワーク要件 | 現行ビルドでは不要 |
| `link_url` | 正しくは `link-url`（ハイフン） |

### 2. パターンの硬さ

- `horizontal-steps-pattern` は **4ステップ固定**。3ステップや5ステップにはそのまま使えない
- `stats-pattern` は **3指標固定**
- `five-level-pattern` は **5段階固定**
- `qa-pattern` は **3連絡先固定**
- 可変長リスト向けは `card-row-pattern` + `slide-frame` か `icon-list-pattern` / `steps-pattern`

### 3. QR コード

`qr-box` は Typst ネイティブ QR ではなく **▦ 記号のプレースホルダ**です。実 QR が必要なら SVG や外部画像を差し込む必要があります。

### 4. 画像アセット

`main.typ` は `assets/1.png` 等を参照しますが、リポジトリには `assets/svg/.gitkeep` のみ。カタログをそのままビルドするには画像を用意するか、パスを差し替えてください。

### 5. 二重の mise 設定

- ルート `mise.toml`: `mise run build <dir>`（`<dir>/<dir>.typ` 規約）
- `template/mise.toml`: `main.typ` 直ビルド

用途に応じてどちらを使うか決めてください。

### 6. typst package としての宣言

`template/typst.toml` は `typst-workshop-slides` パッケージを宣言していますが、リポジトリ内の他デッキは `#import "../template/..."` で相対参照しています。公開パッケージとして使う想定と、モノレポ内共有の想定が混在しています。

---

## 改修を検討するときの論点

テンプレートを変える前に、どこに不満があるかを切り分けると進めやすいです。

| 不満の種類 | 検討方向 |
| --- | --- |
| 色・フォントが好みでない | `style.typ` の tokens 変更（影響範囲大） |
| パターンが足りない | `layouts.typ` に追加 + `main.typ` カタログ更新 |
| パターンが硬い（固定件数） | 可変長版パターンの新設 |
| Touying ベースにしたい | 全面刷新（現アーキテクチャと両立しにくい） |
| 自由度が低い | `slide-frame` 直書きを公式に許容するか、中間パターンを増やす |
| カタログが多すぎて選びにくい | `main-minimal.typ` を軸に、用途別サブセットを作る |

---

## クイックリファレンス

### 最小デッキ

```typst
#import "style.typ": apply-theme, limits, theme
#import "components.typ": *
#import "layouts.typ": *

#show: apply-theme

#deck((
  title-pattern([タイトル], [サブタイトル], [組織 / 氏名]),
  compare-pattern(
    [比較],
    [Before], ([点1], [点2]),
    [After], ([点1], [点2]),
  ),
  closing-pattern([おわりに], [連絡先]),
))
```

### スライド番号

```typst
#deck(( ... ), show-slide-no: false)           // 全体非表示
#deck(( ... ), hide-slide-no: (1, 5))         // 1枚目と5枚目だけ非表示
```

### 外部リンク

```typst
#link-url("https://example.com", [表示名])
```

---

## 関連コマンド

```bash
# template カタログをビルド
cd template && mise trust && mise run build

# リポジトリ規約で discord-bot をビルド
mise run build discord-bot

# 全デッキ検証（mise.toml の depends 設定に依存）
mise run check
```

前提: Typst CLI、フォント `Noto Sans CJK JP` / `Noto Sans Mono CJK JP`。
