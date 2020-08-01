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
class Like < ApplicationRecord
  belongs_to :event
  belongs_to :user
  validates :event_id, uniqueness: { scope: :user_id }

  after_create :create_notification_like!

  private

  def create_notification_like!
    like_notification = Notification.search_notification(user_id, user_id, event_id, Event::LIKE_ACTION)

    if like_notification.blank?
      notification = user.active_notifications.new(
        visited_id: event.user_id,
        event_id: event_id,
        action: Event::LIKE_ACTION
      )
      notification.save! if notification.valid?
    end
  end
end
