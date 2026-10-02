# Typst Workshop Template

Atomic Design で組み立てる **16:9 講習会スライド**の Typst テンプレートです。

**詳細な現状整理（部品一覧・制約・既知のギャップ）は [docs/template-overview.md](../docs/template-overview.md) を参照してください。**

## 設計の要点

| ファイル | 役割 |
| --- | --- |
| `main.typ` | スライド本文。レイアウト関数の呼び出しのみ（全パターンカタログ） |
| `main-minimal.typ` | よく使う5パターンだけ（講義・Fork 向け） |
| `style.typ` | 色・フォント・余白・密度制約・`apply-theme` |
| `components.typ` | Atoms / Molecules（card, callout, metric 等） |
| `layouts.typ` | Organisms / Templates（`*-pattern`, `deck`） |

- 枚番号は `#deck(( ... ))` が右下に `n / 合計` を自動表示
- 見た目の数値の正（SSOT）は `style.typ`
- **Touying は使っていません**（純 Typst 自前テーマ）

## 使い方

```bash
mise trust
mise run build      # → build/main.pdf
mise run watch      # 監視ビルド
```

リポジトリルートから他デッキを作る場合は `_template/_template.typ` をコピーし、`<dir>/<dir>.typ` 規約に従って `mise run build <dir>` します（[ルート README](../README.md) 参照）。

## Atomic Design 対応

| 層 | 主な部品 |
| --- | --- |
| Atoms | `headline`, `label`, `prose`, `caption`, `chip`, `divider`, `number-badge` |
| Molecules | `card`, `callout`, `icon-callout`, `metric`, `step-item`, `image-card`, `code-card`, `quote-card` |
| Organisms | `compare-pattern`, `steps-pattern`, `timeline-pattern`, `stats-pattern`, `card-row-pattern` 等 |
| Templates | `deck`, `slide-frame`, `full-image-pattern`, `side-image-pattern` |

全30パターンの一覧・引数・固定件数の制約は [template-overview.md](../docs/template-overview.md#organismsレイアウトパターン) にまとめています。

## 制約（要約）

- カードタイトル最大2行、本文最大3行または60文字
- 1カラム bullet 最大3個、1スライド要素最大6個
- Grid 系は `cols` と `cell-height` で固定
- Before/After は `danger` / `success`
- 背景画像は overlay 必須、テキスト幅 65% 以下

詳細は [docs/style-guide.md](../docs/style-guide.md)。

## 書き方

**定番（表紙・比較・章）** → `*-pattern`  
**件数が毎回違う（カード・画像・手順）** → `*-slide`（[slide-recipes.md](../docs/slide-recipes.md)）  
**1枚だけ特殊** → `content-slide` または `slide-frame`

```typst
#import "style.typ": apply-theme, limits, theme
#import "components.typ": *
#import "layouts.typ": *

#show: apply-theme

#deck((
  title-pattern([タイトル], [サブタイトル], [組織 / 氏名]),
  // ...
))
```

- 外部リンク: `#link-url("URL", [表示名])`
- 比較: `#compare-pattern(...)`
- 3観点: `#card-row-pattern(..., cols: 3)`
- 手順: `#steps-pattern(...)` または `#horizontal-steps-pattern(...)`（後者は4件固定）
- サブタイトル: `subtitle: [...]`、`subtitle: none` で非表示
- `text-image-pattern` のみ `show-subtitle: false` も可
- **main.typ に独自装飾を直接書かず**、必要な表現は `components.typ` または `layouts.typ` へ追加

## スライド番号

```typst
#deck(( ... ))                              // 既定: 右下 n / total
#deck(( ... ), show-slide-no: false)        // 全体非表示
#deck(( ... ), hide-slide-no: (1, 5))       // 特定枚のみ非表示（1始まり）
```

## カスタマイズ

| 目的 | ファイル |
| --- | --- |
| 色・フォント・ページ | `style.typ` |
| 部品追加 | `components.typ` |
| レイアウト追加 | `layouts.typ` + `main.typ` に例 |
| 1枚自由配置 | `#slide-frame([...])` 内に部品を組む（[discord-bot](../discord-bot/discord-bot.typ) 参照） |

## 関連ドキュメント

- [docs/template-overview.md](../docs/template-overview.md) — テンプレート現状の全体像
- [docs/slide-recipes.md](../docs/slide-recipes.md) — **中間層（自由度と覚えやすさ）**
- [docs/style-guide.md](../docs/style-guide.md) — デザイン判断
- [DESIGN.md](../DESIGN.md) — ブランドカラー要約
