# == Schema Information
#
# Table name: notifications
#
#  id         :bigint           not null, primary key
#  action     :string(255)      default(""), not null
#  checked    :boolean          default(FALSE), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  comment_id :integer
#  event_id   :integer
#  visited_id :integer          not null
#  visitor_id :integer          not null
#
# Indexes
#
#  index_notifications_on_comment_id  (comment_id)
#  index_notifications_on_event_id    (event_id)
#  index_notifications_on_visited_id  (visited_id)
#  index_notifications_on_visitor_id  (visitor_id)
#
class Notification < ApplicationRecord
  scope :search_notification, lambda { |visitor_id, visited_id, event_id, action|
    where(
      {
        visitor_id: visitor_id,
        visited_id: visited_id,
        event_id: event_id,
        action: action
      }
    )
  }
  default_scope -> { order(created_at: :desc) }
  belongs_to :event, optional: true
  belongs_to :comment, optional: true

  belongs_to :visitor, class_name: 'User',
                       foreign_key: 'visitor_id',
                       optional: true
  belongs_to :visited, class_name: 'User',
                       foreign_key: 'visited_id',
                       optional: true
end
