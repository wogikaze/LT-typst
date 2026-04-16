---
url: https://qiita.com/hirokidaichi/items/243bd176b84900f4cc0d#1-tailwind-css%E3%81%A7%E8%87%AA%E7%94%B1%E3%81%AA%E3%83%AC%E3%82%A4%E3%82%A2%E3%82%A6%E3%83%88%E3%82%92%E6%89%8B%E3%81%AB%E5%85%A5%E3%82%8C%E3%82%8B
title: "AIエージェントと協働してmarpでスライドを作る2026 #ClaudeCode - Qiita"
date: 2026-04-15T09:38:06.678Z
lang: ja
---

# AI Agent Slide Workflow Notes

Qiita記事の考え方を、Typst/Touying 用に要約した参照メモです。本文を丸写しせず、このリポジトリで使う実践項目だけに落とし込んでいます。

## 移植した考え方

- スタイルガイドを先に作る
- レイアウトパターンをサンプルとして持つ
- エージェント向けスキルで作業手順を固定する
- コードの正しさだけでなくPDFの見た目を確認する
- 画像やSVG図解はスライドの色とトーンに合わせる

## Typst版での対応

| Qiita記事の要素 | このリポジトリの対応 |
| --- | --- |
| デザインの方向性・レイアウト意図 | `.agents/skills/impeccable`、`layout` など（`.agents/skills/README.md` 参照） |
| `docs/style-guide.md` | `docs/style-guide.md` |
| `slides/example.md` | `template/main.typ` のパターン呼び出し |
| `slide-style-rector` | `.agents/skills/typst-style`（スタイルガイドと template への実装） |
| `layout-fix` | 構図は `layout` / `impeccable`、PDF上の詰まり修正は `.agents/skills/typst-layout-check` |
| `svg-creator` | `.agents/skills/typst-svg` |
| `scripts/build.sh` | `mise.toml` の `build` タスク |
| `scripts/watch.sh` | `mise.toml` の `watch` タスク |

## 作業時の原則

1. デザイン判断は impeccable 系を主とし、Typst 実装は `typst-*` スキルで補う（`.agents/skills/README.md`）
2. まず近いパターンを選ぶ
3. 独自レイアウトを増やす前に、既存関数の引数で表現する
4. 1スライドの情報量を増やしすぎない
5. `mise run check` でPDF生成まで確認する
6. 見た目の問題は、文字縮小より分割と再配置を優先する
