# == Schema Information
#
# Table name: events
#
#  id                   :bigint           not null, primary key
#  address              :string(255)
#  content              :text(65535)
#  end_time             :time
#  event_date           :date
#  image                :string(255)
#  maximum_participants :integer          default(0)
#  place                :string(255)
#  start_time           :time
#  title                :string(255)
#  url_token            :string(255)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  course_id            :integer
#  user_id              :bigint
#
# Indexes
#
#  index_events_on_user_id                 (user_id)
#  index_events_on_user_id_and_created_at  (user_id,created_at)
#
FactoryBot.define do
  factory :event do
    title { 'title' }
    content { 'content' }
    place { 'place' }
    address { 'address' }
    course_id { 12_345 }
    maximum_participants { 5 }
    event_date { Date.today }
    start_time { Time.zone.now }
    end_time { Time.zone.now + 360 }
    image { "#{Rails.root}/spec/fixtures/test.png" }
    url_token { SecureRandom.urlsafe_base64 }
    association :user

    trait :with_participants do
      transient do
        participants_count { 5 }
      end

      after(:create) do |event, evaluator|
        create_list(:participant, evaluator.participants_count, { event: event, user: event.user })
      end
    end

    trait :with_comments do
      transient do
        comments_count { 5 }
      end

      after(:create) do |event, evaluator|
        create_list(:comment, evaluator.comments_count, { event: event, user: event.user })
      end
    end

    trait :with_likes do
      transient do
        likes_count { 5 }
      end

      after(:create) do |event, evaluator|
        create_list(:like, evaluator.likes_count, { event: event, user: event.user })
      end
    end

    trait :invalid do
      title nil
    end

    trait :update_title do
      title { 'update title' }
    end
  end
end
