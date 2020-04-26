FactoryBot.define do
  factory :participant do
    association :event
    association :user
  end
end
