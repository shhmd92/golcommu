FactoryBot.define do
  factory :comment do
    content { 'コメントテスト' }
    association :event
    association :user
  end
end
