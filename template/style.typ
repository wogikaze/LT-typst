#let colors = (
  primary_base: rgb("#2C2A4A"),
  primary_hover: rgb("#3A3763"),
  primary_active: rgb("#1F1D36"),
  on_primary: rgb("#FFFFFF"),

  accent_base: rgb("#B89B4F"),
  accent_hover: rgb("#C6A85A"),
  accent_active: rgb("#9E8542"),
  accent_text: rgb("#7A6630"),
  on_accent: rgb("#1A1A1A"),

  surface_base: rgb("#DADAD8"),
  surface_raised: rgb("#EFEEEC"),

  text_primary: rgb("#2B2F3A"),
  text_secondary: rgb("#5A6070"),
  border: rgb("#C8C8C5"),
  divider: rgb("#C8C8C5"),

  primary_fill: rgb("#DEDBE8"),
  accent_fill: rgb("#E7D4A5"),
  success_fill: rgb("#DCE8DD"),
  warning_fill: rgb("#ECDDC4"),
  danger_fill: rgb("#ECD7D7"),
  info_fill: rgb("#DCE4ED"),

  success: rgb("#3A7D44"),
  warning: rgb("#C78B2A"),
  danger: rgb("#B94A48"),
  info: rgb("#3A6EA5"),

  // five-level-pattern 用（薄い面の段階。実装の単一ソース）
  level_1: rgb("#efeeec"),
  level_2: rgb("#e7e7e5"),
  level_3: rgb("#dfdfdd"),
  level_4: rgb("#d6d6d4"),
  level_5: rgb("#c9c9c6"),
)

#let fonts = (
  heading: "Noto Sans CJK JP",
  body: "Noto Sans CJK JP",
  label: "Noto Sans CJK JP",
  code: "Noto Sans Mono CJK JP",
)

#let sizes = (
  display: 56pt,
  hero: 48pt,
  title: 36pt,
  section: 32pt,
  heading: 26pt,
  subheading: 20pt,
  body: 17pt,
  caption: 13pt,
  small: 13pt,
  code: 13pt,
)

#let leading = (
  title: 0.2em,
  body: 0.45em,
  loose: 0.6em,
)

#let tracking = (
  ja: 0pt,
  label: 0pt,
)

#let space = (
  xs: 4pt,
  sm: 8pt,
  md: 16pt,
  lg: 24pt,
  xl: 32pt,
)

#let radius = 4pt
#let panel-inset = 16pt
#let page-width = 13.333in
#let page-height = 7.5in
// apply-theme の set page(margin) と同一。全面レイアウトでマージン分だけ place をずらすときに使う
#let page-margin-x = 40pt
#let page-margin-y = 28pt

#let limits = (
  slide_text_chars_min: 120,
  slide_text_chars_max: 180,
  max_elements: 6,
  max_bullets_per_column: 3,
  title_lines: 2,
  body_lines: 3,
  title_chars_per_line: 16,
  body_chars: 60,
  text_max_width: 60%,
  card_title_height: 32pt,
  card_body_height: 78pt,
  card_height_sm: 108pt,
  card_height_md: 146pt,
  card_height_lg: 192pt,
  card_height_image: 192pt,
  image_header_height: 92pt,
  icon_sm: 24pt,
  icon_md: 32pt,
  icon_lg: 48pt,
  overlay_dark: rgb("#000000").transparentize(60%),
  overlay_light: rgb("#FFFFFF").transparentize(40%),
)

#let theme = (
  bg: colors.surface_base,
  surface: colors.surface_raised,

  text: colors.text_primary,
  text_muted: colors.text_secondary,
  text_on_dark: colors.on_primary,
  text_on_accent: colors.on_accent,

  primary: colors.primary_base,
  primary_hover: colors.primary_hover,
  primary_active: colors.primary_active,

  accent: colors.accent_base,
  accent_hover: colors.accent_hover,
  accent_active: colors.accent_active,
  accent_text: colors.accent_text,

  primary_fill: colors.primary_fill,
  accent_fill: colors.accent_fill,
  success_fill: colors.success_fill,
  warning_fill: colors.warning_fill,
  danger_fill: colors.danger_fill,
  info_fill: colors.info_fill,

  border: colors.border,
  divider: colors.divider,

  code_bg: colors.primary_active,
  code_border: colors.primary_hover,
  code_text: colors.on_primary,

  success: colors.success,
  warning: colors.warning,
  danger: colors.danger,
  info: colors.info,

  // 右下スライド番号（補助情報。読み取りやすさと目立ちすぎないさのバランス）
  slide_no: colors.text_secondary.transparentize(28%),
)

#let apply-theme(body) = {
  set page(
    width: page-width,
    height: page-height,
    margin: (x: page-margin-x, y: page-margin-y),
    fill: theme.bg,
  )

  set text(
    font: fonts.body,
    size: sizes.body,
    fill: theme.text,
    lang: "ja",
    tracking: tracking.ja,
  )

  set par(
    leading: leading.body,
    spacing: 0.35em,
    justify: false,
  )

  set heading(numbering: none)

  show heading.where(level: 1): it => block(
    above: 0pt,
    below: space.xl,
    text(font: fonts.heading, weight: 700, size: sizes.title, fill: theme.primary, tracking: tracking.ja, it.body),
  )

  show heading.where(level: 2): it => block(
    above: space.md,
    below: space.sm,
    text(font: fonts.heading, weight: 700, size: sizes.heading, fill: theme.primary, tracking: tracking.ja, it.body),
  )

  show heading.where(level: 3): it => block(
    above: space.sm,
    below: space.xs,
    text(font: fonts.heading, weight: 700, size: sizes.subheading, fill: theme.primary, tracking: tracking.ja, it.body),
  )

  show emph: it => text(weight: 700, fill: theme.accent_text, it.body)
  show strong: it => text(weight: 700, fill: theme.text, it.body)
  show link: it => text(fill: theme.info, underline(stroke: (paint: theme.info, thickness: 1pt), it.body))

  show raw.where(block: false): it => box(
    fill: theme.surface,
    stroke: (paint: theme.border, thickness: 0.8pt),
    radius: radius,
    inset: (x: 0.45em, y: 0.18em),
    text(font: fonts.code, size: sizes.code, fill: theme.text, it.text),
  )

  show raw.where(block: true): it => block(
    above: space.sm,
    below: space.md,
    box(
      width: 100%,
      fill: theme.code_bg,
      stroke: (paint: theme.code_border, thickness: 0.8pt),
      radius: radius,
      inset: panel-inset,
      text(font: fonts.code, size: sizes.code, fill: theme.code_text, tracking: 0pt, it.text),
    ),
  )

  show list: it => {
    set text(size: sizes.body, fill: theme.text)
    set par(leading: leading.body)
    it
  }

  show enum: it => {
    set text(size: sizes.body, fill: theme.text)
    set par(leading: leading.body)
    it
  }

  body
}
