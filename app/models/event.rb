class Event < ApplicationRecord
  mount_uploader :image, ImageUploader

  belongs_to :user
  default_scope -> { order(created_at: :desc) }

  has_many :likes, dependent: :destroy
  has_many :liked_users, through: :likes, source: :user
  has_many :participants, dependent: :destroy
  has_many :participated_users, through: :participants, source: :user
  has_many :comments, dependent: :destroy
  has_many :notifications, dependent: :destroy

  before_validation :generate_url_token, on: :create

  validates :title, presence: true, length: { maximum: 100 }
  validates :content, presence: true, length: { maximum: 1000 }
  validates :place, presence: true, length: { maximum: 100 }
  validates :event_date, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :maximum_participants, presence: true, numericality: { only_integer: true }
  validate :maximum_participants_check
  validates :user_id, presence: true
  validates :url_token, presence: true, uniqueness: true
  validate :start_end_check

  def to_param
    url_token
  end

  def like(user)
    likes.create(user_id: user.id)
  end

  def unlike(user)
    likes.find_by(user_id: user.id).destroy
  end

  def already_liked?(user)
    liked_users.include?(user)
  end

  def already_participated?(user)
    participated_users.include?(user)
  end

  def create_notification_like!(current_user)
    temp = Notification.where(['visitor_id = ? and visited_id = ? and event_id = ? and action = ? ',
                               current_user.id, user_id, id, 'like'])

    if temp.blank?
      notification = current_user.active_notifications.new(
        visited_id: user_id,
        event_id: id,
        action: 'like'
      )
      if notification.visitor_id == notification.visited_id
        notification.checked = true
      end
      notification.save if notification.valid?
    end
  end

  def create_notification_comment!(current_user, comment_id)
    temp_ids = Comment.select(:user_id).where(event_id: id).where.not(user_id: current_user.id).distinct
    temp_ids.each do |temp_id|
      save_notification_comment!(current_user, comment_id, temp_id['user_id'])
    end
    if temp_ids.blank?
      save_notification_comment!(current_user, comment_id, user_id)
    end
  end

  def save_notification_comment!(current_user, comment_id, visited_id)
    notification = current_user.active_notifications.new(
      visited_id: visited_id,
      event_id: id,
      comment_id: comment_id,
      action: 'comment'
    )
    if notification.visitor_id == notification.visited_id
      notification.checked = true
    end
    notification.save if notification.valid?
  end

  private

  def generate_url_token
    self.url_token = SecureRandom.urlsafe_base64
  end

  def maximum_participants_check
    if maximum_participants.nil? ||
       !maximum_participants.between?(2, 50)
      errors.add(:maximum_participants,
                 :greater_than_or_equal_to_less_than_or_equal_to, { minimum: 2, maximum: 50 })
    end
  end

  def start_end_check
    late_time = [start_time, end_time].compact.max
    if !late_time.nil? && late_time == start_time
      errors.add(:end_time, :after_than_start_time)
    end
  end
end
