# ゴルコミュ
ゴルフイベントを作成したり、ゴルフイベントに参加できるサービスです。

## リンク
https://www.golcommu.com/

![application-image](https://user-images.githubusercontent.com/60833258/82720459-c6391280-9cee-11ea-9c56-7b5aaa2d89a1.png)

お試しログインよりゲストユーザーとして各種機能をお試しになれます。
※ゲストユーザーはプロフィール編集ができないようになっております。
&nbsp;&nbsp;プロフィール編集機能もお試しになられる場合は、以下のアカウントでログインしてください。
&nbsp;&nbsp;Eメール：```sample1@example.com```
&nbsp;&nbsp;パスワード：```password```

## 機能一覧
* ユーザー登録・編集・ログイン機能(devise)
* 画像アップロード機能(carrierwave)
* イベント検索機能(ransack,楽天API)
* イベント登録・編集機能(楽天API)
* イベント参加機能
* イベント当日の天気表示(OpenWeatherMapAPI)
* イベント招待機能
* ユーザー検索機能
* いいね(気になるボタン)機能（非同期）
* フォロー機能（非同期）
* コメント機能（非同期）
* ページネーション機能（kaminari）
* 通知機能

## 使用技術
* Ruby 2.7.0
* Rails 5.2.4
* Bootstrap,Sass,jQuery
* MySQL 5.7
* AWS(VPC / EC2 / ELB / RDS / S3 / CloudFront / Route53 / ACM)
* Docker
* CircleCI(CI/CD)
* Capistrano
* Rspec

## AWS構成図
![aws_architecture](https://user-images.githubusercontent.com/60833258/89730445-90980000-da79-11ea-9dc4-07d9283880cd.png)
