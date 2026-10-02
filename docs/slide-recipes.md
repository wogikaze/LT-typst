# Slide Recipes — 中間層ガイド

テンプレートには **3段階** の書き方があります。多くのスライドは真ん中の **Recipes** だけ覚えれば足ります。

```text
Tier 1  Patterns     compare-pattern, title-pattern …  意味が決まっている定番
Tier 2  Recipes      cards-slide, figure-slide …         件数可変・組み合わせ自由
Tier 3  Escape       slide-frame([ ... ])                1枚だけ特殊
```

**困りごとの対応:**

| 感じること | 使う層 |
| --- | --- |
| パターンの件数が合わない（3ステップなのに横型は4固定） | Recipes |
| カード枚数や画像枚数が毎回違う | Recipes |
| 比較・表紙・章開始など型がはっきりしている | Patterns |
| レイアウト以前に内容そのものが特殊（uiua のような実験スライド） | Escape |

---

## 覚える関数（Recipes は8個）

| 関数 | いつ使う | 件数 |
| --- | --- | --- |
| `content-slide` | 自由配置（Escape の入口） | — |
| `list-slide` | 箇条書き中心 | bullet 可変 |
| `cards-slide` | カードを N 枚並べる | 可変 |
| `columns-slide` | カード以外も含め N カラム | 可変 |
| `figure-slide` | 画像・スクショ 1 枚 | 1 |
| `figures-slide` | スクショ複数（講義キャプチャ向け） | 可変 |
| `stack-slide` | 縦に段落・画像を積む | 可変 |
| `callouts-slide` | 注意・補足を縦に並べる | 可変 |
| `steps-slide` | 手順（縦/横、件数可変） | 可変 |

Patterns は必要になったときだけ [template-overview.md](./template-overview.md) から選びます。

---

## 選び方（フローチャート）

```text
表紙・目次・章・Before/After の定番？
  → Tier 1 *-pattern

カードや画像の「枚数」が資料ごとに違う？
  → Tier 2 *-slide

上記で無理な 1 枚だけ？
  → Tier 3 content-slide または slide-frame
```

---

## 例

### カード 2〜6 枚（`card-row-pattern` の代わり）

```typst
#cards-slide(
  [そろえるもの],
  (
    stretchcard([実行環境], [#compact-list(([Python], [ターミナル]))]),
    stretchcard([アカウント], [#compact-list(([Discord],))]),
    stretchcard([エディタ], [#compact-list(([VSCode],))]),
  ),
  subtitle: [不足があれば先に用意する],
)
```

`cols` を省略すると枚数から列数を推定します。カードは **`stretchcard(...)`** を使う（`card` ではなく）。`stretchcard` は描画せず `(title, body, tone)` の仕様を返し、`cards-slide` が **table の cell** として描画する。行内で最長カードに高さが揃い、短いカードは cell の `fill` で背景まで伸びる（`cell-height: auto` が既定）。スライド下端まで伸びない。

固定高で切りたいときは `cell-height: limits.card_height_md` のように指定します（この場合のみ grid + clip）。

カード内の箇条書きは **`compact-list(...)`**（または `bullet-list(..., compact: true)`）を使うと行間が詰まり、狭い列でも書きやすいです。`stretchcard` 内では `table-card-cell` が list の余白も自動調整します。

Typst 注意: コンテンツブロック内で変数を埋め込むときは `[#x]` と書く。`[c]` は文字の「c」になる。

### スクショ 2 枚（discord-bot でよくある形）

**Before（ボイラープレート多い）:**

```typst
#slide-frame([
  #grid(
    columns: (1fr, 1fr),
    ...
    #box(stroke: ..., inset: 10pt, clip: true)[#image(...)]
  )
], title: [...])
```

**After:**

```typst
#figures-slide(
  [Developer Portal — アプリケーションを作成],
  ("assets/a.png", "assets/b.png"),
  subtitle: [ログインとアプリ作成],
  height: 200pt,
)
```

### 箇条書きだけ

```typst
#list-slide(
  [今日やること],
  ([環境構築], [Bot 作成], [動作確認]),
  subtitle: none,
)
```

### 縦に prose + 画像（uiua 向け）

```typst
#stack-slide(
  [奇妙さ その1],
  (
    prose([Uiuaは記号まみれの言語で…]),
    image("assets/2.png", width: 100%),
    caption([↑フォーマットすると記号になる]),
  ),
)
```

### 手順 3 ステップ（横並び、件数可変）

```typst
#steps-slide(
  [開発の流れ],
  (
    ([Portal], [アプリと Bot を作る]),
    ([環境], [clone して依存関係]),
    ([確認], [招待 URL で導入]),
  ),
  horizontal: true,
)
```

`horizontal-steps-pattern` は **4 件固定** ですが、`steps-slide(..., horizontal: true)` は 2 件以上なら可変です。

### 1 枚だけ自由

```typst
#content-slide(
  [タイトル],
  [
    #align(center)[
      #prose([中央メッセージ])
      #v(space.lg)
      #chip([NEW])
    ]
  ],
  subtitle: none,
)
```

`content-slide` は `slide-frame` と同じですが、「パターンでもレシピでもない」と明示できます。

---

## Tier 1 vs Tier 2 の使い分け

| 状況 | Pattern | Recipe |
| --- | --- | --- |
| Before / After 比較 | `compare-pattern` ✓ | 無理に `cards-slide` しない |
| 縦 3 ステップ + 矢印 | `steps-pattern` ✓ | 同じ（Recipe は内部で委譲） |
| 横 4 ステップ固定 | `horizontal-steps-pattern` | — |
| 横 2〜5 ステップ | — | `steps-slide(..., horizontal: true)` ✓ |
| 3 カード紹介 | `card-row-pattern` でも可 | `cards-slide` ✓（列数自動） |
| 2 枚スクショ | — | `figures-slide` ✓ |
| 統計 3 指標 | `stats-pattern` | 将来可変版を検討 |

---

## 部品は3つだけ意識する

Recipes でも中身は次の部品を組み合わせるだけです。

| 部品 | 用途 |
| --- | --- |
| `card(title, body, tone: ...)` | 囲み付きブロック |
| `bullet-list((...))` | 箇条書き |
| `callout(title, body, kind: ...)` | 左線付き強調 |
| `screenshot(path, height: ...)` | 枠付きスクショ（新規） |

`grid-cards` / `limits.card_height_*` / `space.lg` は **Recipes が内部で面倒を見ます**。直書きするときだけ意識してください。

---

## よくある移行

### card-row-pattern → cards-slide

```typst
// 旧
#card-row-pattern([タイトル], (card(...), card(...), card(...)), cols: 3, cell-height: limits.card_height_md)

// 新（列数・高さは自動）
#cards-slide([タイトル], (card(...), card(...), card(...)))
```

### slide-frame + grid + box + image → figures-slide

discord-bot の `slide-frame` + 2 列 `grid` + 枠付き `image` は `figures-slide` に置き換え可能です。

### slide-frame 裸 → content-slide

中身が prose と image の積み上げなら `stack-slide`、1 枚画像なら `figure-slide` を先に検討します。

---

## 関連

- [template-overview.md](./template-overview.md) — 全パターン一覧・制約
- [style-guide.md](./style-guide.md) — 密度・色のルール
- [discord-bot/discord-bot.typ](../discord-bot/discord-bot.typ) — Recipes に移行しやすい `slide-frame` 実例
