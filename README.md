# typst-template

Touying + Metropolis ベースの Typst テンプレートです。AIエージェントと共同でスライドを育てる前提で、スタイルガイド、レイアウトパターン、`.agents` のスキル、`mise` タスクを同梱しています。

## ファイル構成

- `template/`: 新しいスライドにコピーして使う雛形
- `template/main.typ`: テンプレートのエントリポイント
- `template/style.typ`: 色、余白、タイポグラフィのトークン
- `template/components.typ`: パネル、統計表示、リンクなどの部品
- `template/layouts.typ`: 比較、3カード、セクション開始などのレイアウト
- `mise.toml`: ルート用のビルド・監視・検証タスク
- `.agents/`: エージェント向けのスキル、プロンプト、参照メモ
- `docs/style-guide.md`: スライドデザインの判断基準

## 前提

- Typst CLI
- mise
- フォント `Noto Sans CJK JP`
- ネットワーク接続（初回の `@preview` package 取得時）

Typst をシステムに入れていない場合は、利用環境に合わせてインストールしてください。`mise.toml` はタスク定義に集中しており、Typst のインストール自体は固定していません。

## 使い方

初回だけ、mise にこのリポジトリの設定を信頼させます。

```bash
mise trust
```

### 1. テンプレートをビルド

```bash
mise run build
```

出力先は `build/template/main.pdf` です。

### 2. 監視しながら開発

```bash
mise run watch
```

### 3. テンプレート単体を検証

```bash
mise run template
```

### 4. 全体チェック

```bash
mise run check
```

## テンプレートとして使う

`template/` を別ディレクトリにコピーして使います。

```bash
cp -r template my-slides
cd my-slides
mise run build
```

コピー先では `template/mise.toml` がそのまま使えます。シェルスクリプトは置かず、ビルド・監視・クリーンアップは `mise` タスクに集約しています。

## AIエージェントとの作業

Qiita記事「AIエージェントと協働してmarpでスライドを作る2026」の考え方を Typst 向けに移植し、`DESIGN.md` の配色とタイポグラフィへ統合しています。基本方針は次の通りです。

1. **デザインの意図**は `.agents/skills/impeccable`・`layout` など（一覧は `.agents/skills/README.md`）を主とする
2. `docs/style-guide.md` でデザイン判断を言語化する
3. `template/main.typ` と `template/layouts.typ` の既存パターンを優先する
4. **Typst への落とし込み・ビルド確認・SVG**は `typst-style` / `typst-layout-check` / `typst-svg` で補う
5. 見た目の確認は `mise run check` でPDFを生成してから行う

エージェントに依頼する例（デザイン主 → 実装従）:

```text
まず .agents/skills/layout でスライドの余白と階層を整理し、そのあと .agents/skills/typst-style で template と docs/style-guide.md に沿って直して
```

```text
.agents/skills/typst-layout-check で mise run check し、PDF の下部切れや詰まりを直して
```

## 文体ルール

- スライドタイトルではコロンを避ける
- 感嘆符、疑問符、装飾的な絵文字を避ける
- アクセントカラーは1スライドあたり1から2色までにする
- 長い説明文より、短い見出しと具体例を優先する

## レイアウト制約

- カードタイトルは最大2行、本文は最大3行または60文字
- 1カラムのbulletは最大3個
- 1スライドの要素数は最大6個
- Before/Afterは `danger` / `success` で意味を分ける
- 背景画像はoverlay必須、テキスト幅60%以下

## 注意

- `link_url` は `#link_url("URL", "表示名")` の形で呼びます。
- `@preview/touying` の初回取得にはネットワーク接続が必要です。
- 生成物は `build/` に出力され、Git管理から除外されます。
