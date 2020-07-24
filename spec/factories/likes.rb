# == Schema Information
#
# Table name: likes
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  event_id   :bigint
#  user_id    :bigint
#
# Indexes
#
#  index_likes_on_event_id  (event_id)
#  index_likes_on_user_id   (user_id)
#
FactoryBot.define do
  factory :like do
    association :user
    association :event
  end
end
