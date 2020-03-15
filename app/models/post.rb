class Post < ApplicationRecord
  belongs_to :user
  default_scope -> { order(created_at: :desc) }
  mount_uploader :image, ImageUploader
  validates :title, presence: true
  validates :content, length: { maximum: 240 }
  validates :user_id, presence: true
end
