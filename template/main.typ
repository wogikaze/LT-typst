#import "style.typ": apply-theme, limits, theme
#import "components.typ": *
#import "layouts.typ": *

#show: apply-theme

#deck((
  title-pattern(
    [タイトルスライド],
    [サブタイトルと発表者を置く。背景は落ち着いたニュートラル面に、アクセント線で締める。],
    [株式会社サンプル / 発表者名],
  ),
  section-pattern([セクション開始スライド], [新しい章の始まりを示す。大きな見出しと短い説明だけに絞る。]),
  summary-pattern([セクション終了・まとめ], (
    [重要な論点を3点以内に絞る],
    [次の章につながる言葉で終える],
    [背景は軽く、視覚的な負荷を下げる],
  )),
  toc-pattern([目次スライド], (
    [導入と前提の共有],
    [主要な概念と比較],
    [実践パターンと演習],
  )),
  closing-pattern(
    [クロージングスライド],
    [ありがとうございました。資料URL、連絡先、次に見るべきリンクをここに置きます。],
  ),
  compare-pattern(
    [2カラム比較 Before / After],
    [Before],
    (
      [構成が毎回揺れる],
      [余白と色をその場で決める],
      [レビュー観点が見た目に寄る],
    ),
    [After],
    (
      [部品で構成を固定する],
      [トークンで見た目を制御する],
      [内容と構造をレビューできる],
    ),
  ),
  text-image-pattern(
    [2カラム テキスト＋画像],
    [テキストエリア],
    (
      [左に説明、右に画像を置く],
      [7bの左右反転も同じ部品で扱う],
      [視線誘導を変えたいときに使う],
    ),
    "assets/1.png",
  ),
  card-row-pattern(
    [3カラム 画像＋テキスト],
    (
      image-card([データ分析], "assets/1.png", [短い説明を添えます。], order: 1),
      image-card([チームワーク], "assets/2.png", [役割の違いを見せます。], order: 2),
      image-card([イノベーション], "assets/3.png", [概念を視覚化します。], order: 3),
    ),
    cols: 3,
    subtitle: [横に3枚カードを並べ、カテゴリ紹介に使う。],
    cell-height: limits.card_height_image,
  ),
  card-row-pattern(
    [3カラム アクセントカラー付き],
    (
      card([構造], [#bullet-list(([概要], [具体例], [注意点]))], tone: "primary"),
      card([強調], [#bullet-list(([概要], [具体例], [注意点]))], tone: "accent"),
      card([補足], [#bullet-list(([概要], [具体例], [注意点]))], tone: "info"),
    ),
    cols: 3,
    subtitle: [3列だが背景や線の強弱で視線を作る。],
  ),
  card-row-pattern(
    [4カラムレイアウト],
    (
      card([Phase 1], [調査する]),
      card([Phase 2], [設計する]),
      card([Phase 3], [実装する]),
      card([Phase 4], [検証する], tone: "accent"),
    ),
    cols: 4,
    subtitle: [フェーズや選択肢を同じ幅で並べる。],
  ),
  five-level-pattern([5カラム 成熟度レベル], (
    ([認知], [存在を知る]),
    ([試行], [小さく試す]),
    ([定着], [日常的に使う]),
    ([標準化], [チームで揃える]),
    ([改善], [継続的に更新する]),
  )),
  card-row-pattern(
    [2x2グリッド 画像＋テキスト],
    (
      image-card(
        [データ収集],
        "assets/1.png",
        [入力をそろえる。],
        order: 1,
        height: 62pt,
        card-height: 130pt,
        title-height: 34pt,
        body-height: 22pt,
      ),
      image-card(
        [データ整理],
        "assets/2.png",
        [構造化する。],
        order: 2,
        height: 62pt,
        card-height: 130pt,
        title-height: 34pt,
        body-height: 22pt,
      ),
      image-card(
        [仮説検証],
        "assets/3.png",
        [比較する。],
        order: 3,
        height: 62pt,
        card-height: 130pt,
        title-height: 34pt,
        body-height: 22pt,
      ),
      image-card(
        [共有],
        "assets/4.png",
        [次の行動へつなげる。],
        order: 4,
        height: 62pt,
        card-height: 130pt,
        title-height: 34pt,
        body-height: 22pt,
      ),
    ),
    cols: 2,
    subtitle: [4要素を均等配置する。],
    cell-height: 130pt,
  ),
  card-row-pattern(
    [2x3グリッドレイアウト],
    (
      card([項目1], [短い説明]),
      card([項目2], [短い説明]),
      card([項目3], [短い説明]),
      card([項目4], [短い説明]),
      card([項目5], [短い説明]),
      card([項目6], [短い説明], tone: "accent"),
    ),
    cols: 3,
    subtitle: [6つの要素を一覧化する。],
  ),
  steps-pattern([縦3ステップ], (
    ([ステップ1], [まず前提を確認します。]),
    ([ステップ2], [次に手を動かして差分を見ます。]),
    ([ステップ3], [最後にPDFで見た目を確認します。]),
  )),
  horizontal-steps-pattern([番号付きステップ 横型], (
    [素材を集める],
    [構成を決める],
    [スライド化する],
    [検証する],
  )),
  timeline-pattern([タイムラインレイアウト], (
    ([2024], [導入], [小さな資料からTypstを試す。]),
    ([2025], [展開], [テンプレートと部品を整える。]),
    ([2026], [標準化], [AIエージェントと共同編集する。]),
  )),
  icon-list-pattern([アイコン付きリスト], (
    ([重要ポイント1], [受講者が迷う箇所を先回りして説明する。], "info"),
    ([重要ポイント2], [サンプルを増やしすぎず、演習に時間を残す。], "warning"),
    ([重要ポイント3], [最後は必ずPDFで確認する。], "success"),
  )),
  card-row-pattern(
    [基本パネル 画像ヘッダー付き],
    (
      image-card([パネルタイトル1], "assets/1.png", [画像とテキストを組み合わせるカード。]),
      image-card([パネルタイトル2], "assets/2.png", [コンテンツ紹介に使う。]),
    ),
    cols: 2,
    subtitle: [画像ヘッダーの下にタイトルと説明を置く。],
    cell-height: limits.card_height_image,
  ),
  card-row-pattern(
    [強調パネル 左ボーダー付き],
    (
      callout([注意点], [重要な説明を短く入れます。], kind: "warning"),
      callout([改善後], [同じ形で並べると比較しやすい。], kind: "success"),
    ),
    cols: 2,
    subtitle: [左ボーダーで重要情報を強調する。],
  ),
  glass-pattern([ガラス風パネル], [背景を落として、中央のメッセージだけを読む状態にします。]),
  gradient-panel-pattern(
    [グラデーションパネル],
    ([濃いパネル], [強い主張を置く。]),
    ([中間パネル], [補足情報を置く。]),
    ([淡いパネル], [最後にまとめる。]),
  ),
  card-row-pattern(
    [カード型レイアウト 画像付き],
    (
      image-card([機能A], "assets/1.png", [短い説明。], order: 1),
      image-card([機能B], "assets/2.png", [短い説明。], order: 2),
      image-card([機能C], "assets/3.png", [短い説明。], order: 3),
    ),
    cols: 3,
    subtitle: [複数カードを並べることに特化したパターン。],
    cell-height: limits.card_height_image,
  ),
  full-image-pattern([背景画像全面], "assets/3.png"),
  side-image-pattern(
    [背景画像右側配置],
    [テキストエリア],
    (
      [左側に説明文を置く],
      [右側に画像を大きく配置する],
      [可読性を優先して背景面を確保する],
    ),
    "assets/3.png",
  ),
  quote-pattern(
    [引用スライド],
    [目的地を見失わないために、1スライド1メッセージを守る。],
    by: [Slide Design Note],
  ),
  split-visual-pattern([複数画像・分割背景], "assets/2.png", "assets/3.png"),
  stats-pattern([統計強調スライド], (
    ([007人], [参加者], [講習会の例], theme.primary),
    ([90%], [理解度], [アンケート例], theme.accent),
    ([3回], [演習], [手を動かす回数], theme.info),
  )),
  center-message-pattern(
    [中央配置メッセージ],
    [大きなメッセージがここに入ります。余白を残し、視線を中央に集めます。],
  ),
  qa-pattern((
    ([Email], [`example@example.com`]),
    ([X], [`@example`]),
    ([Website], [`example.com`]),
  )),
  qr-pattern(
    [QRコード付き紹介],
    [資料、アンケート、リポジトリなどへ誘導します。URLも併記しておくと読み取りに失敗しても辿れます。],
  ),
  question-pattern([問いかけスライド], [問いかけを中央に置き、観客に考える時間を作ります。]),
  quote-pattern([映画引用スライド], [ここに印象的なセリフを入れます。], by: [引用元]),
  text-image-pattern(
    [インライン画像スライド],
    [画像をランキング的に配置],
    (
      [画像と本文の距離を近くする],
      [箇条書きは短くする],
      [補足はキャプションへ逃がす],
    ),
    "assets/4.png",
    reverse: true,
  ),
  ratio-pattern(
    [統計比率スライド],
    (
      ([90%], [主要ユーザー]),
      ([9%], [時々使う]),
      ([1%], [例外ケース]),
    ),
    cols: 2,
  ),
  mixed-pattern([テキスト＋統計パネル混合], [35万], [総文字数], (
    [左に定量指標を置く],
    [右に背景や解釈を書く],
    [数字だけで終わらせない],
  )),
  stacked-summary-pattern(
    [まとめスライド 縦積み],
    (
      [要点を一文で書く。],
      [同じ粒度で並べる。],
      [次の行動につなげる。],
    ),
  ),
  card-row-pattern(
    [シンプルリスト＋補足パネル],
    (
      card([重要なこと], [#bullet-list(([リスト項目1], [リスト項目2], [リスト項目3]))]),
      callout([補足説明], [ここに前提や注意点を短く入れます。], kind: "warning"),
    ),
    cols: 2,
    subtitle: [基本構成に補足パネルを足す。],
  ),
  contrast-conclusion-pattern(
    [対比＋結論スライド],
    [概念A],
    (
      [短期的に効く],
      [個人差が大きい],
      [運用で崩れやすい],
    ),
    [概念B],
    (
      [長期的に効く],
      [チームで揃えやすい],
      [改善を継続できる],
    ),
    [このテンプレートでは、概念Bのように再利用できる構造を優先します。],
  ),
))
