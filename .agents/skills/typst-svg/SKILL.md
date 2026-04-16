---
name: typst-svg
description: Typstスライドに合うSVG図解を作成し、スライドへ組み込む。（図の情報設計はimpeccable/layoutを主に参照）
---

# typst-svg

Typstスライドに挿入するSVG図解を作るためのスキル。

## 位置づけ

**図が伝えるべきメッセージや視線の流れは `.agents/skills/impeccable`・`layout` を主**に決め、このスキルは **パレットに沿った SVG の作成と Typst への埋め込み**を扱う。

## 保存先

- 共通テンプレート用: `template/assets/svg/`
- サンプル用: `examples/assets/svg/`
- 新しいデッキ用: そのデッキ配下の `assets/svg/`

## 図解スタイル

- 横長のスライド内で使いやすい比率にする
- 背景は白または透明を基本にする
- 色は `docs/style-guide.md` のパレットに合わせる
- 文字量を減らし、ラベルは短くする
- 装飾より構造の分かりやすさを優先する

## カラーパレット

`template/style.typ` の `colors` / `theme` に合わせる（ここに独自色を増やさない）。

- Primary: `#2C2A4A`
- Accent: `#B89B4F`
- Surface / 背景: `#DADAD8`, カード面 `#EFEEEC`
- 本文: `#2B2F3A`、補足: `#5A6070`
- 境界: `#C8C8C5`
- Success / Warning / Danger / Info: `#3A7D44` / `#C78B2A` / `#B94A48` / `#3A6EA5`

## 手順

1. 図解の目的を1文で決める
2. 図の要素を3から5個に絞る
3. SVGを作成する
4. Typst側で `#image("assets/svg/name.svg")` として挿入する
5. `mise run build` で確認する

## 依頼例

```text
.agents/skills/typst-svg を使って、Typstのコンパイルフローを示すSVGを作り、template/main.typ に挿入して
```
