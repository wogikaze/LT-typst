# AI-Assisted Slide Workflow

Qiita記事で紹介されている Marp 用ワークフローを、Typst/Touying 向けに置き換えた手順です。

## 基本サイクル

1. 構成を作る
2. `template/main.typ` から近いレイアウトを選ぶ
3. `template/components.typ` と `template/layouts.typ` の部品で実装する
4. `mise run check` でPDFを生成する
5. 見た目を確認して、詰まりやはみ出しを直す

初回実行時に mise の trust を求められた場合は、リポジトリ内容を確認してから `mise trust` を実行します。

## エージェントに渡す情報

- 対象ファイルとスライド範囲
- スライドの目的
- 使いたいレイアウトパターン
- 変更してよい範囲
- ビルド確認の要否

## 依頼例

```text
template/main.typ の比較スライドを compare レイアウトに寄せてください。
文体は docs/style-guide.md に合わせ、情報量は増やさないでください。
最後に mise run build で確認してください。
```

```text
template/main.typ を講習会の初期雛形として使えるように、3部構成の目次と演習スライドを追加してください。
既存の template/layouts.typ のパターンを優先してください。
```

## レビュー観点

- 初学者が次に何をすればよいか分かる
- 1枚のスライドに話題が複数入りすぎていない
- コード例が読み切れるサイズに収まっている
- 比較スライドは左右の粒度がそろっている
- PDFにしたときに下部が切れていない
