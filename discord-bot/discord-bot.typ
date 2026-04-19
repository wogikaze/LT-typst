#import "../template/style.typ": apply-theme, limits, radius, space, theme
#import "../template/components.typ": *
#import "../template/layouts.typ": *

#show: apply-theme

#deck((
  title-pattern(
    [Discord Bot 講習会],
    [0から動くBotを一緒に作ろう],
    [広島大学コンピュータサークル HiCoder​],
    aside: image("assets/logo-1.png", width: 140pt, fit: "contain"),
  ),
  section-pattern(
    [この講習のゴール],
    [タイマーBotを完成させてDiscord Botを理解する],
  ),
  toc-pattern(
    [目次],
    (
      [Discord Botとは],
      [リポジトリのクローンと環境構築],
      [Developer PortalとToken生成],
      [権限設定と招待URL],
      [コードの流れと動作確認],
      [起動確認とタイマーBot],
    ),
  ),
  compare-pattern(
    [Discord Bot とは],
    [一般的なアカウント],
    (
      [人間がログインして操作する前提のアカウント],
      [ブラウザや公式クライアントで操作する],
      [プログラムによる自動操作は規約違反],
    ),
    left-tone: "default",
    [Botアカウント],
    (
      [APIとイベントで動くプログラムが操作する],
      [人が導入しないとサーバーに関与できない],
      [開発者がTokenを管理する],
    ),
    right-tone: "primary",
  ),
  slide-frame(
    [
      #grid-cards(
        (
          card([モデレーション], [#bullet-list(([キックやロール管理], [自動削除], [通報の補助]))]),
          card([通知], [#bullet-list(([リマインダ], [メール通知], [監視アラート]))]),
          card([対話], [#bullet-list(([FAQ応答], [AIチャット], [チャット]))]),
        ),
        cols: 3,
        cell-height: limits.card_height_md,
      )
      #v(space.lg)
      #align(center)[
        #caption([通信の流れ（例） — ユーザー → Discord → Bot → Discord → ユーザー])
      ]
      #v(space.xs)
      #box(
        width: 100%,
        fill: theme.surface,
        stroke: (paint: theme.border, thickness: 0.8pt),
        radius: radius,
        inset: 14pt,
        clip: true,
      )[
        #image(
          "assets/svg/discord-message-flow.svg",
          width: 100%,
          height: 168pt,
          fit: "contain",
        )
      ]
    ],
    title: [Botでできること],
    subtitle: [様々な用途で使えるが、今回はシンプルな機能を実装する],
  ),
  section-pattern(
    [今回つくるもの],
    [指定した時間に通知するタイマーボット],
  ),
  steps-pattern(
    [開発の流れ],
    (
      ([Portalで準備], [アプリとBotユーザーを作り、トークンを控える]),
      ([環境を作る], [リポジトリをクローンし、依存関係を入れる]),
      ([接続を確認する], [招待URLで導入し、ログと権限を見ながら動かす]),
    ),
  ),
  card-row-pattern(
    [そろえるもの],
    (
      card([実行環境], [#bullet-list(([Python], [ターミナル], [git]))]),
      card([アカウント], [#bullet-list(([Discord],))]),
      card([エディタ], [#bullet-list(([VSCodeなど], [(メモ帳はやめた方がいい)]))]),
    ),
    cols: 3,
    subtitle: [不足があれば、インストールや登録をしてください],
    cell-height: limits.card_height_md,
  ),
  section-pattern(
    [Discord Developers にログイン],
    [Discordと同じアカウントでサインインできる],
  ),
  steps-pattern(
    [ポータルでの最初の一歩],
    (
      ([ログイン], [ブラウザで開発者ポータルを開き、ログインまで進める]),
      ([アプリケーション], [新規作成し、名前だけ決めて保存する]),
      ([Bot], [Botユーザーを追加し、後でTokenを扱う]),
    ),
  ),
  slide-frame(
    [
      #grid(
        columns: (1fr, 1fr),
        column-gutter: space.lg,
        align: top,
        box(
          width: 100%,
          stroke: (paint: theme.border, thickness: 0.8pt),
          radius: radius,
          inset: 10pt,
          clip: true,
        )[
          #image("assets/developer-portal-0.png", width: 100%, height: 200pt, fit: "contain")
        ],
        box(
          width: 100%,
          stroke: (paint: theme.border, thickness: 0.8pt),
          radius: radius,
          inset: 10pt,
          clip: true,
        )[
          #image("assets/developer-portal-1.png", width: 100%, height: 360pt, fit: "contain")
        ],
      )
    ],
    title: [Developer Portal — アプリケーションを作成],
    subtitle: [ログインとアプリ作成],
  ),
  slide-frame(
    align(center)[
      #box(width: 100%, clip: true)[
        #image("assets/developer-portal-2.png", width: 100%, height: 380pt, fit: "contain")
      ]
    ],
    title: [Developer Portal — 名前を付ける],
    subtitle: none,
  ),
  slide-frame(
    align(center)[
      #box(width: 100%, clip: true)[
        #image("assets/developer-portal-3.png", width: 100%, height: 380pt, fit: "contain")
      ]
    ],
    title: [Developer Portal — トークンをコピー],
    subtitle: none,
  ),
  slide-frame(
    align(center)[
      #box(width: 100%, clip: true)[
        #image("assets/developer-portal-4.png", width: 100%, height: 380pt, fit: "contain")
      ]
    ],
    title: [Developer Portal — 権限設定その1],
    subtitle: none,
  ),
  slide-frame(
    align(center)[
      #box(width: 100%, clip: true)[
        #image("assets/developer-portal-5.png", width: 100%, height: 380pt, fit: "contain")
      ]
    ],
    title: [Developer Portal — 権限設定その2],
    subtitle: none,
  ),
  slide-frame(
    [
      #grid-cards(
        (
          card(
            [危険な例],
            bullet-list((
              [チャットに貼る],
              [スクリーンショットに写す],
              [共有リポジトリにそのまま置く],
            )),
            tone: "danger",
          ),
          card(
            [安全な例],
            bullet-list((
              [.envにだけ書く],
              [.gitignoreで除外する],
              [漏れたらすぐ再発行する],
            )),
            tone: "success",
          ),
        ),
        cols: 2,
        cell-height: none,
      )
      #v(space.lg)
      #callout(
        [漏えいしたら / 再発行],
        [
          #prose([
            Tokenはいつでも作り直せる。漏洩が疑わしいと思ったら迷わず再発行する。古いものは無効になる。
          ])
        ],
        kind: "danger",
      )
    ],
    title: [Tokenの扱い],
  ),
  slide-frame(
    [
      #grid(
        columns: (1fr, 1fr),
        column-gutter: space.lg,
        align: top,
        box(
          width: 100%,
          stroke: (paint: theme.border, thickness: 0.8pt),
          radius: radius,
          inset: 10pt,
          clip: true,
        )[
          #image("assets/discord-0.png", width: 100%, height: 200pt, fit: "contain")
        ],
        box(
          width: 100%,
          stroke: (paint: theme.border, thickness: 0.8pt),
          radius: radius,
          inset: 10pt,
          clip: true,
        )[
          #image("assets/discord-1.png", width: 100%, height: 360pt, fit: "contain")
        ],
      )
    ],
    title: [サーバーを作り、Botを導入する],
  ),
  slide-frame(
    [
      #grid(
        columns: (1fr, 1fr),
        column-gutter: space.lg,
        align: top,
        box(
          width: 100%,
          stroke: (paint: theme.border, thickness: 0.8pt),
          radius: radius,
          inset: 10pt,
          clip: true,
        )[
          #image("assets/discord-2.png", width: 100%, height: 200pt, fit: "contain")
        ],
        box(
          width: 100%,
          stroke: (paint: theme.border, thickness: 0.8pt),
          radius: radius,
          inset: 10pt,
          clip: true,
        )[
          #image("assets/discord-3.png", width: 100%, height: 360pt, fit: "contain")
        ],
      )
    ],
    title: [サーバーを作り、Botを導入する],
  ),
  section-pattern(
    [git clone と開発環境の準備],
    [リポジトリを手元に取り込み、実行してみる],
  ),
  slide-frame(
    align(center)[
      #box(width: 100%, clip: true)[
        #image("/assets/image-5.png", width: 100%, height: 380pt, 
        fit: "contain")
      ]
    ],
    title: [git clone と開発環境の準備],
    subtitle: none,
  ),
  steps-pattern(
    [起動までの確認],
    (
      ([.env を用意する], [.env-example を .env にコピーし、`BOT_TOKEN=` の行にトークンを貼る]),
      ([Python で起動する], [ターミナルで `uv run python main.py` を実行し、エラーなく起動することを確認する]),
      ([Discord で状態を見る], [Discord をリロードし、Bot がオンラインになっていることを確認する]),
      ([スラッシュコマンドで疎通する], [`/hello` を送り、Bot が反応することを確認する]),
    ),
  ),
  slide-frame(
    align(center)[
      #box(width: 100%, clip: true)[
        #image("assets/code-0.png", width: 100%, height: 420pt, fit: "contain")
      ]
    ],
    title: [コードの中身を追う],
  ),
  section-pattern(
    [タイマー Bot を作ってみよう],
    [`timer.py` に手を入れて、指定時刻にメンション通知する],
  ),
  slide-frame(
    [
      #grid-cards(
        (
          card(
            [parse_time(timestr)],
            [
              #prose([`HH:MM` 形式の文字列から、次に来るその時刻の `datetime` を返す。])
            ],
            tone: "info",
          ),
          card(
            [timer_task(…)],
            [
              #prose([
                `async def timer_task(channel_id, user_id, target_time):` — 指定時刻まで待機し、チャンネルへメンション付きで通知する。
              ])
            ],
            tone: "primary",
          ),
        ),
        cols: 2,
        cell-height: none,
      )
    ],
    title: [既に定義されているもの],
    subtitle: [変数・ヘルパーはこのまま使い、空いているフックだけ埋める],
  ),
  steps-pattern(
    [実装する関数],
    (
      ([on_ready], [起動時に一度だけ走る処理。ログや初期化に使う]),
      ([timer], [`/timer` スラッシュコマンド。`interaction` と `time: str` を受け取る]),
    ),
  ),
  slide-frame(
    callout(
      [timer のヒント],
      [
        #prose([
          `timer_task` が要求する引数（チャンネル・ユーザー・目標時刻など）をそろえ、`asyncio.create_task(...)` で非同期タスクとして起動する。
        ])
      ],
      kind: "warning",
    ),
    title: [非同期タスクのつなぎ方],
    subtitle: [イベントループ上でブロックしないようにする],
  ),
  slide-frame(
    align(center)[
      #box(width: 100%, clip: true)[
        #image("assets/code-1.png", width: 100%, height: 520pt, fit: "contain")
      ]
    ],
    title: [],
  ),
  slide-frame(
    [
      #align(center)[
        #image("assets/discord-7.png", width: 100%, height: 420pt, fit: "contain")
      ]
    ],
    title: [実際に動かしてみよう],
    subtitle: [`/timer time:10:30` のように入力し、指定した時刻にメンション付きのメッセージが届くことを確認する],
  ),
  closing-pattern(
    [お疲れさまでした!],
    [
      Discord Bot の開発の基礎はマスターできました。あとはアイデア次第で、いろいろな Bot が作れます。続きの演習ではスラッシュコマンドとデプロイにも進めます。
    ],
    subtitle: [次のステップへ],
  ),
))
