Faker::Config.locale = :ja

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
  email = email = "test#{n+1}@example.com"
  password = "password"
  User.create!(username: username,
               email: email,
               password: password,
               password_confirmation: password,
               confirmed_at: Time.zone.now,
               confirmation_sent_at: Time.zone.now,
               )
end