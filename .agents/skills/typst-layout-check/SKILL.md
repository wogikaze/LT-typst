---
name: typst-layout-check
description: Typstスライドをビルドし、PDF化したときの詰まり、はみ出し、過密を確認して修正する。（構図の意図はlayout/impeccableを主に参照）
---

# typst-layout-check

Typst/Touying スライドのレイアウト崩れを検出し、必要な修正を行うためのスキル。

## 位置づけ

**リズム・階層・余白の「どうあるべきか」は `.agents/skills/layout`・`impeccable` を主**にし、このスキルは **PDF 上の事実としての詰まり・はみ出しを直す**工程に特化する。情報量そのものの見直しが必要なときは、先にデザイン側スキルで分割や優先度を検討する。

## 前提

- `mise` が利用できる
- `typst` CLI が利用できる
- 初回の `@preview` package 取得にはネットワーク接続が必要

## 手順

1. `mise run check` で対象PDFを生成する
2. ビルドエラーがあれば、該当ファイルと行を確認して直す
3. PDFを確認し、下部切れ、横はみ出し、過密なパネルを探す
4. 修正は次の順で行う
   - 不要な文を削る
   - 2カラム化する
   - スライドを分割する
   - 余白やパネル数を調整する
   - 最後の手段として文字サイズを下げる
5. もう一度 `mise run check` を実行する

## よくある修正

- 縦5項目以上のリストは `compare` または `two_columns` へ移す
- 3つの観点は `three_cards` にする
- 数字の強調は `stats_row` と `stat` を使う
- コード例が長い場合は、説明とコードを別スライドに分ける

## 依頼例

```text
.agents/skills/typst-layout-check を使って、template/main.typ をビルドし、詰まりがあれば修正して
```
