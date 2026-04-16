# Typst Workshop Template

Atomic Design の原則で組み立てる Typst 講習会スライド雛形です。`main.typ` は完成スライドの呼び出しだけを持ち、見た目の判断は `style.typ`、部品は `components.typ`、スライド構造は `layouts.typ` に分けています。

## 使い方

```bash
mise trust
mise run build
```

監視ビルド:

```bash
mise run watch
```

## 主なファイル

- `main.typ`: 全レイアウトのサンプル（カタログ）
- `main-minimal.typ`: よく使うパターンだけの短い例（講義・Fork 向け）
- いずれも `deck` にパターン呼び出しを並べる（枚番号は `deck` が右下に自動表示）
- `style.typ`: デザイントークン、ページ設定、グローバル show rules
- `components.typ`: Atomic Design の Atoms / Molecules
- `layouts.typ`: Atomic Design の Organisms / Templates
- `mise.toml`: ビルド、監視、クリーンアップタスク

## Atomic Design の対応

- Atoms: `headline`, `label`, `prose`, `caption`, `chip`, `divider`, `number-badge`, `icon-badge`
- Molecules: `card`, `callout`, `icon-callout`, `metric`, `step-item`, `image-card`, `code-card`, `quote-card`
- Organisms: `title-pattern`, `toc-pattern`, `compare-pattern`, `steps-pattern`, `timeline-pattern`, `stats-pattern`
- Templates: `deck`, `slide-frame`

## 制約

- カードタイトルは最大2行、本文は最大3行または60文字
- 1カラムのbulletは最大3個
- Grid系は `cols` と `cell-height` で固定する
- Before/Afterは `danger` / `success` を使う
- 背景画像はoverlay必須、テキスト幅60%以下

## 書き方

- 外部リンクは `#link-url("URL", [表示名])` を使う
- 3つの観点は `#card-row-pattern(..., cols: 3)` を使う
- 比較は `#compare-pattern(...)` を使う
- 手順は `#steps-pattern(...)` または `#horizontal-steps-pattern(...)` を使う
- パターン付属のサブタイトルは `subtitle: [...]` で差し替え可能。行を消すときは `subtitle: none`
- `text-image-pattern` だけサブタイトル非表示は `show-subtitle: false`（`reverse` に応じた既定文を使わないとき）
- `main.typ` に独自の装飾を直接書かず、必要な表現は `components.typ` または `layouts.typ` に追加する

## スライド番号

- 既定: `#deck(( ... ))` で各スライド右下に `n / 合計`（薄い色）を重ねる
- 全体で非表示: `#deck(( ... ), show-slide-no: false)`
- 特定の枚だけ非表示: `#deck(( ... ), hide-slide-no: (1, 5))`（1 始まりの番号）
