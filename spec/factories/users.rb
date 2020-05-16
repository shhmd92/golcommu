FactoryBot.define do
  factory :user do
    sequence(:username) { |n| "sample#{n}" }
    sequence(:email) { |n| "sample#{n}@example.com" }
    password { 'foobar' }
    sex { 1 }
    birth_date { Date.new(1990, 1, 1) }
    prefecture_id { 1 }
    play_type { 3 }
    average_score { 6 }
    introduction { 'introduction' }
    confirmed_at { Date.today }

    trait :guest do
      username { 'guest' }
      email    { 'guest@example.com' }
      password { 'guestpassword' }
      guest    { true }
    end

    trait :admin do
      username { 'admin' }
      email    { 'admin@example.com' }
      password { 'adminpassword' }
      admin    { true }
    end
  end
end
