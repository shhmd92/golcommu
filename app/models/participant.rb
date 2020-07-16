# == Schema Information
#
# Table name: participants
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  event_id   :bigint
#  user_id    :bigint
#
# Indexes
#
#  index_participants_on_event_id  (event_id)
#  index_participants_on_user_id   (user_id)
#
class Participant < ApplicationRecord
  belongs_to :event
  belongs_to :user
  validates :event_id, uniqueness: { scope: :user_id }
end
