class Event < ApplicationRecord
  mount_uploader :image, ImageUploader

  belongs_to :user
  default_scope -> { order(created_at: :desc) }

  has_many :likes, dependent: :destroy
  has_many :liked_users, through: :likes, source: :user
  has_many :participants
  has_many :participant_users, through: :participants, source: :user
  has_many :comments, dependent: :destroy

  before_validation :generate_url_token, on: :create

  validates :title, presence: true, length: { maximum: 50 }
  validates :content, presence: true, length: { maximum: 240 }
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

  private

  def generate_url_token
    self.url_token = SecureRandom.urlsafe_base64
  end

  def start_end_check
    errors.add(:end_time, 'が不正です') if start_time > end_time
  end
end
