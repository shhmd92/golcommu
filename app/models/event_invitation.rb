# == Schema Information
#
# Table name: event_invitations
#
#  id                :bigint           not null, primary key
#  invitation_status :integer          not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  event_id          :integer          not null
#  invited_user_id   :integer          not null
#
# Indexes
#
#  index_event_invitations_on_event_id         (event_id)
#  index_event_invitations_on_invited_user_id  (invited_user_id)
#
class EventInvitation < ApplicationRecord
  belongs_to :event
  belongs_to :invited_user, class_name: 'User',
                            foreign_key: 'invited_user_id'

  UNCONFIRMED = 0
  ACCEPTED = 1
  REJECTED = 2

  scope :search_invitation, lambda { |event_id, user_id|
    find_by(
      {
        event_id: event_id,
        invited_user_id: user_id
      }
    )
  }
end
