Faker::Config.locale = :en

# 管理ユーザー作成
admin = User.create!(username: "admin",
                     email: "admin@example.com",
                     password:              "adminpassword",
                     password_confirmation: "adminpassword",
                     confirmed_at: Time.zone.now,
                     confirmation_sent_at: Time.zone.now,
                     admin: true)

# ゲストユーザー作成
User.create!(username: "guest",
             email: "guest@example.com",
             password:              "guestpassword",
             password_confirmation: "guestpassword",
             confirmed_at: Time.zone.now,
             confirmation_sent_at: Time.zone.now,
             guest: true)

# 一般ユーザ作成
60.times do |n|
  username = Faker::Japanese::Name.name
  email = "sample#{n+1}@example.com"
  password = "password"
  sex = rand(0..2)
  s1 = Date.parse("1950/01/01")
  s2 = Date.parse("2010/12/31")
  birth_date = Random.rand(s1 .. s2)
  prefecture = rand(1..47)
  play_type = rand(1..3)
  if (play_type == 3)
    average_score = rand(5..6)
  else
    average_score = rand(1..6)
  end
  User.create!(username: username,
               email: email,
               password: password,
               password_confirmation: password,
               confirmed_at: Time.zone.now,
               confirmation_sent_at: Time.zone.now,
               sex: sex,
               birth_date: birth_date,
               prefecture: prefecture,
               introduction: "紹介文紹介文紹介文紹介文紹介文紹介文紹介文紹介文紹介文",
               play_type: play_type,
               average_score: average_score,
               )
end

# リレーションシップ
users = User.all
user  = users.first
following = users[2..50]
followers = users[3..40]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }

# 投稿
users = User.order(:created_at).take(6)
50.times do
  title = Faker::Sports::Basketball.player
  content = Faker::Lorem.sentence(5)
  users.each { |user| user.events.create!(title: title,
                                         content: content) }
end

# イベント参加者
