# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  admin                  :boolean          default(FALSE)
#  avatar                 :string(255)
#  average_score          :integer
#  birth_date             :date
#  confirmation_sent_at   :datetime
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  guest                  :boolean          default(FALSE)
#  introduction           :text(65535)
#  play_type              :integer
#  rate                   :float(24)
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string(255)
#  sex                    :integer          default("未設定")
#  unconfirmed_email      :string(255)
#  url_token              :string(255)
#  username               :string(255)      default(""), not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  prefecture_id          :integer
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
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
