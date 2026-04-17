#import "../template/style.typ": apply-theme, limits, radius, space, theme
#import "../template/components.typ": *
#import "../template/layouts.typ": *

#show: apply-theme

#deck((
  title-pattern(
    [Title],
    [subtitle],
    [wogikaze],
  ),
  section-pattern(
    [section-title],
    [section-subtitle],
  ),
  toc-pattern(
    [outline],
    (
      [item1],
    ),
  ),
))
