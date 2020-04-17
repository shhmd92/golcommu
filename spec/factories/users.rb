FactoryBot.define do
  factory :user do
    sequence(:username) { |n| "sample#{n}" }
    sequence(:email) { |n| "sample#{n}@example.com" }
    password { 'foobar' }
    sex { 1 }
    birth_date { Date.new(1990, 1, 1) }
    prefecture { 1 }
    play_type { 3 }
    average_score { 6 }
    introduction { 'はじめまして。初心者ゴルファーです。' }
    confirmed_at { Date.today }
  end
end
