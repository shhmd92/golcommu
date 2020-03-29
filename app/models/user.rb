# frozen_string_literal: true

class User < ApplicationRecord
  mount_uploader :avatar, AvatarUploader

  has_many :events, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_events, through: :likes, source: :event
  has_many :participants, dependent: :destroy
  has_many :participant_events, through: :participants, source: :event
  has_many :comments, dependent: :destroy
  has_many :active_relationships,  class_name: 'Relationship',
                                   foreign_key: 'follower_id',
                                   dependent: :destroy
  has_many :passive_relationships, class_name: 'Relationship',
                                   foreign_key: 'followed_id',
                                   dependent: :destroy
  has_many :following, through: :active_relationships,  source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  validates :username, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 50 }

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  # プレータイプ
  enum play_type: {
    アスリート系: 1, エンジョイ系: 2, 初心者: 3
  }

  # アベレージスコア
  enum average_score: {
    シングル（70台）: 1, けっこう上手い（80台）: 2, わりと上手い（90台）: 3,
    まあまま（100台）: 4, まだまだ（110〜120台）: 5, ぜんぜん（130台〜）: 6
  }

  def to_param
    username
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

  def already_liked?(event)
    likes.exists?(event_id: event.id)
  end

  def already_participated?(event)
    participants.exists?(event_id: event.id)
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
end
