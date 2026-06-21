#import "style.typ": apply-theme, theme, limits
#import "components.typ": *
#import "layouts.typ": *

#show: apply-theme

// よく使う導線: Patterns（定番） + Recipes（件数可変）の混在例
// Recipes の詳細: docs/slide-recipes.md
#deck((
  title-pattern(
    [講習タイトル],
    [1行のサブタイトル],
    [組織名 / 氏名],
  ),
  section-pattern(
    [セクション],
    [この章で扱うことを一文で],
  ),
  compare-pattern(
    [Before と After],
    [Before],
    (
      [旧い点1],
      [旧い点2],
    ),
    [After],
    (
      [新しい点1],
      [新しい点2],
    ),
  ),
  cards-slide(
    [3つの観点],
    (
      stretchcard([観点A], [#compact-list(([要点1], [要点2]))]),
      stretchcard([観点B], [#compact-list(([要点1], [要点2]))], tone: "accent"),
      stretchcard([観点C], [#compact-list(([要点1], [要点2]))], tone: "info"),
    ),
    subtitle: [card-row-pattern の代わりに列数自動],
  ),
  steps-slide(
    [手順],
    (
      ([Step 1], [最初にやること]),
      ([Step 2], [次にやること]),
      ([Step 3], [最後に確認すること]),
    ),
  ),
  list-slide(
    [今日の持ち物],
    ([PC], [Discord アカウント], [メモ用紙]),
    subtitle: [箇条書きだけのスライド],
  ),
  closing-pattern(
    [おわりに],
    [資料URL・連絡先・次のアクション],
  ),
))
