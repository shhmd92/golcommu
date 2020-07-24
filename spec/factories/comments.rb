# == Schema Information
#
# Table name: comments
#
#  id         :bigint           not null, primary key
#  content    :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  event_id   :bigint
#  user_id    :bigint
#
# Indexes
#
#  index_comments_on_event_id  (event_id)
#  index_comments_on_user_id   (user_id)
#
FactoryBot.define do
  factory :comment do
    content { 'コメントテスト' }
    association :event
    association :user
  end
end
