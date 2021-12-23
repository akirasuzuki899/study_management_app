# Study Management App

## 概要
継続的な学習をサポートする web アプリケーションです。<br>
使いやすさにこだわって作成しました（詳細は「工夫した点」セクションをご参照ください）<br>
ゲストログインから簡単にアプリをお試しください！<br>
URL：https://study-management-app.com<br><br>

## サービスのイメージ
<br>

![DEMO](demo.gif "DEMO")
<br><br><br>

## AWS構成図
<br>

![AWS](AWS.png "AWS")
<br><br><br>


## ER図
<br>

![ER](ER.png "ER")
<br><br><br>


## 使用した技術
| フロントエンド  | バックエンド  | インフラ |
| :--- | :--- | :--- |
| Vue 2.6.13 | Ruby 2.7.2 | Docker |
| Nuxt.js 2.15.6 | Rails 6.1.3 | CircleCI |
| Vuetify 2.5.3 | RSpec / Rubocop | AWS |
<br>


## 機能一覧
| 週間スケジュール |
| :--- |
* 学習予定の CRUD
* 学習予定をドラッグ&ドロップで更新
* 学習予定のブラックアウト（学習時間が記録された予定）
* 学習時間の記録、更新
* 学習時間が記録されていない予定の一覧表時、再登録
* 週間スケジュールの表示範囲の変更（カレンダー操作対応）
<br><br>

| 週間スケジュールのテンプレート |
| :--- |
* テンプレートの CRUD
* テンプレートをドラッグ&ドロップで更新
* テンプレートを週間スケジュールへ反映
<br><br>

| サマリー |
| :--- |
* 学習履歴のグラフ
  * 積み上げ棒グラフ（教材ごとの学習時間）
  * 円グラフ（教材ごとの時間配分）
* 凡例
  * 積み上げ棒グラフ（教材名、学習時間）
  * 円グラフ（教材名、学習時間、学習時間の割合）
* グラフの表示範囲の変更（日、週、月）
<br><br>

| ノート |
| :--- |
* ノートの CRUD
* 閲覧モード,編集モードの切り替え
* 使用できるツール
  * 画像投稿（active storage を用いたダイレクトアップロード）
  * ヘッダー
  * マーカー
  * リンク
  * フォントウェイト
  * 斜体
  * リスト
  * チェックリスト
<br><br>

| マンダラチャート |
| :--- |
* コンテンツの CRUD（マンダラチャートの1マス）
* 外部サイト遷移（コンテンツに追加した URL）
* アイコンの表示（URLの登録、コンテンツの達成で各アイコンを表示）
* ノート
<br><br>

| 教材 |
| :--- |
* 教材の検索と追加（楽天ブックス書籍検索APIを使用）
* 教材の一覧表示
* ノート
<br><br>

| タイムライン |
| :--- |
* 当日の学習予定の一覧表示
* 学習時間の記録、更新
* 学習予定のブラックアウト（学習時間が記録された予定）
<br><br>


## 工夫した点
| 機能 |
| :--- |
* グラフデータの操作を、ORM機能を使わずに生のSQLで記述した（TIMESTAMPDIFF関数、DATE関数、INNER JOIN、GROUP BY の使用）
* スケジュールの特定の時間をクリックすることで、学習予定作成フォームに自動で時間が入力される
* 学習予定をドラッグ&ドロップで更新できる
* テンプレート機能により、学習予定を毎週一つずつ作成する手間を省ける
* 未学習予定を一覧表示することで、学習の進捗状況を簡単に把握できる
* 学習時間が記録されている予定の色を暗めにすることで、未学習予定が一目見てわかる
* スケジュールの表示範囲を一週間ごとに変更するボタンと自由に指定できるカレンダーを実装した
* ディスプレイの横幅が 600px 以上の時、未学習予定の一覧とカレンダーを常時表示できる

| UI/UX |
| :--- |
* レスポンシブデザインに対応し、様々なデバイスで使用できるようにした
（デバイスのサイズによってデザインが崩れないように専用のデザインを用意した）
* 既存アプリの UI/UX を分析し、参考にできる箇所をアプリに取り入れた
* フロントエンドに Vue と Vuetify、バックエンドに Ruby on Rails を用いて完全SPA化し、UXを向上させた
* Vuetify ではできない細かいデザインの調整を css で行い、アプリ全体で統一感のあるデザインにした
* 特定のデータが無い時にユーザーを誘導するボタンを表示<br>
  *  当日の予定がない時&emsp;→&emsp;タイムライン上に週間スケジュールへの誘導ボタンを表示させた<br>
  *  教材がない時&emsp;&emsp;&emsp;&emsp;→&emsp;タイムライン、教材メモ、教材一覧上に教材登録への誘導ボタンを表示<br>

| インフラ |
| :--- |
 * CircleCI, Amazon ECR, AWS Fargate, Slack を連携し、デプロイの工数を削減して開発効率を向上させた

| その他 |
| :--- |
 * 公式ドキュメントでわからないことがあれば（フレームワークのロジックを詳細に知りたいとき等）、github のソースコードを調査した
 * docker コンテナ内での操作(rspec のテスト実行やデータベースの確認)を shell script で簡略化した
 * コンポーネント指向によって、パーツの再利用性と保守性を意識した
