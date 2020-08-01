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

  after_create :create_notification_participate!

  private

  def create_notification_participate!
    participant_notification = Notification.search_notification(user_id, event.user_id, event_id, Event::PARTICIPATE_ACTION)

    unless user_id == event.user_id
      if participant_notification.blank?
        notification = user.active_notifications.new(
          visited_id: event.user_id,
          event_id: event_id,
          action: Event::PARTICIPATE_ACTION
        )
        notification.save! if notification.valid?
      end
    end
  end
end
