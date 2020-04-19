FactoryBot.define do
  factory :like do
    association :user
    association :event
  end
end
