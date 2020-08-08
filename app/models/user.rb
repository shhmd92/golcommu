# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  admin                  :boolean          default(FALSE)
#  avatar                 :string(255)
#  average_score          :integer
#  birth_date             :date
#  confirmation_sent_at   :datetime
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  guest                  :boolean          default(FALSE)
#  introduction           :text(65535)
#  play_type              :integer
#  rate                   :float(24)
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string(255)
#  sex                    :integer          default("未設定")
#  unconfirmed_email      :string(255)
#  url_token              :string(255)
#  username               :string(255)      default(""), not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  prefecture_id          :integer
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
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
  has_many :active_notifications, class_name: 'Notification',
                                  foreign_key: 'visitor_id',
                                  dependent: :destroy
  has_many :passive_notifications, class_name: 'Notification',
                                   foreign_key: 'visited_id',
                                   dependent: :destroy
  has_many :invited_events, class_name: 'EventInvitation',
                            foreign_key: 'invited_user_id',
                            dependent: :destroy

  before_validation :generate_url_token, on: :create

  validates :username, presence: true, length: { maximum: 50 }
  validates :email, presence: true, uniqueness: { case_sensitive: false },
                    length: { maximum: 255 }
  validates :url_token, presence: true, uniqueness: true
  validates :introduction, length: { maximum: 240 }

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :async

  scope :invitable_users, lambda { |event|
    joins('INNER JOIN relationships ON users.id = relationships.followed_id')
      .where(relationships: { follower_id: event.user_id })
      .where.not(relationships:
          { followed_id:
            Notification
              .where(event_id: event.id)
              .where(action: Event::INVITE_ACTION)
              .select('visited_id') })
  }

  enum sex: {
    未設定: 0, 男性: 1, 女性: 2
  }

  enum play_type: {
    アスリート系: 1, エンジョイ系: 2, 初心者: 3
  }

  enum average_score: {
    シングル（70台）: 1, けっこう上手い（80台）: 2, わりと上手い（90台）: 3,
    まあまま（100台）: 4, まだまだ（110〜120台）: 5, ぜんぜん（130台〜）: 6
  }

  FOLLOW_ACTION = 'follow'

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

  def create_notification_follow!(current_user)
    follow_notification = Notification.search_notification(current_user.id, id, nil, FOLLOW_ACTION)

    if follow_notification.blank?
      notification = current_user.active_notifications.new(
        visited_id: id,
        action: FOLLOW_ACTION
      )
      notification.save if notification.valid?
    end
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
