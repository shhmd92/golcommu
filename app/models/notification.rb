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
