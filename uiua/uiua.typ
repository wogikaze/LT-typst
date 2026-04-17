#import "../template/style.typ": apply-theme, limits, radius, space, theme
#import "../template/components.typ": *
#import "../template/layouts.typ": *

#show: apply-theme

#deck((
  title-pattern(
    [奇妙な言語Uiua],
    [スタックベース、配列志向、記号まみれの言語],
    [wogikaze],
  ),
  question-pattern(
    [まずはコードの例を見てみよう],
    [一瞬で奇妙さがわかる],
  ),
  slide-frame(
    title: [何をするコードでしょうか？],
    subtitle: [Uiuaのホームページに載っているコード],
    image("assets/0.png", width: 100%),
  ),
  slide-frame(
    title: [何をするコードでしょうか？],
    align(center, image("assets/1.png", height: 90%)),
  ),
  toc-pattern(
    [目次],
    subtitle: [],
    (
      [Uiuaの奇妙さ],
      [Uiuaの便利そうなところ],
      [まとめ],
    ),

    image: image("assets/logo.png", width: 50%), // 表示されてない。表示させる
  ),
  slide-frame(
    [
      Uiuaは記号まみれの言語で、コードを見ても何をしているのか分かりにくい
      #v(space.md)
      まずはシンプルなコードで説明する
      #v(space.md)
      #image("assets/2.png", width: 100%)
    ],
    title: [奇妙さ その1 - 記号まみれ],
  ),
  slide-frame(
    [
      Uiuaは記号まみれの言語で、コードを見ても何をしているのか分かりにくい
      #v(space.md)
      まずはシンプルなコードで説明する
      #v(space.md)
      #image("assets/2.png", width: 100%)

      ↑実は、記号は等価な英語キーワードが設定されている。
      #v(space.lg)
      フォーマットすると記号になる
    ],
    title: [奇妙さ その1 - 記号まみれ],
  ),
  slide-frame(
    [
      #image("assets/3.png", width: 100%)
    ],
    title: [奇妙さ その1 - 記号まみれ],
  ),
  slide-frame(
    [
      #image("assets/3.png", width: 100%)
      #v(space.md)
      戻しすぎ!!
    ],
    title: [奇妙さ その1 - 記号まみれ],
  ),
  slide-frame(
    [
      #image("assets/3.png", width: 100%)
      #v(space.md)
      戻しすぎ!!
      #image("/assets/image-4.png", width: 50%)
      #v(space.md)
      ↑MN-Coreのアセンブリを思い出した
    ],
    title: [奇妙さ その1 - 記号まみれ],
  ),
  slide-frame(
    [
      #image("assets/4.png", width: 100%)
    ],
    title: [奇妙さ その1 - 記号まみれ],
  ),
  slide-frame(
    subtitle: [これと同じ動きをするC言語のコード],
    [
      #image("assets/5.png", width: 70%)
    ],
    title: [奇妙さ その1 - 記号まみれ],
  ),
  slide-frame(
    [
      #image("assets/4.png", width: 100%)
      #v(space.lg)
      こちらのほうが読みやすい...?
    ],
    title: [奇妙さ その1 - 記号まみれ],
  ),
  slide-frame(
    title: [奇妙さ その2 - スタックマシン],
    subtitle: [右から左に処理する],
    image("assets/6.png", width: 100%),
  ),
  section-pattern(
    [便利そうな点],
    [この言語は実用できるのか？],
  ),
  card-row-pattern(
    [Uiuaの便利そうな点],
    (
      card([シンプル], [#bullet-list(([配列中心], [webで実行できる], [language server]))], tone: "primary"),
      card([簡単な音声/画像出力], [#bullet-list(([processing的な], [オーディオ], [`Bad Apple`]))], tone: "accent"),
      card([使う], [#bullet-list(([Crate.ioにある], [AtCoderで使える]))], tone: "info"),
      image("/assets/image-1.png", height: 50%),
    ),
    cols: 3,
    cell-height: none,
    subtitle: [],
  ),
  slide-frame(
    [#align(center, [
      しっかりとしたドキュメントがある!!
      #image("/assets/image-2.png", width: 50%)
      記号の解説が主な異様なドキュメント
    ])],
    title: [Uiuaの便利そうな点],
  ),
  qa-pattern((
    ([変数は?], [`var ← 1`で使える]),
    ([ライブラリやモジュール], [`~ "git: url/path"` でサポート]),
    ([デバッグは?], [debug print: `##` debug: `?`]),
  )),
  slide-frame(
    image("/assets/image-3.png", width: 100%),
    title: [デバッグの例],
  ),
  full-image-pattern(
    [やっぱり奇妙],
    image("assets/http.png", width: 100%, height: 100%),
    body: [背景はhttp serverのコード。初見で読めるわけがない],
  ),
  text-image-pattern(
    [おわりに],
    [まとめ],
    (
      [スタックベースで、配列志向で、記号まみれ],
      [一見すると奇妙だが、慣れると便利そう],
      [独特の思想に基づいて設計されている],
      [とはいえv0.18が最新の不安定な新興言語],
    ),
    [
      #image("assets/Kala.png")
      Uiuaのマスコットキャラクター、Kala
      #v(space.md)
      人工言語のToki Ponaの生みの親さんがデザインしたキャラクター
    ],
    col-ratio: (5fr, 3fr),
    subtitle: [奇妙にも見えるが、ネタ言語ではなく実用できる言語],
  ),
))
