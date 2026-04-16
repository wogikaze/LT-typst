# Typst Slide Design System

**色・サイズ・余白の数値の正（単一ソース）は `template/style.typ`** の `colors` / `theme` / `sizes` / `limits` である。本書と `DESIGN.md` はその説明用。

このテンプレートは「自由に飾るための部品集」ではなく、講習会スライドを壊れにくく作るための設計システムです。新規スライドは `template/style.typ` のトークン、`template/components.typ` の部品、`template/layouts.typ` のレイアウト関数を優先して組みます。

## 原則

- 1スライド1メッセージにする
- レイアウトの自由度より、崩れない制約を優先する
- 色は装飾ではなく意味に使う
- 画像や背景は必ずコントラスト保証を入れる
- 要素数と文字量の上限を守る

## トークン

| 種別 | 用途 | 実装 |
| --- | --- | --- |
| `primary` | 構造、見出し、章 | `#2C2A4A` |
| `accent` | 強調、視線誘導 | `#B89B4F` |
| `neutral` | 背景、面 | `#DADAD8`, `#EFEEEC` |
| `success` | 良い状態、改善後 | `#3A7D44` |
| `warning` | 注意、補足警告 | `#C78B2A` |
| `danger` | 問題、Before、避けたい状態 | `#B94A48` |
| `info` | 補助情報 | `#3A6EA5` |

アクセントは1スライド1箇所までを基本にします。複数色を使う場合は、`success` / `warning` / `danger` のように意味が異なる場合だけ許可します。

## タイポグラフィ

| 階層 | 目安 | 実装 |
| --- | --- | --- |
| Display | 48から64pt | `sizes.display` |
| Title | 32から40pt | `sizes.title` |
| Section | 32pt前後 | `sizes.section` |
| Heading | 24から28pt | `sizes.heading` |
| Body | 17から20pt | `sizes.body` |
| Caption | 13から14pt | `sizes.caption` |

本文の行間は `leading.body`、余裕を持たせる箇所は `leading.loose` を使います。日本語の字間は `tracking.ja: 0pt` を明示し、詰めすぎや負の字間を避けます。

## 密度制約

| 対象 | 上限 |
| --- | --- |
| 1スライドの本文量 | 120から180文字 |
| 1スライドの要素数 | 最大6 |
| 1カラムのbullet | 最大3 |
| カードタイトル | 最大2行、1行12から16文字 |
| カード本文 | 最大3行または60文字 |
| アイコンサイズ | 24pt / 32pt / 48pt |

実装では `limits.card_height_*`、`limits.card_title_height`、`limits.card_body_height` で固定領域を持たせています。内容が収まらない場合は、文字サイズを下げる前に項目削減、2カラム化、別スライド化を行います。

## レイアウト選択

| 意図 | 使うパターン | 備考 |
| --- | --- | --- |
| 比較（差分） | `compare-pattern` | Beforeは`danger`、Afterは`success` |
| 比較（思想、結論付き） | `contrast-conclusion-pattern` | 2つを対比して最後に結論を置く |
| 数値強調 | `stats-pattern` | 最重要数値だけ大きく、非対称配置にする |
| メッセージ強調 | `center-message-pattern` | 空白で隔離し、他要素を置かない |
| 流れ | `steps-pattern`, `horizontal-steps-pattern` | 矢印を必ず入れる |
| 時系列 | `timeline-pattern` | 時期を線で接続する |
| 構造整理 | `card-row-pattern` | `cols` と `cell-height` で制約する |
| 背景画像 | `full-image-pattern`, `side-image-pattern` | overlay必須、テキスト幅60%以下 |

`p8` と `p22`、`p12` と `p13` のような違いは、別パターンではなく `cols`、`cell-height`、要素数のパラメータとして扱います。

## 視線誘導

- Gridは左上から始まるZパターンを基本にする
- 重要度が高い要素はサイズ、色、番号のいずれかで差をつける
- 2枚以上の画像は主情報を大きく、補助情報を小さくする
- 流れを表すスライドは番号または矢印を必須にする

## 背景画像

- 全面背景には黒40%または白60%相当のoverlayを必ず入れる
- テキスト最大幅は60%
- 文字色は白または黒に固定し、画像に応じて曖昧に変えない
- 背景画像の上に本文を長く置かない

## NG例

- 3カラムに4行以上の説明を入れる
- `accent` を複数箇所に使い、何が重要か曖昧にする
- Before/Afterをどちらもneutralで表現する
- 画像背景にoverlayなしで文字を置く
- カードの高さをautoに任せ、1枚だけ伸びる状態にする
- 4カラムに文章の段落を入れる

## Atomic Design上の責務

| 層 | ファイル | 責務 |
| --- | --- | --- |
| Tokens | `template/style.typ` | 色、サイズ、余白、密度制約 |
| Atoms | `template/components.typ` | テキスト、badge、divider、swatch |
| Molecules | `template/components.typ` | card、callout、metric、image-card |
| Organisms | `template/layouts.typ` | compare、grid、timeline、stats |
| Templates | `template/layouts.typ` | deck、slide-frame、背景画像スライド |

新しい見た目が必要な場合も、まず既存の層に追加できるかを確認します。スライド本文から直接 `box` や `grid` を組むのは最後の手段です。
