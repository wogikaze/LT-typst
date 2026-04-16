#import "style.typ": fonts, limits, panel-inset, radius, sizes, space, theme, tracking

// デッキ右下のスライド番号（deck が重ねる）
#let slide-no-footer(n, total) = text(
  font: fonts.label,
  size: 10.5pt,
  fill: theme.slide_no,
  tracking: tracking.label,
  numbering("1", n) + " / " + numbering("1", total),
)

// Atomic Design: Atoms
#let headline(body, size: sizes.title, fill: theme.primary) = text(
  font: fonts.heading,
  weight: 700,
  size: size,
  fill: fill,
  tracking: tracking.ja,
  top-edge: "bounds",
  bottom-edge: "bounds",
  body,
)

#let label(body, fill: theme.accent_text) = text(
  font: fonts.label,
  weight: 900,
  size: sizes.subheading,
  fill: fill,
  tracking: tracking.label,
  body,
)

#let prose(body, muted: false, size: sizes.body) = text(
  font: fonts.body,
  size: size,
  fill: if muted { theme.text_muted } else { theme.text },
  tracking: tracking.ja,
  body,
)

#let caption(body) = text(
  font: fonts.label,
  size: sizes.caption,
  fill: theme.text_muted,
  tracking: tracking.label,
  body,
)

#let link-url(url, body) = text(
  font: fonts.label,
  fill: theme.info,
  tracking: tracking.label,
  link(url)[#body],
)

#let divider() = line(length: 100%, stroke: (paint: theme.divider, thickness: 0.8pt))

#let chip(body, fill: theme.surface, fg: theme.text, stroke: (paint: theme.border, thickness: 0.8pt)) = box(
  fill: fill,
  stroke: stroke,
  radius: 999pt,
  inset: (x: 0.75em, y: 0.22em),
  text(font: fonts.label, size: sizes.small, weight: 700, fill: fg, tracking: tracking.label, body),
)

#let number-badge(number, fill: theme.primary, fg: theme.text_on_dark) = box(
  width: 28pt,
  height: 28pt,
  fill: fill,
  radius: 999pt,
  align(
    center + horizon,
    text(
      font: fonts.label,
      weight: 700,
      size: sizes.small,
      fill: fg,
      tracking: tracking.label,
      top-edge: "bounds",
      bottom-edge: "bounds",
      number,
    ),
  ),
)

#let keycap(body) = box(
  fill: theme.surface,
  stroke: (paint: theme.border, thickness: 0.8pt),
  radius: radius,
  inset: (x: 0.5em, y: 0.2em),
  text(font: fonts.code, size: sizes.small, fill: theme.text, body),
)

#let swatch(fill, width: 100%, height: 20pt) = box(
  width: width,
  height: height,
  fill: fill,
  stroke: (paint: theme.border, thickness: 0.7pt),
  radius: radius,
)

// Atomic Design: Molecules
#let bullet-list(items) = list(
  tight: false,
  spacing: space.md,
  ..items,
)

#let tone-stroke(tone) = if tone == "accent" {
  theme.accent
} else if tone == "primary" {
  theme.primary
} else if tone == "success" {
  theme.success
} else if tone == "warning" {
  theme.warning
} else if tone == "danger" {
  theme.danger
} else if tone == "info" {
  theme.info
} else {
  theme.border
}

#let tone-fill(tone) = if tone == "accent" {
  theme.accent_fill
} else if tone == "primary" {
  theme.primary_fill
} else if tone == "success" {
  theme.success_fill
} else if tone == "warning" {
  theme.warning_fill
} else if tone == "danger" {
  theme.danger_fill
} else if tone == "info" {
  theme.info_fill
} else {
  theme.surface
}

#let tone-on-fill(tone) = if tone == "primary" {
  theme.text_on_dark
} else {
  theme.text
}

#let bounded(body, height: none, width: 100%, clip: true, align-dir: top) = if height == none {
  body
} else {
  // Fixed height + clip はフォントのインクより厳しい計測と相性が悪い。上方向のわずかな余白で欠けを防ぐ
  box(
    width: width,
    height: height,
    clip: clip,
    align(align-dir, pad(top: 0.12em, bottom: 0.06em, body)),
  )
}

#let card(
  title,
  body,
  tone: "default",
  footer: none,
  height: none,
  title-height: limits.card_title_height,
  body-height: none,
) = {
  let stroke-paint = tone-stroke(tone)
  let fill-paint = tone-fill(tone)
  let content = [
    #bounded(headline(title, size: sizes.subheading), height: title-height)
    #v(space.xs)
    #bounded(body, height: body-height)
    #if footer != none [
      #v(space.sm)
      #divider()
      #v(space.xs)
      #caption(footer)
    ]
  ]

  if height == none {
    box(
      width: 100%,
      fill: fill-paint,
      stroke: (paint: stroke-paint, thickness: if tone == "default" { 0.8pt } else { 1.1pt }),
      radius: radius,
      inset: panel-inset,
      content,
    )
  } else {
    box(
      width: 100%,
      height: height,
      clip: true,
      fill: fill-paint,
      stroke: (paint: stroke-paint, thickness: if tone == "default" { 0.8pt } else { 1.1pt }),
      radius: radius,
      inset: panel-inset,
      content,
    )
  }
}

#let flat-card(title, body, fill: theme.surface, stroke: theme.border, height: none) = {
  let content = [
    #bounded(headline(title, size: sizes.subheading), height: limits.card_title_height)
    #v(space.xs)
    #body
  ]

  if height == none {
    box(
      width: 100%,
      fill: fill,
      stroke: (paint: stroke, thickness: 0.8pt),
      radius: radius,
      inset: panel-inset,
      content,
    )
  } else {
    box(
      width: 100%,
      height: height,
      clip: true,
      fill: fill,
      stroke: (paint: stroke, thickness: 0.8pt),
      radius: radius,
      inset: panel-inset,
      content,
    )
  }
}

#let callout(title, body, kind: "info") = {
  let tone = if kind == "success" {
    theme.success
  } else if kind == "warning" {
    theme.warning
  } else if kind == "danger" {
    theme.danger
  } else {
    theme.info
  }
  let fill-paint = if kind == "success" {
    theme.success_fill
  } else if kind == "warning" {
    theme.warning_fill
  } else if kind == "danger" {
    theme.danger_fill
  } else {
    theme.info_fill
  }

  box(
    width: 100%,
    fill: fill-paint,
    stroke: (
      left: (paint: tone, thickness: 4pt),
      top: (paint: theme.border, thickness: 0.8pt),
      right: (paint: theme.border, thickness: 0.8pt),
      bottom: (paint: theme.border, thickness: 0.8pt),
    ),
    radius: radius,
    inset: panel-inset,
    [
      #label(title, fill: tone)
      #v(space.md)
      #body
    ],
  )
}

#let icon-symbol(kind) = if kind == "success" {
  [✓]
} else if kind == "warning" {
  [!]
} else if kind == "danger" {
  [×]
} else {
  [i]
}

#let icon-badge(symbol, fill: theme.primary, fg: theme.text_on_dark, size: limits.icon_md) = box(
  width: size,
  height: size,
  fill: fill,
  radius: 999pt,
  align(center + horizon, text(
    font: fonts.label,
    weight: 700,
    size: sizes.small,
    fill: fg,
    tracking: tracking.label,
    symbol,
  )),
)

#let icon-callout(title, body, kind: "info") = {
  let tone = if kind == "success" {
    theme.success
  } else if kind == "warning" {
    theme.warning
  } else if kind == "danger" {
    theme.danger
  } else {
    theme.info
  }
  let fill-paint = if kind == "success" {
    theme.success_fill
  } else if kind == "warning" {
    theme.warning_fill
  } else if kind == "danger" {
    theme.danger_fill
  } else {
    theme.info_fill
  }

  box(
    width: 100%,
    fill: fill-paint,
    stroke: (paint: tone, thickness: 0.9pt),
    radius: radius,
    inset: panel-inset,
    grid(
      columns: (limits.icon_md + 4pt, 1fr),
      column-gutter: space.sm,
      align: top,
      icon-badge(icon-symbol(kind), fill: tone),
      [
        #label(title, fill: tone)
        #v(space.xs)
        #body
      ],
    ),
  )
}

#let metric(value, label-text, note: none, tone: theme.primary, variant: "default") = {
  let dark = variant == "hero"
  box(
    width: 100%,
    height: if dark { limits.card_height_lg } else { limits.card_height_md },
    clip: true,
    fill: if dark { theme.primary } else { theme.surface },
    stroke: (paint: if dark { theme.primary } else { theme.border }, thickness: 0.8pt),
    radius: radius,
    inset: panel-inset,
    align(if dark { left + horizon } else { center + horizon })[
      #headline(
        value,
        size: if dark { sizes.display } else { sizes.heading },
        fill: if dark { theme.text_on_dark } else { tone },
      )
      #v(space.xs)
      #text(
        font: fonts.body,
        size: sizes.body,
        fill: if dark { theme.text_on_dark } else { theme.text },
        tracking: tracking.ja,
        label-text,
      )
      #if note != none [
        #v(space.xs)
        #text(
          font: fonts.label,
          size: sizes.caption,
          fill: if dark { theme.text_on_dark } else { theme.text_muted },
          tracking: tracking.label,
          note,
        )
      ]
    ],
  )
}

#let step-item(
  number,
  title,
  body,
  height: limits.card_height_sm,
  title-height: 30pt,
  body-height: 42pt,
) = card(
  title,
  [
    #grid(
      columns: (36pt, 1fr),
      column-gutter: space.sm,
      align: horizon,
      align(center + horizon, number-badge(number)),
      block(width: 100%, align(left + top, pad(top: space.xs, prose(body)))),
    )
  ],
  height: height,
  title-height: title-height,
  body-height: body-height,
)

#let timeline-item(date, title, body) = grid(
  columns: (76pt, 1fr),
  column-gutter: space.md,
  align: top,
  [#chip(date, fill: theme.primary, fg: theme.text_on_dark, stroke: none)], card(title, body),
)

#let flow-arrow(direction: "down", compact: false) = align(center)[
  #text(
    font: fonts.label,
    size: if direction == "right" {
      if compact { 18pt } else { 22pt }
    } else {
      if compact { 11pt } else { 15pt }
    },
    weight: 700,
    fill: theme.accent,
    if direction == "right" { [→] } else { [↓] },
  )
]

#let image-frame(path, height: 120pt, fit: "cover", framed: true) = box(
  width: 100%,
  height: height,
  fill: if framed { theme.surface } else { none },
  stroke: if framed { (paint: theme.border, thickness: 0.8pt) } else { none },
  radius: radius,
  clip: true,
  image(path, width: 100%, height: height, fit: fit),
)

#let image-card(
  title,
  path,
  body,
  height: limits.image_header_height,
  card-height: limits.card_height_image,
  order: none,
  title-height: 44pt,
  body-height: 36pt,
) = box(
  width: 100%,
  height: card-height,
  clip: true,
  [
    #box(width: 100%, height: height)[
      #image-frame(path, height: height, framed: false)
      #if order != none [
        #place(top + left, dx: 8pt, dy: 8pt, number-badge(str(order), fill: theme.primary, fg: theme.text_on_dark))
      ]
    ]
    #v(space.sm)
    #bounded(headline(title, size: sizes.subheading), height: title-height)
    #v(space.xs)
    #bounded(body, height: body-height)
  ],
)

#let code-card(title, code) = card(
  title,
  [#code],
  tone: "primary",
)

#let quote-card(body, by: none) = box(
  width: 100%,
  fill: theme.surface,
  stroke: (paint: theme.accent, thickness: 1pt),
  radius: radius,
  inset: panel-inset,
  [
    #text(font: fonts.body, size: sizes.heading, fill: theme.text, body)
    #if by != none [
      #v(space.md)
      #align(right, caption(by))
    ]
  ],
)

#let level-card(level, title, body, fill) = box(
  width: 100%,
  height: limits.card_height_sm,
  clip: true,
  fill: fill,
  stroke: (paint: theme.border, thickness: 0.7pt),
  radius: radius,
  inset: 10pt,
  [
    #label(level, fill: theme.primary)
    #v(space.xs)
    #headline(title, size: sizes.small)
    #v(space.xs)
    #caption(body)
  ],
)

#let ratio-card(
  value,
  label-text,
  fill: theme.surface,
  fg: theme.primary,
  label-fg: none,
  height: limits.card_height_sm,
) = box(
  width: 100%,
  height: height,
  clip: true,
  fill: fill,
  stroke: (paint: theme.border, thickness: 0.8pt),
  radius: radius,
  inset: panel-inset,
  align(center)[
    #headline(value, size: sizes.heading, fill: fg)
    #v(space.xs)
    #text(font: fonts.body, size: sizes.body, fill: if label-fg == none { theme.text } else { label-fg }, label-text)
  ],
)

#let qr-box(label-text: [https://example.com], size: 190pt) = box(
  width: size,
  height: size,
  fill: theme.bg,
  stroke: (paint: theme.primary, thickness: 1pt),
  radius: radius,
  align(center + horizon)[
    #text(font: fonts.code, size: size * 0.36, fill: theme.primary)[▦]
    #v(space.sm)
    #caption(label-text)
  ],
)
