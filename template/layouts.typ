#import "style.typ": (
  colors, fonts, grid-card-inset, limits, page-height, page-margin-x, page-margin-y, page-width, panel-inset, radius, sizes, space,
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
  #box(width: 100%, align(top)[#body])
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

#let is-card-spec(c) = type(c) == dictionary and "kind" in c and c.kind == "card-spec"

#let grid-card-cell(c, cell-height: none) = {
  if is-card-spec(c) {
    if cell-height != none {
      table.cell(align: top)[
        #card(
          c.title,
          c.body,
          tone: c.tone,
          footer: c.footer,
          height: cell-height,
          inset: grid-card-inset,
          title-height: c.title-height,
          body-height: c.body-height,
        )
      ]
    } else {
      table-card-cell(
        c.title,
        c.body,
        tone: c.tone,
        footer: c.footer,
        title-height: c.title-height,
        body-height: c.body-height,
      )
    }
  } else if cell-height != none {
    table.cell(align: top)[
      #box(width: 100%, height: cell-height, clip: true, align(top)[#c])
    ]
  } else {
    table.cell(align: top)[#c]
  }
}

#let grid-cards(cards, cols: 3, gap: space.md, cell-height: none) = {
  box(width: 100%, align(top)[
    #if cell-height != none {
      grid(
        columns: grid-columns(cols),
        column-gutter: gap,
        row-gutter: space.md,
        ..cards.map(c => box(
          width: 100%,
          height: cell-height,
          clip: true,
          align(top)[#if is-card-spec(c) {
            card(
              c.title,
              c.body,
              tone: c.tone,
              footer: c.footer,
              height: cell-height,
              inset: grid-card-inset,
              title-height: c.title-height,
              body-height: c.body-height,
            )
          } else {
            c
          }],
        )),
      )
    } else {
      // table は行高を最長セルに合わせ、短いセルは cell の fill で背景を伸ばす
      table(
        columns: grid-columns(cols),
        column-gutter: gap,
        stroke: none,
        inset: 0pt,
        fill: none,
        ..cards.map(c => grid-card-cell(c)),
      )
    }
  ])
}

#let auto-cols(count) = if count <= 1 {
  1
} else if count == 2 {
  2
} else if count == 4 {
  2
} else if count == 5 {
  5
} else if count == 6 {
  3
} else {
  calc.min(count, 3)
}

// Recipes — 固定件数パターンと slide-frame 直書きの中間層
// 件数は可変。覚える API は少数に絞る

#let content-slide(title, body, subtitle: none) = slide-frame(body, title: title, subtitle: subtitle)

#let list-slide(title, items, subtitle: none, card-title: none) = slide-frame(
  if card-title == none {
    bullet-list(items)
  } else {
    card(card-title, bullet-list(items))
  },
  title: title,
  subtitle: subtitle,
)

#let columns-slide(
  title,
  cells,
  cols: none,
  subtitle: none,
  gap: space.md,
  cell-height: none,
) = {
  let n = if cols == none { auto-cols(cells.len()) } else { cols }
  slide-frame(
    grid-cards(cells, cols: n, gap: gap, cell-height: cell-height),
    title: title,
    subtitle: subtitle,
  )
}

#let cards-slide(
  title,
  cards,
  cols: none,
  subtitle: none,
  cell-height: auto,
) = columns-slide(
  title,
  cards,
  cols: cols,
  subtitle: subtitle,
  cell-height: if cell-height == auto { none } else { cell-height },
)

#let figure-slide(
  title,
  visual,
  subtitle: none,
  caption: none,
  height: 360pt,
  fit: "contain",
  align-dir: center,
) = slide-frame(
  [
    #align(align-dir)[
      #if type(visual) == str {
        screenshot(visual, height: height, fit: fit)
      } else {
        visual
      }
    ]
    #if caption != none [
      #v(space.sm)
      #caption(caption)
    ]
  ],
  title: title,
  subtitle: subtitle,
)

#let figures-slide(
  title,
  visuals,
  subtitle: none,
  cols: none,
  height: 200pt,
  fit: "contain",
) = {
  let cells = visuals.map(v => if type(v) == str {
    screenshot(v, height: height, fit: fit)
  } else {
    v
  })
  columns-slide(title, cells, cols: cols, subtitle: subtitle)
}

#let stack-slide(title, blocks, subtitle: none, gap: space.md) = slide-frame(
  [
    #for (idx, block) in blocks.enumerate() [
      #block
      #if idx < blocks.len() - 1 [#v(gap)]
    ]
  ],
  title: title,
  subtitle: subtitle,
)

#let callouts-slide(title, items, subtitle: none) = slide-frame(
  [
    #for (idx, item) in items.enumerate() [
      #callout(item.at(0), item.at(1), kind: if item.len() >= 3 { item.at(2) } else { "info" })
      #if idx < items.len() - 1 [#v(space.sm)]
    ]
  ],
  title: title,
  subtitle: subtitle,
)

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
  visual: none,
  visual-height: 360pt,
) = {
  let cards = grid-cards(
    (
      stretchcard(left-title, compact-list(left-items), tone: left-tone),
      stretchcard(right-title, compact-list(right-items), tone: right-tone),
    ),
    cols: 2,
    cell-height: none,
  )
  let figure = if visual != none {
    align(center)[
      #if type(visual) == str {
        image(visual, height: visual-height)
      } else {
        visual
      }
    ]
  } else {
    none
  }
  slide-frame(
    if figure == none {
      cards
    } else {
      [
        #cards
        #v(space.sm)
        #figure
      ]
    },
    title: title,
    subtitle: subtitle,
  )
}

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
  grid-cards(cards, cols: cols, cell-height: if cell-height == auto { none } else { cell-height }),
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
  subtitle: [],
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
      #callout([#str(idx + 1))], item, kind: "success")
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

#let steps-slide(
  title,
  steps,
  subtitle: none,
  horizontal: false,
) = if horizontal {
  let n = steps.len()
  let col-spec = ()
  let cells = ()
  for (idx, step) in steps.enumerate() {
    let label = if type(step) == array { step.at(0) } else { [Step #str(idx + 1)] }
    let body = if type(step) == array { step.at(1) } else { step }
    let tone = if idx == n - 1 { "accent" } else { "default" }
    col-spec.push(1fr)
    cells.push(card(label, body, tone: tone, height: limits.card_height_sm, title-height: 34pt))
    if idx < n - 1 {
      col-spec.push(20pt)
      cells.push(flow-arrow(direction: "right"))
    }
  }
  slide-frame(
    grid(
      columns: col-spec,
      column-gutter: space.xs,
      align: horizon,
      ..cells,
    ),
    title: title,
    subtitle: subtitle,
  )
} else {
  steps-pattern(title, steps, subtitle: subtitle)
}

// 自己紹介（左テキスト + 右写真）。
#let profile-slide(
  name,
  items,
  photo: none,
  logo: none,
  footer: none,
  placeholder: none,
  photo-size: 220pt,
) = block(
  width: 100%,
  height: 100%,
  breakable: false,
)[
  #place(top + left, dx: -page-margin-x, dy: -page-margin-y)[
    #box(width: page-width, height: page-height)[
      #grid(
        columns: (1.55fr, 1fr),
        gutter: 0pt,
        box(width: 100%, height: 100%, fill: rgb("#FFFFFF"), inset: (x: 56pt, y: 44pt))[
          #if logo != none [
            #logo
            #v(space.xl)
          ]
          #headline(name, size: 52pt)
          #v(space.xl)
          #for (idx, item) in items.enumerate() [
            #profile-bullet(item)
            #if idx < items.len() - 1 [#v(space.lg)]
          ]
          #if footer != none [
            #v(1fr)
            #place(bottom + left, dy: -8pt)[
              #caption(footer)
            ]
          ]
        ],
        box(width: 100%, height: 100%, fill: theme.primary)[
          #align(center + horizon)[
            #box(
              width: photo-size,
              height: photo-size,
              radius: 999pt,
              clip: true,
              stroke: (paint: rgb("#FFFFFF"), thickness: 4pt),
              if photo != none {
                image(photo, width: 100%, height: 100%, fit: "cover")
              } else if placeholder != none {
                box(
                  width: 100%,
                  height: 100%,
                  fill: theme.primary_hover,
                  align(center + horizon, placeholder),
                )
              } else {
                box(
                  width: 100%,
                  height: 100%,
                  fill: theme.primary_hover,
                  align(
                    center + horizon,
                    text(font: fonts.heading, size: 56pt, fill: theme.text_on_dark, weight: 700, [?]),
                  ),
                )
              },
            )
          ]
        ],
      )
    ]
  ]
]
