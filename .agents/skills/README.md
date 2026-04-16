# Agent skills（このリポジトリ）

スキルは次の二層に分けます。**見た目の方針・レイアウトの意図は ① を主**とし、**Typst のテンプレート・ビルド・図解の手順は ②** に任せます。

## ① デザイン（主）

`skills-lock.json` 由来の **pbakaus/impeccable** ファミリーです。スライドでも Web でも、まずここで「誰向けか・何を伝えるか・空間と階層」を決めます。

**Typst → PDF のスライド**では、Web 向けの文言をそのまま当てはめず、**`impeccable/reference/typst-slides.md`** で同じ厳しさを Typst 用に読み替える（監査の 5 次元・採点・P0–P3 は同じ）。

| スキル | 役割の目安 |
| --- | --- |
| **impeccable** | 文脈収集、方向性、全体の品質基準。他スキルの前提になる |
| **layout** | 余白・リズム・視線・グリッド。スライドの「詰まり」の根本 |
| **delight** | 体験の細部・気持ちよさ |
| **bolder** / **quieter** | 強調の付け方・情報の静けさの調整 |
| **audit** | 一貫性チェック・抜けの洗い出し |

参照の深掘りは `impeccable/reference/`（タイポ、色、空間など）を使います。

## ② Typst 実装・講習向け（従）

リポジトリの **`template/`** と **`docs/style-guide.md`** に沿って、実装と検証を進めるときの手順書です。**① で決めた意図を、部品とトークンに落とす**用途に使います。

| スキル | 役割の目安 |
| --- | --- |
| **typst-style** | スタイルガイド・`template/components.typ` / `layouts.typ` への整形 |
| **typst-layout-check** | `mise run check`、PDF 上のはみ出し・過密の確認と修正 |
| **typst-svg** | スライド用 SVG の作成と組み込み |

## 推奨ワークフロー

1. デザインの文脈が足りなければ **impeccable** のプロトコルに従う（必要なら `layout` で構図を検討）。
2. 方針が固まったら **`docs/style-guide.md`** と既存パターンに沿って Typst を編集する。
3. コード・トークン・部品の揃え方は **typst-style**、仕上げの詰まり確認は **typst-layout-check**、図は **typst-svg**。

「デザインは impeccable 系、Typst への実装は `typst-*`」という分担をデフォルトにします。
