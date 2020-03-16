class Post < ApplicationRecord
  belongs_to :user
  default_scope -> { order(created_at: :desc) }
  before_validation :generate_url_token, on: :create
  mount_uploader :image, ImageUploader
  has_many :comments, dependent: :destroy
  validates :title, presence: true
  validates :content, length: { maximum: 240 }
  validates :user_id, presence: true
  validates :url_token, presence: true, uniqueness: true

  def to_param
    url_token
  end

  private

  def generate_url_token
    self.url_token = SecureRandom.urlsafe_base64
  end
end
