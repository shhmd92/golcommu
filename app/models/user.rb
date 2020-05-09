# frozen_string_literal: true

class User < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to_active_hash :prefecture

  mount_uploader :avatar, AvatarUploader

  has_many :events, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_events, through: :likes, source: :event
  has_many :participants, dependent: :destroy
  has_many :participated_events, through: :participants, source: :event
  has_many :comments, dependent: :destroy
  has_many :active_relationships, class_name: 'Relationship',
                                  foreign_key: 'follower_id',
                                  dependent: :destroy
  has_many :passive_relationships, class_name: 'Relationship',
                                   foreign_key: 'followed_id',
                                   dependent: :destroy
  has_many :following, through: :active_relationships,  source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  before_validation :generate_url_token, on: :create

  validates :username, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  validates :email, presence: true, uniqueness: { case_sensitive: false },
                    length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX }
  validates :url_token, presence: true, uniqueness: true
  validates :introduction, length: { maximum: 240 }

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  enum sex: { 未設定: 0, 男性: 1, 女性: 2 }

  enum play_type: {
    アスリート系: 1, エンジョイ系: 2, 初心者: 3
  }

  enum average_score: {
    シングル（70台）: 1, けっこう上手い（80台）: 2, わりと上手い（90台）: 3,
    まあまま（100台）: 4, まだまだ（110〜120台）: 5, ぜんぜん（130台〜）: 6
  }

  def to_param
    url_token
  end

  def follow(other_user)
    following << other_user
  end

  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  def following?(other_user)
    following.include?(other_user)
  end

  def update_without_current_password(params, *options)
    params.delete(:current_password)

    if params[:password].blank? && params[:password_confirmation].blank?
      params.delete(:password)
      params.delete(:password_confirmation)
    end

    result = update(params, *options)
    clean_up_passwords
    result
  end

  def self.ages
    ages = {
      age10: { id: 1, min: 0, max: 19, name: '10代以下' },
      age20: { id: 2, min: 20, max: 29, name: '20代' },
      age30: { id: 3, min: 30, max: 39, name: '30代' },
      age40: { id: 4, min: 40, max: 49, name: '40代' },
      age50: { id: 5, min: 50, max: 59, name: '50代' },
      age60: { id: 6, min: 60, max: 200, name: '60代以上' }
    }
  end

  def get_ages
    ages_name = '不明'
    if birth_date?
      age = (Date.today.strftime('%Y%m%d').to_i - birth_date.strftime('%Y%m%d').to_i) / 10_000
      User.ages.each_value do |value|
        min = value[:min].to_i
        max = value[:max].to_i
        ages_name = value[:name] if age.between?(min, max)
      end
    end
    ages_name
  end

  private

  def generate_url_token
    self.url_token = SecureRandom.urlsafe_base64
  end
end
