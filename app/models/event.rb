# == Schema Information
#
# Table name: events
#
#  id                   :bigint           not null, primary key
#  address              :string(255)
#  content              :text(65535)
#  end_time             :time
#  event_date           :date
#  image                :string(255)
#  maximum_participants :integer          default(0)
#  place                :string(255)
#  start_time           :time
#  title                :string(255)
#  url_token            :string(255)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  course_id            :integer
#  user_id              :bigint
#
# Indexes
#
#  index_events_on_user_id                 (user_id)
#  index_events_on_user_id_and_created_at  (user_id,created_at)
#
class Event < ApplicationRecord
  mount_uploader :image, ImageUploader

  belongs_to :user
  default_scope -> { order(event_date: :desc) }

  has_many :likes, dependent: :destroy
  has_many :liked_users, through: :likes, source: :user
  has_many :participants, dependent: :destroy
  has_many :participated_users, through: :participants, source: :user
  has_many :comments, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :event_invitations, dependent: :destroy

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
  validate :event_date_check
  validate :start_end_check

  LIKE_ACTION = 'like'.freeze
  PARTICIPATE_ACTION = 'participate'.freeze
  COMMENT_ACTION = 'comment'.freeze
  INVITE_ACTION = 'invite'.freeze
  CLOSE_ACTION = 'close'.freeze

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

  def participate(user)
    participants.create(user_id: user.id)
  end

  def stop_participate(user)
    participants.find_by(user_id: user.id).destroy
  end

  def already_participated?(user)
    participated_users.include?(user)
  end

  def create_notification_invite!(user_id)
    invite_notification = Notification.search_notification(user.id, user_id, id, INVITE_ACTION)

    if invite_notification.blank?
      notification = user.active_notifications.new(
        visited_id: user_id,
        event_id: id,
        action: INVITE_ACTION
      )
      if notification.valid?
        notification.save!

        event_invitation = EventInvitation.new(
          event_id: id,
          invited_user_id: user_id,
          invitation_status: EventInvitation::UNCONFIRMED
        )
        event_invitation.save! if event_invitation.valid?
      end
    end
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

  def event_date_check
    errors.add(:event_date, :after_than_today) if event_date < Date.today
  end

  def start_end_check
    late_time = [start_time, end_time].compact.max
    if !late_time.nil? && late_time == start_time
      errors.add(:end_time, :after_than_start_time)
    end
  end
end
