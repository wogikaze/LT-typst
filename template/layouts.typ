#import "style.typ": (
  colors, fonts, limits, page-height, page-margin-x, page-margin-y, page-width, panel-inset, radius, sizes, space,
  theme, tracking,
)
#import "components.typ": *

// Atomic Design: Templates
// show-slide-no: 右下に n / total を重ねる。hide-slide-no に 1 始まりの番号を入れるとその枚だけ非表示
#let deck(slides, show-slide-no: true, hide-slide-no: ()) = {
  let total = slides.len()
  let slide-no-hidden(n, hide-slide-no) = hide-slide-no.filter(it => it == n).len() > 0
  // スライド本体と番号を同一ブロックに閉じる。place だけが続くと不可視ブロックが次ページになる。
  // 全面系パターンは set page を使わず place でフルブリードする（block 内では set page 不可）。
  for (idx, slide) in slides.enumerate() [
    #let n = idx + 1
    #let show-no = show-slide-no and not slide-no-hidden(n, hide-slide-no)
    #block(width: 100%, height: 100%, breakable: false)[
      #slide
      #if show-no [
        #place(bottom + right, dx: -36pt, dy: -28pt)[
          #slide-no-footer(n, total)
        ]
      ]
    ]
    #if idx < total - 1 [#pagebreak()]
  ]
}

#let slide-frame(body, title: none, subtitle: none) = [
  #if title != none [
    #headline(title, size: sizes.title)
    #if subtitle != none and subtitle != [] [#v(space.xs)#prose(subtitle, muted: true)]
    #v(space.lg)
  ]
  #body
]

#let grid-columns(cols) = if cols == 1 {
  (1fr,)
} else if cols == 2 {
  (1fr, 1fr)
} else if cols == 4 {
  (1fr, 1fr, 1fr, 1fr)
} else if cols == 5 {
  (1fr, 1fr, 1fr, 1fr, 1fr)
} else {
  (1fr, 1fr, 1fr)
}

#let grid-cards(cards, cols: 3, gap: space.lg, cell-height: none) = {
  let cells = if cell-height == none {
    cards
  } else {
    cards.map(card => box(width: 100%, height: cell-height, clip: true, card))
  }

  grid(
    columns: grid-columns(cols),
    column-gutter: gap,
    row-gutter: space.md,
    align: top,
    ..cells,
  )
}

// Atomic Design: Organisms
#let title-pattern(title, subtitle, author, aside: none) = {
  let main = [
    #headline(title, size: sizes.display)
    #v(space.sm)
    #box(width: limits.text_max_width, prose(subtitle, muted: true, size: sizes.subheading))
    #v(space.lg)
    #line(length: 100%, stroke: (paint: theme.accent, thickness: 1.2pt))
    #v(space.md)
    #caption(author)
  ]
  if aside == none {
    align(left + horizon, main)
  } else {
    align(horizon)[
      #grid(
        columns: (1fr, auto),
        column-gutter: space.xl,
        align: horizon,
        align(left, main),
        align(right, aside),
      )
    ]
  }
}

#let section-pattern(title, body) = align(center + horizon)[
  #headline(title, size: sizes.hero)
  #v(space.md)
  #box(width: limits.text_max_width, align(center, prose(body, muted: true, size: sizes.subheading)))
]

#let closing-pattern(title, body, subtitle: [Contact]) = align(center + horizon)[
  #headline(title, size: sizes.hero)
  #v(space.lg)
  #box(width: 70%, card(subtitle, body, tone: "accent"))
]

#let toc-pattern(
  title,
  items,
  image: none,
  subtitle: [今回の講習会の内容],
) = {
  let toc-content = card([目次], [
    #for (idx, item) in items.enumerate() [
      #let n = idx + 1
      #grid(
        columns: (34pt, 1fr),
        column-gutter: space.md,
        align: horizon,
        number-badge(str(n), fill: theme.accent, fg: theme.text_on_accent),
        box(height: 28pt, align(left + horizon, prose(item))),
      )
      #if idx < items.len() - 1 [#v(space.sm)#divider()#v(space.sm)]
    ]
  ])

  let body = if image == none {
    toc-content
  } else {
    grid-cards((toc-content, image), cols: 2)
  }

  slide-frame(
    body,
    title: title,
    subtitle: subtitle,
  )
}

#let summary-pattern(
  title,
  items,
  subtitle: [要点を横に逃がさず、全幅で縦に積む。],
) = slide-frame(
  [
    #for (idx, item) in items.enumerate() [
      #callout([ポイント #str(idx + 1)], item, kind: "success")
      #if idx < items.len() - 1 [#v(space.sm)]
    ]
  ],
  title: title,
  subtitle: subtitle,
)

#let compare-pattern(
  title,
  left-title,
  left-items,
  left-tone: "danger",
  right-title,
  right-items,
  right-tone: "success",
  subtitle: [],
) = slide-frame(
  // 固定 height / body-height / cell-height は本文より箱だけ大きくなりカード下に空白が残る。
  // 行の高さは grid が両セルの内容の最大に取る（上揃え）。
  grid-cards(
    (
      card(left-title, bullet-list(left-items), tone: left-tone),
      card(right-title, bullet-list(right-items), tone: right-tone),
    ),
    cols: 2,
    cell-height: none,
  ),
  title: title,
  subtitle: subtitle,
)

#let text-image-pattern(
  title,
  text-title,
  items,
  image,
  reverse: false,
  subtitle: none,
  show-subtitle: true,
  col-ratio: (1fr, 1fr),
) = {
  // テキスト側は固定高さを外して、箇条書きの量に応じて自然に伸縮させる
  let text-block = card(text-title, bullet-list(items))
  // 右側は画像パス文字列と任意コンテンツの両方を受け取り、固定高さでクリップしない
  let visual = if type(image) == str {
    image(image, width: 100%)
  } else {
    image
  }
  let image-block = card([], [#visual])
  let default-subtitle = if reverse {
    [画像を先に見せてから説明へつなげる。]
  } else {
    [説明を置いてから右側に視覚要素を置く。]
  }
  let resolved-subtitle = if not show-subtitle {
    none
  } else if subtitle != none {
    subtitle
  } else {
    default-subtitle
  }
  slide-frame(
    grid(
      columns: col-ratio,
      column-gutter: space.lg,
      align: top,
      ..(if reverse { (image-block, text-block) } else { (text-block, image-block) }),
    ),
    title: title,
    subtitle: resolved-subtitle,
  )
}

#let card-row-pattern(title, cards, cols: 3, subtitle: none, cell-height: auto) = slide-frame(
  grid-cards(cards, cols: cols, cell-height: if cell-height == auto {
    if cols == 4 { limits.card_height_sm } else if cols == 2 { limits.card_height_lg } else { limits.card_height_md }
  } else { cell-height }),
  title: title,
  subtitle: subtitle,
)

#let five-level-pattern(
  title,
  levels,
  subtitle: [薄い色から濃い色へ、段階的な進化を表現する。],
) = slide-frame(
  grid-cards(
    (
      level-card([Level 1], levels.at(0).at(0), levels.at(0).at(1), colors.level_1),
      level-card([Level 2], levels.at(1).at(0), levels.at(1).at(1), colors.level_2),
      level-card([Level 3], levels.at(2).at(0), levels.at(2).at(1), colors.level_3),
      level-card([Level 4], levels.at(3).at(0), levels.at(3).at(1), colors.level_4),
      level-card([Level 5], levels.at(4).at(0), levels.at(4).at(1), colors.level_5),
    ),
    cols: 5,
    gap: space.sm,
    cell-height: limits.card_height_sm,
  ),
  title: title,
  subtitle: subtitle,
)

#let steps-pattern(
  title,
  steps,
  subtitle: [番号付きで順序を明示する。],
) = {
  // 4 件以上はカード＋矢印の積みでタイトル領域を差し引くと溢れやすいので詰める
  let n = steps.len()
  let tight = n >= 4
  let step-h = if tight { 84pt } else { limits.card_height_sm }
  let title-h = if tight { 22pt } else { 30pt }
  let body-h = if tight { 30pt } else { 42pt }
  slide-frame(
    [
      #for (idx, step) in steps.enumerate() [
        #step-item(
          str(idx + 1),
          step.at(0),
          step.at(1),
          height: step-h,
          title-height: title-h,
          body-height: body-h,
        )
        #if idx < steps.len() - 1 [
          #if tight [#v(2pt)]
          #flow-arrow(compact: tight)
          #if tight [#v(2pt)]
        ]
      ]
    ],
    title: title,
    subtitle: subtitle,
  )
}

#let horizontal-steps-pattern(
  title,
  steps,
  subtitle: [横方向に工程の流れを見せる。],
) = slide-frame(
  grid(
    columns: (1fr, 20pt, 1fr, 20pt, 1fr, 20pt, 1fr),
    column-gutter: space.xs,
    align: horizon,
    card([Step 1], steps.at(0), height: limits.card_height_sm, title-height: 34pt),
    flow-arrow(direction: "right"),
    card([Step 2], steps.at(1), height: limits.card_height_sm, title-height: 34pt),
    flow-arrow(direction: "right"),
    card([Step 3], steps.at(2), height: limits.card_height_sm, title-height: 34pt),
    flow-arrow(direction: "right"),
    card([Step 4], steps.at(3), tone: "accent", height: limits.card_height_sm, title-height: 34pt),
  ),
  title: title,
  subtitle: subtitle,
)

#let timeline-node() = box(width: 20pt, height: 62pt)[
  #place(center + horizon, box(width: 2pt, height: 62pt, fill: theme.accent))
  #place(center + horizon, circle(radius: 5pt, fill: theme.primary))
]

#let timeline-pattern(
  title,
  events,
  subtitle: [時系列の変化を説明する。],
) = slide-frame(
  [
    #for (idx, event) in events.enumerate() [
      #grid(
        columns: (76pt, 24pt, 1fr),
        column-gutter: space.sm,
        align: top,
        [#chip(event.at(0), fill: theme.primary, fg: theme.text_on_dark, stroke: none)],
        timeline-node(),
        card(event.at(1), event.at(2), height: limits.card_height_sm, title-height: 34pt, body-height: 40pt),
      )
      #if idx < events.len() - 1 [#v(space.sm)]
    ]
  ],
  title: title,
  subtitle: subtitle,
)

#let icon-list-pattern(
  title,
  items,
  subtitle: [色付きラベルで行を区別する。],
) = slide-frame(
  [
    #for (idx, item) in items.enumerate() [
      #icon-callout(item.at(0), item.at(1), kind: item.at(2))
      #if idx < items.len() - 1 [#v(space.sm)]
    ]
  ],
  title: title,
  subtitle: subtitle,
)

#let glass-pattern(title, body) = align(center + horizon)[
  #slide-frame(
    box(
      width: 78%,
      fill: theme.bg.transparentize(20%),
      stroke: (paint: theme.primary, thickness: 2pt),
      radius: radius,
      inset: 24pt,
      [#headline(title, size: sizes.heading)#v(space.sm)#prose(body)],
    ),
  )
]

#let gradient-panel-pattern(
  title,
  first,
  second,
  third,
  subtitle: [濃淡の3パネルで強弱を付けて並べる。],
) = slide-frame(
  grid-cards(
    (
      card(first.at(0), first.at(1), tone: "primary", height: limits.card_height_md, body-height: 60pt),
      card(second.at(0), second.at(1), tone: "info", height: limits.card_height_md, body-height: 60pt),
      card(third.at(0), third.at(1), tone: "accent", height: limits.card_height_md, body-height: 60pt),
    ),
    cols: 3,
    cell-height: limits.card_height_md,
  ),
  title: title,
  subtitle: subtitle,
)
#let full-image-pattern(title, bg, body: [画像を背景として敷き、上にタイトルと短い説明を重ねる。]) = block(
  width: 100%,
  height: 100%,
  breakable: false,
)[
  #place(top + left, dx: -page-margin-x, dy: -page-margin-y)[
    #box(width: page-width, height: page-height, clip: true)[
      #set image(width: page-width, height: page-height, fit: "cover")
      #bg
    ]
  ]
  #place(top + left, dx: -page-margin-x, dy: -page-margin-y)[
    #box(width: page-width, height: page-height, fill: limits.overlay_dark)
  ]
  #place(top + left, dx: -page-margin-x, dy: -page-margin-y)[
    #box(width: page-width, height: page-height, inset: (x: 64pt, y: 48pt))[
      #headline(title, size: sizes.hero, fill: theme.text_on_dark)
      #v(space.md)
      #box(width: limits.text_max_width, fill: theme.bg.transparentize(8%), radius: radius, inset: panel-inset)[
        #prose(body, size: sizes.subheading)
      ]
    ]
  ]
]

#let side-image-pattern(title, text-title, items, path) = block(
  width: 100%,
  height: 100%,
  breakable: false,
)[
  #place(
    top + right,
    dx: page-margin-x,
    box(width: page-width * 0.58, height: page-height, clip: true)[
      #image(path, width: page-width * 0.58, height: page-height, fit: "cover")
    ],
  )
  #place(
    top + right,
    dx: page-margin-x,
    box(width: page-width * 0.58, height: page-height, fill: limits.overlay_dark),
  )
  #place(top + left, dx: -page-margin-x, dy: -page-margin-y)[
    box(width: page-width, height: page-height, inset: (x: 56pt, y: 44pt))[
    #box(width: 48%, fill: theme.bg.transparentize(5%), radius: radius, inset: 22pt)[
      #headline(title, size: sizes.title)
      #v(space.md)
      #headline(text-title, size: sizes.subheading)
      #v(space.sm)
      #bullet-list(items)
    ]
    ]
  ]
]

#let quote-pattern(
  title,
  quote,
  by: none,
  subtitle: [引用文を1メッセージだけ強調する。],
) = slide-frame(
  quote-card(quote, by: by),
  title: title,
  subtitle: subtitle,
)

#let split-visual-pattern(
  title,
  left-path,
  right-path,
  subtitle: [重要度順にサイズを変え、主従をはっきりさせる。],
) = slide-frame(
  grid(
    columns: (1.35fr, 0.9fr),
    column-gutter: space.lg,
    align: top,
    image-card(
      [1. 主情報],
      left-path,
      [#caption([最初に見る図を大きく置く。])],
      height: 206pt,
      card-height: 260pt,
      order: 1,
    ),
    image-card(
      [2. 補助情報],
      right-path,
      [#caption([補足画像は小さく置く。])],
      height: 156pt,
      card-height: 220pt,
      order: 2,
    ),
  ),
  title: title,
  subtitle: subtitle,
)

#let stats-pattern(
  title,
  stats,
  subtitle: [最重要数値だけを大きくし、補足は小さく置く。],
) = slide-frame(
  grid(
    columns: (1.35fr, 1fr, 1fr),
    column-gutter: space.lg,
    align: top,
    metric(stats.at(0).at(0), stats.at(0).at(1), note: stats.at(0).at(2), tone: stats.at(0).at(3), variant: "hero"),
    metric(stats.at(1).at(0), stats.at(1).at(1), note: stats.at(1).at(2), tone: stats.at(1).at(3)),
    metric(stats.at(2).at(0), stats.at(2).at(1), note: stats.at(2).at(2), tone: stats.at(2).at(3)),
  ),
  title: title,
  subtitle: subtitle,
)

#let center-message-pattern(title, body) = align(center + horizon)[
  #box(width: 76%, align(center, headline(title, size: sizes.display)))
  #v(space.md)
  #line(length: 22%, stroke: (paint: theme.accent, thickness: 2pt))
  #v(space.md)
  #box(width: limits.text_max_width, align(center, prose(body, muted: true, size: sizes.subheading)))
]

#let qa-pattern(contacts) = align(center + horizon)[
  #headline([Q&A], size: sizes.hero)
  #v(space.lg)
  #grid-cards(
    (
      flat-card(contacts.at(0).at(0), contacts.at(0).at(1), fill: theme.surface),
      flat-card(contacts.at(1).at(0), contacts.at(1).at(1), fill: theme.surface),
      flat-card(contacts.at(2).at(0), contacts.at(2).at(1), fill: theme.surface),
    ),
    cols: 3,
  )
]

#let qr-pattern(
  title,
  body,
  subtitle: [資料やサイトへ外部誘導する。],
) = slide-frame(
  align(center)[
    #qr-box(size: 210pt)
    #v(space.md)
    #box(width: 68%, align(center, prose(body)))
  ],
  title: title,
  subtitle: subtitle,
)

#let question-pattern(title, body) = block(
  width: 100%,
  height: 100%,
  breakable: false,
)[
  #place(top + left, dx: -page-margin-x, dy: -page-margin-y)[
    #box(
      width: page-width,
      height: page-height,
      fill: theme.primary,
      inset: (x: 64pt, y: 52pt),
      align(center + horizon)[
        #headline(title, size: sizes.hero, fill: theme.text_on_dark)
        #v(space.md)
        #text(font: fonts.body, size: sizes.subheading, fill: theme.text_on_dark, tracking: tracking.ja, body)
      ],
    )
  ]
]

#let ratio-pattern(
  title,
  ratios,
  cols: 3,
  subtitle: [割合の大小を、面積で直感的に示す。],
) = slide-frame(
  if cols == 2 {
    grid(
      columns: grid-columns(2),
      column-gutter: space.lg,
      row-gutter: space.md,
      align: top,
      ratio-card(ratios.at(0).at(0), ratios.at(0).at(1)),
      ratio-card(ratios.at(1).at(0), ratios.at(1).at(1)),
      grid.cell(colspan: 2, ratio-card(
        ratios.at(2).at(0),
        ratios.at(2).at(1),
        fill: theme.primary,
        fg: theme.text_on_dark,
        label-fg: theme.text_on_dark,
      )),
    )
  } else {
    grid-cards(
      (
        ratio-card(ratios.at(0).at(0), ratios.at(0).at(1)),
        ratio-card(ratios.at(1).at(0), ratios.at(1).at(1)),
        ratio-card(
          ratios.at(2).at(0),
          ratios.at(2).at(1),
          fill: theme.primary,
          fg: theme.text_on_dark,
          label-fg: theme.text_on_dark,
        ),
      ),
      cols: cols,
    )
  },
  title: title,
  subtitle: subtitle,
)

#let stacked-summary-pattern(
  title,
  items,
  subtitle: [全幅カードを縦に重ね、まとめを積み上げる。],
) = slide-frame(
  [
    #for (idx, item) in items.enumerate() [
      #callout([まとめポイント #str(idx + 1)], item, kind: "success")
      #if idx < items.len() - 1 [#v(space.sm)]
    ]
  ],
  title: title,
  subtitle: subtitle,
)

#let mixed-pattern(
  title,
  value,
  label-text,
  items,
  subtitle: [数値と説明を同じ画面で扱う。],
) = slide-frame(
  grid-cards(
    (
      metric(value, label-text, note: [定量情報], tone: theme.accent),
      card([テキストメモ], bullet-list(items), tone: "accent"),
    ),
    cols: 2,
  ),
  title: title,
  subtitle: subtitle,
)

#let contrast-conclusion-pattern(
  title,
  left-title,
  left-items,
  right-title,
  right-items,
  conclusion,
  subtitle: [対比してから結論へ誘導する。],
) = slide-frame(
  [
    #grid-cards(
      (
        card(left-title, bullet-list(left-items), tone: "danger", height: limits.card_height_lg, body-height: 96pt),
        card(right-title, bullet-list(right-items), tone: "success", height: limits.card_height_lg, body-height: 96pt),
      ),
      cols: 2,
      cell-height: limits.card_height_lg,
    )
    #v(space.md)
    #callout([結論], conclusion, kind: "success")
  ],
  title: title,
  subtitle: subtitle,
)
