---
name: typst-style
description: Typst workshop slidesを、docs/style-guide.mdとtemplateの部品に沿って整える。（デザイン方針はimpeccable/layoutを主に参照）
---

# typst-style

Typst/Touying スライドの見た目と文体を統一するためのスキル。

## 位置づけ

**デザインの主導は `.agents/skills/impeccable`・`layout` など**に任せ、このスキルは **既に決まった方針を `docs/style-guide.md` と `template/` の部品へ落とす**ところまでを扱う。階層・余白・トーンの議論がまだのときは、先にそちらを読む。

## 参照ファイル

| ファイル | 用途 |
| --- | --- |
| `docs/style-guide.md` | 色、文体、レイアウト判断 |
| `template/main.typ` | レイアウトパターンの実例 |
| `template/components.typ` | パネル、統計、リンクなどの部品 |
| `template/layouts.typ` | 比較、カード、セクション開始などの配置 |

## 手順

1. 対象スライドの目的を確認する
2. `template/main.typ` から近いパターンを選ぶ
3. 可能な限り `template/layouts.typ` の関数へ寄せる
4. 文体を `docs/style-guide.md` に合わせる
5. `mise run build` または `mise run check` でビルド確認する

## 判断ルール

- タイトルにコロンを使わない
- 感嘆符、疑問符、装飾的な絵文字を使わない
- 1スライドで扱う主題を1つにする
- 1スライドの本文は120から180文字まで、要素は最大6個までにする
- カードタイトルは最大2行、本文は最大3行または60文字までにする
- 1カラムのbulletは最大3個までにする
- 5項目以上の縦リストは、2カラム化か分割を検討する
- 比較差分は `danger` / `success`、注意は `warning`、補足は `info` を使う
- アクセントカラーは1スライド1箇所までを基本にする
- 背景画像には必ずoverlayを置き、テキスト幅を60%以下にする
- Grid系は `cols` と `cell-height` で固定し、カード高さをautoに任せない

## 依頼例

```text
.agents/skills/typst-style を使って、template/main.typ の比較スライドを compare レイアウトに寄せて
```
