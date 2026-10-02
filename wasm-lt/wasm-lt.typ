#import "../template/style.typ": apply-theme, colors, fonts, limits, sizes, space, theme
#import "../template/components.typ": *
#import "../template/layouts.typ": *

#show: apply-theme

#deck((
  title-pattern(
    [言語を超えたモジュールとしてのWasm],
    [
      Wasmを「ブラウザ用バイナリ」ではなく、言語を超えた

      モジュールとして活用する
    ],
    [荻風 \@wogikaze],
  ),
  profile-slide(
    [荻風 (\@wogikaze)],
    (
      [
        広島大学 情報科学科B2
        #v(space.sm)
        HiCoder
      ],
      [
        TypeScript / Rust
        #v(space.xs)
      ],
      [
        #profile-highlight([Arukellt])
        #text(size: sizes.body, [ — Wasm 向け自作言語を開発中])
      ],
    ),
    photo: "/assets/icon.png",
  ),
  section-pattern(
    [今、Wasm が熱い],
    [仕様の追加更新や話題が多い],
  ),
  cards-slide(
    [最近の動き],
    (
      stretchcard([Wasm 3.0], [
        Wasm 3.0 Completed（2025-09）
        #v(space.xs)
        #link-url("https://webassembly.org/news/2025-09-17-wasm-3.0/", [webassembly.org])
        #v(space.md)
        #image("/assets/image-6.png")
      ]),
      stretchcard([WASI 0.3], [
        WASI 0.3 Launched (2026-06)
        #v(space.xs)
        #text(size: sizes.small, fill: theme.text_muted, [仕様 stable / toolchain は追随中])
        #v(space.sm)
        #link-url("https://bytecodealliance.org/articles/WASI-0.3", [Bytecode Alliance])
        #v(space.md)
        #image("/assets/image-7.png")
      ]),
    ),
    subtitle: [規格とエコシステムの策定・開発が活発],
  ),
  cards-slide(
    [周辺の話題],
    (
      stretchcard([Wassette], [
        MCP 経由で Wasm Component を実行
        #v(space.sm)
        Agent tool を sandbox 化する試み（early development）
      ]),
      stretchcard([WASI HTTP], [
        HTTP handler を Component として定義
        #v(space.sm)
        #keycap([wasi:http/handler]) が共通契約になる
      ]),
      stretchcard([jco / wac], [
        Component を JS から呼ぶ・部品同士を合成する
        #v(space.sm)
        「作る」だけでなく「つなぐ」道具
      ]),
    ),
    subtitle: [Component はサーバー・エージェント・JS の境界に出てきている],
  ),
  section-pattern(
    [前提知識],
    [Core Wasm、Component Model、WASI の位置づけ],
  ),
  cards-slide(
    [Wasm(WebAssembly) とは],
    (
      stretchcard([速い], [
        ブラウザ上で実行可能な#text([バイトコード], fill: colors.accent_base, weight: 900)
        #v(space.sm)
        最適化されやすく、JS より有利なケースがある]),
      stretchcard([資産], [Rust / C / Go などのコードを移植しやすい]),
      stretchcard([安全], [Sandbox環境
        #v(space.sm)
        ファイルやネットへのアクセスは明示許可が必要]),
    ),
    subtitle: [ブラウザを飛び出す],
  ),
  content-slide(
    [いちばん単純な理解],
    [
      #align(center)[
        #image("/assets/image-10.png", height: 360pt)
      ]
    ],
    subtitle: [Core Wasm は実行形式],
  ),
  slide-frame(
    [
      #grid-cards(
        (
          stretchcard(
            [Core Wasm],
            [#compact-list(([演算命令と線形メモリ], [import で外部関数], [WASI などを呼ぶ]))],
          ),
          stretchcard(
            [Component Model],
            [#compact-list(([部品として組み合わせ], [WIT で型付き IF], [言語非依存の契約]))],
            tone: "accent",
          ),
          stretchcard(
            [WASI],
            [#compact-list(([ファイル・HTTP], [時計・乱数など]))],
            tone: "info",
          ),
        ),
        cols: 3,
      )
      #v(space.sm)
      #align(center)[#image("/assets/image-12.png", height: 280pt)]
    ],
    title: [Wasm周りの用語],
    subtitle: [今日の本題は Component Model + WIT],
  ),
  section-pattern(
    [本題],
    [言語を超えたモジュール形式として使えるか],
  ),
  compare-pattern(
    [再利用単位の変化],
    [これまで],
    (
      [ソースコード],
      [言語ランタイム依存のパッケージ],
      [ペアごとの手書き FFI],
    ),
    [これから],
    (
      [WIT で型付き契約],
      [Canonical ABI で受け渡し],
      [実行可能で閉じた部品],
    ),
    visual: "/assets/image-13.png",
    visual-height: 270pt,
    subtitle: [「どの言語で書いたか」より「どの契約を満たすか」],
  ),
  list-slide(
    [従来の Wasm の限界],
    (
      [関数境界で渡せるのは整数・浮動小数・メモリアドレス],
      [`String` / `str` / `string` ですらそのまま渡せない],
      [ポインタ・長さ・エンコードのグルーコード地獄],
    ),
    subtitle: [Wasm だけでは楽に使えるモジュールにならない],
  ),
  steps-slide(
    [Component Model が補うもの],
    (
      ([WIT], [string / list / record / resource などを言語非依存に宣言]),
      ([Canonical ABI], [各言語の表現を lower / lift して境界で受け渡し]),
      ([結果], [ポインタと ABI を人間が直接合わせなくてよい]),
    ),
    subtitle: [契約と受け渡し規約のセット],
  ),
  content-slide(
    [],
    [
      #align(center)[
        #image("/assets/image-16.png")
      ]
    ],
    subtitle: [],
  ),
  cards-slide(
    [2026 年時点の実用度],
    (
      stretchcard(
        [Component → JS],
        [
          Component → jco → JS glue
          #v(space.sm)
          Rust に限定しない JS toolchain
        ],
        tone: "success",
      ),
      stretchcard(
        [Python],
        [
          componentize-py / wasmtime-py の経路あり
          #v(space.sm)
          PoC〜限定用途は現実的
          #v(space.sm)
          制約: import / version 依存に注意
        ],
        tone: "info",
      ),
      stretchcard(
        [Go],
        [
          Go guest は進展中
          #v(space.sm)
          Go host から Component を呼ぶ体験は
          runtime / bindgen 依存
        ],
        tone: "warning",
      ),
    ),
    subtitle: [「どの言語からも同じ」ではなく、guest / host で成熟度が違う],
  ),
  slide-frame(
    [
      #grid-cards(
        (
          stretchcard([Warg / wa.dev], [
            Wasm package registry の候補
            #v(space.sm)
            まだ成熟途上
          ]),
          stretchcard([OCI Artifact], [
            OCI レジストリに Wasm Component を載せる路線
            #v(space.sm)
            CNCF Wasm OCI Artifact layout
          ]),
          stretchcard([現実解], [
            Component 本体は OCI / Warg
            #v(space.sm)
            npm・PyPI・Cargo は薄い wrapper
          ]),
        ),
        cols: 3,
      )
      #v(space.sm)
      #align(center)[#image("/assets/image-14.png", height: 280pt)]
    ],
    title: [流通の現在地],
    subtitle: [単一の Wasm npm より、既存レジストリとの併走が近い],
  ),
  cards-slide(
    [実際に試せる例],
    (
      stretchcard([jco], [
        Component を JS から呼ぶための glue を生成
        #v(space.sm)
        WIT の関数を
        `func(arg)`
        として扱える
      ]),
      stretchcard([wac], [
        Component 同士の import / export を接続
        #v(space.sm)
        小さな部品を合成して一つの Component にする
      ]),
      stretchcard(
        [Wassette],
        [
          MCPをWasm Componentでsandbox実行
          #v(space.sm)
          untrusted tool の隔離
        ],
      ),
    ),
    subtitle: [Component は「安全に呼べる部品」として使われ始めている],
  ),
  list-slide(
    [開発体験の難],
    (
      [Component / WASI / Runtime の version を揃える必要がある],
      [言語ごとに bindgen・toolchain が違う],
      [同じ string でも内部表現が違い、境界で変換コストが出る],
    ),
    subtitle: [FFIより楽だが、まだ npm ほど枯れていない],
  ),
  stacked-summary-pattern(
    [結論],
    (
      [Wasm Component は言語横断モジュールの実行形式として成立しつつある],
      [WIT + Canonical ABI は手書き FFI を減らす],
      [OCI 配布と既存 pkg レジストリの併走が現実的],
      [ツールチェインやレジストリの発展に期待],
    ),
    subtitle: none,
  ),
  content-slide(
    [その他],
    [
      #align(center)[
        #image("/assets/image-15.png", height: 350pt)
        Rust→.wasm→skybox.wasm(component)→Wasmtimeで実行\
        wasi:webgpu, surface, graphics-contextなど
      ]
    ],
    subtitle: [WasmからGPUを使ってみた],
  ),
  closing-pattern(
    [ありがとうございました],
    [
      参考リンク
      #v(space.sm)
      #link-url("https://webassembly.org/", [WebAssembly])
      #h(0.4em)
      #link-url("https://component-model.bytecodealliance.org/", [Component Model])
    ],
    subtitle: [Q&A],
  ),
))
