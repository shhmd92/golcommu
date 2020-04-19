FactoryBot.define do
  factory :event do
    title { 'title' }
    content { 'content' }
    maximum_participants { 5 }
    event_date { Date.today }
    start_time { Time.zone.now }
    end_time { Time.zone.now + 360 }
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
  end
end
