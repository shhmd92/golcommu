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
class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :event

  has_many :notifications, dependent: :destroy

  validates :content, presence: true, length: { maximum: 240 }

  after_create :create_notification_comment!

  private

  def create_notification_comment!
    visited_ids = Comment.select(:user_id).where(event_id: event_id).where.not(user_id: user_id).distinct
    visited_ids.each do |visited_id|
      save_notification_comment!(visited_id['user_id'])
    end
    save_notification_comment!(event.user_id) unless user_id == event.user_id
  end

  def save_notification_comment!(visited_id)
    notification = user.active_notifications.new(
      visited_id: visited_id,
      event_id: event_id,
      comment_id: id,
      action: Event::COMMENT_ACTION
    )
    notification.save! if notification.valid?
  end
end
