Faker::Config.locale = :en

# 管理ユーザー作成
admin = User.create!(username: "管理者",
                     email: "admin@example.com",
                     password:              "adminpassword",
                     password_confirmation: "adminpassword",
                     confirmed_at: Time.zone.now,
                     confirmation_sent_at: Time.zone.now,
                     admin: true)

# ゲストユーザー作成
User.create!(username: "ゲスト",
             email: "guest@example.com",
             password:              "guestpassword",
             password_confirmation: "guestpassword",
             confirmed_at: Time.zone.now,
             confirmation_sent_at: Time.zone.now)

# 一般ユーザ作成
60.times do |n|
  username = Faker::Name.unique.name
  email = "test#{n+1}@example.com"
  password = "password"
  User.create!(username: username,
               email: email,
               password: password,
               password_confirmation: password,
               confirmed_at: Time.zone.now,
               confirmation_sent_at: Time.zone.now,
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
