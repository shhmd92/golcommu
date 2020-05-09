Faker::Config.locale = :en

# admin user
admin = User.create!(username: "admin",
                     email: "admin@example.com",
                     password:              "adminpassword",
                     password_confirmation: "adminpassword",
                     confirmed_at: Time.zone.now,
                     confirmation_sent_at: Time.zone.now,
                     admin: true)

# guest user
User.create!(username: "guest",
             email: "guest@example.com",
             password:              "guestpassword",
             password_confirmation: "guestpassword",
             confirmed_at: Time.zone.now,
             confirmation_sent_at: Time.zone.now,
             guest: true)

# general user
60.times do |n|
  username = Faker::Japanese::Name.name
  email = "sample#{n+1}@example.com"
  password = "password"
  sex = rand(0..2)
  s1 = Date.parse("1950/01/01")
  s2 = Date.parse("2010/12/31")
  birth_date = Random.rand(s1 .. s2)
  prefecture_id = rand(1..47)
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
               prefecture_id: prefecture_id,
               introduction: "紹介文紹介文紹介文紹介文紹介文紹介文紹介文紹介文紹介文",
               play_type: play_type,
               average_score: average_score,
               )
end

# relationship
users = User.all
user  = users.first
following = users[2..50]
followers = users[3..40]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }

# event
users = User.order(:created_at).take(6)
50.times do
  title = Faker::Sports::Basketball.player
  content = Faker::Lorem.sentence(5)
  s1 = Date.parse("2020/04/01")
  s2 = Date.parse("2020/06/30")
  event_date = Random.rand(s1 .. s2)
  maximum_participants = 4 * rand(1..5)
  users.each { |user| user.events.create!(title: title,
                                         content: content,
                                         event_date: event_date,
                                         maximum_participants: maximum_participants) }
end

# participant
