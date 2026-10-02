#import "../template/style.typ": apply-theme, fonts, limits, panel-inset, radius, sizes, space, theme, tracking
#import "../template/components.typ": *
#import "../template/layouts.typ": *

#show: apply-theme

#let avatar() = box(
  width: 104pt,
  height: 104pt,
  fill: theme.primary,
  radius: 999pt,
  align(center + horizon)[
    #text(font: fonts.label, size: 25pt, weight: 900, fill: theme.text_on_dark, tracking: tracking.label)[wgkz]
  ],
)

#let compact-code-panel(title, body) = box(
  width: 100%,
  fill: theme.code_bg,
  stroke: (paint: theme.code_border, thickness: 0.8pt),
  radius: radius,
  inset: panel-inset,
)[
  #text(font: fonts.label, size: sizes.caption, weight: 700, fill: theme.text_on_dark, tracking: tracking.label, title)
  #v(space.sm)
  #show raw.where(block: true): it => block(
    above: 0pt,
    below: 0pt,
    text(font: fonts.code, size: 9.2pt, fill: theme.code_text, tracking: 0pt, it.text),
  )
  #body
]

#let source-card(title, url) = flat-card(
  title,
  [#link-url(url, url)],
  fill: theme.surface,
  stroke: theme.info,
)

#deck((
  title-pattern(
    [自己紹介LT],
    [自作言語、AI、入力環境あたりを行き来している人の自己紹介],
    [手塚康生 / \@wogikaze],
    aside: avatar(),
  ),
  stats-pattern(
    [プロフィール],
    (
      ([2006], [8月15日生まれ], [今年20歳], theme.primary),
      ([CS], [計算機科学], [情報科学部 情報科学科], theme.info),
      ([7年], [プログラミング歴], [C\#から始めた], theme.accent),
    ),
    subtitle: [ゲームのPluginを作るためにC\#を学び始めた],
  ),
  compare-pattern(
    [技術者として養成されるらしい],
    [公式の説明],
    (
      [情報処理システムを企画提案できる],
      [研究開発できる],
      [維持運用できる],
    ),
    left-tone: "info",
    [自分の解釈],
    (
      [作りたいものを作れるようになる],
      [壊れたら直せるようになる],
      [長く触れる技術を増やす],
    ),
    right-tone: "primary",
  ),
  card-row-pattern(
    [作ったもの],
    (
      card([arukellt], [#bullet-list(([WASM GC + WASI], [Rustっぽい書き心地], [セルフホスト済み]))], tone: "primary"),
      card([ts2wasm], [#bullet-list(([JS / TSをWASMへ], [仕様が複雑], [停滞中]))], tone: "warning"),
      card([wgkz配列], [#bullet-list(([日本語入力が増えた], [LLMチャット向け], [QWERTY離脱]))], tone: "accent"),
    ),
    cols: 3,
    subtitle: [言語処理系と入力環境に寄りがち],
    cell-height: none,
  ),
  card-row-pattern(
    [arukellt],
    (
      card([狙い], [#bullet-list(([WASM GC + WASIが主役], [所有権とライフタイムなし], [Rustっぽい構文]))], tone: "primary"),
      card([いま], [#bullet-list(([セルフホスト済み], [MoonBitとの差別化が薄い], [WASMの話は日曜に]))], tone: "info"),
    ),
    cols: 2,
    subtitle: [作りながら言語処理系とWebAssemblyを学ぶプロジェクト],
    cell-height: none,
  ),
  slide-frame(
    [
      #compact-code-panel([arukellt のコード例], [
```rs
use std::host::stdio

fn divide(a: i32, b: i32) -> Result<i32, String> {
    if b == 0 {
        Err(String_from("division by zero"))
    } else {
        Ok(a / b)
    }
}

fn main() {
    match divide(10, 2) {
        Result::Ok(v) => stdio::println(i32_to_string(v)),
        Result::Err(e) => stdio::println(e),
    }
    match divide(10, 0) {
        Result::Ok(v) => stdio::println(i32_to_string(v)),
        Result::Err(e) => stdio::println(e),
    }
}
```
      ])
    ],
    title: [Result と match],
    subtitle: [所有権やライフタイムを意識しないRustっぽい書き心地],
  ),
  contrast-conclusion-pattern(
    [ts2wasmで詰まっているところ],
    [やりたいこと],
    (
      [JS / TSをWASM化する],
      [Web資産をWASM側へ寄せる],
    ),
    [現実],
    (
      [JavaScriptの仕様が複雑すぎる],
      [実行時の振る舞いが多い],
      [良くない仕様も避けて通れない],
    ),
    [停滞中だが、仕様を読むほどコンパイラの難しさが見えてくる。],
    subtitle: [変換器を作ると、言語仕様の細部に殴られる],
  ),
  card-row-pattern(
    [キーボードと配列],
    (
      card([背景], [#bullet-list(([LLMとの会話で日本語を長く打つ], [QWERTYから離れたくなった], [wgkz配列を作成]))], tone: "accent"),
      card([気になるもの], [#bullet-list(([Keychron Orca echo], [トラックボール付き分割キーボード], [2026年6月19日 20時開始]))], tone: "info"),
    ),
    cols: 2,
    subtitle: [文字を打つ時間が増えるほど、入力環境が気になってくる],
    cell-height: limits.card_height_lg,
  ),
  card-row-pattern(
    [AtCoder Heuristic Contest],
    (
      card([何をするか], [#bullet-list(([AI使用ありで最適化問題を解く], [できるだけ良い答えを出す], [手元の改善がそのまま点になる]))], tone: "primary"),
      card([最近], [#bullet-list(([いい感じの結果を残せている], [Rustの勉強が一通りできた], [自作言語後に復帰したい]))], tone: "success"),
    ),
    cols: 2,
    subtitle: [アルゴリズムだけでなく、実装力と実験力も問われる競技],
    cell-height: limits.card_height_lg,
  ),
  stats-pattern(
    [AI],
    (
      ([3年], [ChatGPT Plus], [Plus登場は2023年2月1日], theme.primary),
      ([2023], [強化学習], [前半時点の理解はある], theme.info),
      ([未完], [DiffusionとTransformer], [中身の理解は怪しい], theme.warning),
    ),
    subtitle: [思ったよりもChatGPT Plusの古参だった],
  ),
  card-row-pattern(
    [Discord],
    (
      card([2018から], [#bullet-list(([ずっとDiscordにいる], [サーバー文化を見るのが好き], [言葉の寿命も気になる]))], tone: "primary"),
      card([言い換え], [#bullet-list(([Discord廃人は使いづらくなりそう], [脳死と同じく避けたい場面が増えそう], [死語になる日も近い]))], tone: "warning"),
    ),
    cols: 2,
    subtitle: [長くいる場所ほど、技術以外の変化も見えてくる],
    cell-height: none,
  ),
  card-row-pattern(
    [おすすめのサーバー],
    (
      card([AI系], [#bullet-list(([AIエージェントユーザー会], [ローカルLLMに向き合う会], [シンギュラリティ・サーバー]))], tone: "info"),
      card([言語とCS系], [#bullet-list(([ゆる言語学・コンピュータ科学サポーター], [えびまラボ秘密基地]))], tone: "accent"),
    ),
    cols: 2,
    subtitle: [興味が近い人が集まる場所はありがたい],
    cell-height: limits.card_height_lg,
  ),
  card-row-pattern(
    [参考リンク],
    (
      source-card([arukellt], "https://github.com/wogikaze/arukellt"),
      source-card([Keychron Orca echo], "https://costory.jp/cf-published-sku-groups/1955012598"),
    ),
    cols: 2,
    subtitle: [発表中に触れた外部リンク],
    cell-height: limits.card_height_md,
  ),
  closing-pattern(
    [おわりに],
    [
      自作言語、AI、キーボード、Discord、競プロを行き来しています。興味が近い話題があれば、ぜひ話しかけてください。
    ],
    subtitle: [手塚康生 / \@wogikaze],
  ),
))
