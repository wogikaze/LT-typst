#import "style.typ": apply-theme, theme, limits
#import "components.typ": *
#import "layouts.typ": *

#show: apply-theme

// 全パターンではなく、よく使う導線だけを並べた最小デッキ（講義・Fork 用）
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
  steps-pattern(
    [手順],
    (
      ([Step 1], [最初にやること]),
      ([Step 2], [次にやること]),
      ([Step 3], [最後に確認すること]),
    ),
  ),
  closing-pattern(
    [おわりに],
    [資料URL・連絡先・次のアクション],
  ),
))
