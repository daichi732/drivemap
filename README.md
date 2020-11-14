# DriveMap
<img src="https://user-images.githubusercontent.com/56623611/97101504-5be32e80-16e1-11eb-8b40-25a2945ae971.png" width="800"  height="400">

## 概要
「DriveMap」はユーザー独自のMapを作成し、ドライブルートを簡単に決めることができるドライブ企画者向けサービスとなっております。
<br>
サイトURL：https://www.drivemap-app.com/
<br>
ワンタッチでゲストユーザーでログイン可能です。 ご確認される際はぜひご利用ください。

## 作成の背景
大学生は免許を取り始める時期であり、ドライブに行く機会が多いです。その際に「ドライブプランを作成することが難しい」という声をよく聞きました。
<br>
この悩みは私自身も感じていた部分で、せっかくの楽しいドライブが計画のミスでグダグダになって申し訳ない、と思ってしまうような日もありました。
このような経験をした人は多いはず、、、そのような人達が少しでも簡単にドライブプランを立てて安心して楽しんで欲しい、という思いからこのサービスを制作しました。

悩みの原因は、大きく2点あると考えました。
<br>
1.「人気のドライブスポットを知らないこと」
<br>
2.「行きたい場所を見つけてもそれぞれどのくらい離れていて、時間がかかるのか調べることが大変なこと」
<br><br>
そこで私は、
<br>
1.を解決するために「ユーザー同士がおすすめの場所を共有できること」
<br>
2.を解決するために「簡単にドライブルートを決めることができ、各場所の関係性が一目でわかること」
<br>
が必要だと感じ、実現しました。

## 主な利用方法
1. いいね！を押してユーザ独自のマップを作成(名称やジャンルによる検索、地図上から探すことも可能)
2. 行きたい場所をルートリストに追加
3. ドライブルートを検索
<img src="https://user-images.githubusercontent.com/56623611/98489647-3bcf7580-2272-11eb-9d8e-acad2409123b.png" width="800"  height="450">

☑️日時を指定して予定を管理することも可能！
<br>
<img src="https://user-images.githubusercontent.com/56623611/98490753-d8dfdd80-2275-11eb-9057-03f309f8b576.png" width="400"  height="250">
<img src="https://user-images.githubusercontent.com/56623611/98490760-e2694580-2275-11eb-8d92-dca19445e660.png" width="400"  height="250">


## 機能一覧
- ユーザーのCRUD機能
- 場所のCRUD機能
- 画像アップロード機能(ActiveStorage)
- ジャンル分け機能
- 検索機能(場所の名称・住所、ジャンルの指定が可能)
- ページネーション機能(kaminari)
- フォロー機能(Ajax処理)
- いいね機能(Ajax処理)
- コメント機能(Ajax処理)
- スケジュール入力機能(Ajax処理)
- スケジュールデータからカレンダー作成機能
- データからグラフ作成機能
- GoogleMapsAPIによる位置情報表示機能
  - 住所から緯度経度の取得(Geocoding API)
  - 位置情報表示(Maps Javascript API)
  - 複数地点間のルート検索、距離・時間の表示(Directions API)

## 使用技術・環境
### フロントエンド
- HTML/CSS
- SCSS
- Bootstrap4.5.2
- JavaScript、jQuery、Ajax
- Slim

### バックエンド
- Ruby2.5.1
- Rails5.2.1

### 開発環境
- PostgreSQL

### 本番環境
- MySQL2
- AWS (EC2, RDS for MySQL, S3, VPC, Route53, ALB, ACM)
- Nginx、Unicorn


### その他技術
- Git,GitHub
- Git チーム開発を意識したプルリクエストの活用
- Rubocopを導入しリンター機能の活用
- Rspecを導入しテスト記述( 単体/統合, 計172 )
- AWS ACMにてSSL証明書を発行しSSL化
- ドメインを取得し、分かりやすいURLの実装
- dotenv-rails gem を使用し環境変数を設定

## インフラ構成図
<img src="https://user-images.githubusercontent.com/56623611/98434518-c51c6600-2113-11eb-9db1-6d946906de04.jpg" width="800"  height="450">

## 今後行いたいこと
- 開発環境でDocker, docker-composeを導入
- Circle CIでCI/CDパイブラインの構築

## About me
横浜国立大学3年・理工学部・情報工学EPに所属しています。22卒で現在就職活動中です。
