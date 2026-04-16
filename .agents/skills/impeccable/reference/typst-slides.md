# Typst / PDF スライド向けの適用（Web スキルの対応表）

Impeccable 系スキルはもともと **ブラウザ UI** を想定している。この文書は **厳しさ（0–4 採点・P0–P3・報告構造）を変えず**、対象を **Typst で PDF 化するスライド** に置き換えるときの **検査内容の定義** である。

**単一の実装ソース**: 色・サイズ・余白の数値は `template/style.typ` を正とする。`docs/style-guide.md` と `DESIGN.md` はそれに従う説明用である。

---

## Context Gathering Protocol（Typst でも同じ）

次はコードからは推測できない。必ず作成者から取る。

- **対象聴衆**: 誰が、どこでこの PDF を見るか（投影、配布、自習）
- **用途**: 何を達成させるスライドか
- **トーン**: 堅さ、遊び、余白の好み

---

## /audit → Typst Slide Diagnostic（5 次元・各 0–4）

Web 向けの節（ARIA、バンドルなど）は **Typst プロジェクトではスキップ**し、代わりに以下を同じ採点基準で使う。レポートの表・総合点・P0–P3 の付け方は Web 版と同一。

### 1. Accessibility → **可読性・知覚可能性（PDF / 投影）**

**Check for**:

- **コントラスト**: 本文／見出し／薄色（キャプション、スライド番号）と背景の組み合わせ。投影環境では画面より厳しく感じられる前提で疑う。
- **文字サイズ**: 本文が小さすぎないか（スケールは `style.typ` の `sizes` に対照）。
- **情報の階層**: `heading` / `slide-frame` のタイトル／サブタイトルが論理的か（HTML の見出しレベルに相当）。
- **図表**: 画像・SVG に意味のある説明が近接しているか（スクリーンリーダーは PDF では限定的だが、講義用には「何の図か」がテキストで追えるか）。
- **色だけに依存しない伝え方**: 意味色（success / danger 等）に加え、位置・ラベルで区別できるか。

**Score 0–4**: Web の定義と同じトーンで、**印刷・投影での読みやすさ**に置き換えて評価する。

### 2. Performance → **ビルド・資産・複雑さ**

**Check for**:

- **コンパイル**: 不要に重い import、巨大な単一ファイル、全パターンを無秩序に並べたデッキ。
- **画像**: 解像度の無駄、未使用アセット。
- **レイアウト計算**: 過度にネストした `grid`／無制限の `box` 連鎖（保守性と再コンパイルコスト）。
- **依存**: 不要なパッケージ参照。

**Score 0–4**: ランタイム JS は無いので、「**ビルドとメンテの軽さ**」で評価する。

### 3. Theming → **トークンと一貫性（変わらず厳密）**

**Check for**:

- **`style.typ` の `colors` / `theme` 外の直書き**（`rgb("#...")` が layouts に散らばっていないか）。
- **ドキュメント間の色の食い違い**（`DESIGN.md` / スキル / `style-guide` vs 実装）。
- **意味トークン**（primary / accent / semantic）の誤用や混在。

**Score 0–4**: Web 版と同じ。ダークモードの代わりに **「別テーマ差し替え時に追従できるか」** を見る。

### 4. Responsive → **固定キャンバス上の適応**

**Check for**:

- **1 枚の中でのオーバーフロー**: 固定ページ高で本文がクリップされていないか。
- **安全域**: マージン外への `place`、極端な全幅テキスト。
- **可変ではないことの自覚**: 16:9 以外への出力が必要なら、別アスペクト用のトークン分岐があるか。

**Score 0–4**: 「モバイル対応」の代わりに **「与えられた 1 ページ内で破綻していないか」** で評価。意図的な固定サイズは減点しない。

### 5. Anti-Patterns → **スライド特有の凡庸さ・テンプレ臭**

**Check for**:

- 同型カードの無限反復、意味のないアクセントの羅列。
- サンプルデッキが **意図せず**「部品カタログの羅列」に見えるか（目的がカタログなら文脈で許容と明記）。
- グラデーションや装飾が **意味** を持たない場合。
- 文体・トークンを無視した one-off の `box` だらけ。

**Score 0–4**: Web の「AI slop」と同じ厳しさで、**スライド界隈の凡庸な見本**に対して評価する。

---

## /layout（Typst）

Web の「余白・リズム・階層」の判断はそのまま有効。対象を次に読み替える。

- **Spacing** → `space.*`、`panel-inset`、`par(leading)`、カード間の `v()`。
- **Visual hierarchy** → `sizes.*`、タイトル／サブタイトル／本文の役割、`card` と `slide-frame` の使い分け。
- **Grid & structure** → `grid-cards`、`cols`、`cell-height`、`bounded` によるクリップ。
- **Density** → `docs/style-guide.md` の密度上限と、実際の文字量。

空間デザインの原則は `spatial-design.md` を参照しつつ、**実装は `template/layouts.typ` と `limits`** に落ちているかを確認する。

---

## /delight / /bolder / /quieter（Typst）

- **delight**: アニメーションの代わりに、**余白・区切り・1 枚 1 メッセージ**、図解の「一度で伝わるか」。
- **bolder**: `sizes.display`、アクセント 1 箇所、コントラストは `style-guide` 内で。
- **quieter**: 色数の削減、サブタイトル省略、`theme.slide_no` のような補助情報の控えめさ。

---

## 推奨コマンドの対応（Typst 作業）

スキル末尾の `/colorize` 等は、Typst では次のような **実作業** に読み替える。

| コマンド | Typst での意味の例 |
| --- | --- |
| /colorize | `style.typ` の `colors` / `theme` を直し、ドキュメントと一致させる |
| /clarify | `DESIGN.md` と `style-guide` に「正は style.typ」と明記 |
| /layout | `layouts.typ` の直書き色をトークン化、`cell-height` と分割の整理 |
| /distill | 全パターンカタログ用と最小デッキ用でファイルを分ける、または枚数削減 |
| /polish | 薄色テキストのコントラスト、見出し行間、サブタイトルの有無 |
| /audit | 上記 Typst Slide Diagnostic で再採点 |

---

## 報告フォーマット

Web 版の **Audit Health Score 表・Executive Summary・Detailed Findings** をそのまま使う。カテゴリ名は **Accessibility / Performance / Theming / Responsive / Anti-Pattern** のままでよい（Typst では中身が上記の通り読み替わる）。
