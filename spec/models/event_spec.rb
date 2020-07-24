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
require 'rails_helper'

RSpec.describe Event, type: :model do
  let!(:user) { create(:user) }
  let!(:event) { create(:event, user: user) }
  let!(:other_event) { create(:event, user: user) }
  let!(:comment) { create(:comment, event: event, user: user) }

  describe '検証' do
    describe '存在性の検証' do
      example '入力必須項目が設定されていれば有効であること' do
        event = Event.new(
          title: 'title',
          content: 'content',
          place: 'place',
          maximum_participants: 5,
          event_date: Date.today,
          start_time: Time.zone.now,
          end_time: Time.zone.now + 360,
          user: user,
          url_token: SecureRandom.urlsafe_base64
        )
        expect(event).to be_valid
      end

      example 'titleが設定されていなければ無効であること' do
        event.title = nil
        event.valid?
        expect(event.errors).to be_added(:title, :blank)
      end

      example 'contentが設定されていなければ無効であること' do
        event.content = nil
        event.valid?
        expect(event.errors).to be_added(:content, :blank)
      end

      example 'placeが設定されていなければ無効であること' do
        event.place = nil
        event.valid?
        expect(event.errors).to be_added(:place, :blank)
      end

      example 'url_tokenが設定されていなければ無効であること' do
        event.url_token = nil
        event.valid?
        expect(event.errors).to be_added(:url_token, :blank)
      end
    end

    describe '一意性の検証' do
      example 'url_tokenが重複していれば無効であること' do
        other_event.url_token = event.url_token
        other_event.valid?
        expect(other_event.errors).to be_added(:url_token, :taken, value: event.url_token)
      end
    end

    describe '文字数の検証' do
      example 'titleが100文字以下なら有効であること' do
        event.title = 'a' * 100
        expect(event).to be_valid
      end

      example 'titleが100文字を超えるなら無効であること' do
        event.title = 'a' * 101
        event.valid?
        expect(event.errors).to be_added(:title, :too_long, count: 100)
      end

      example 'contentが1000文字以下なら有効であること' do
        event.content = 'a' * 1000
        expect(event).to be_valid
      end

      example 'contentが1000文字を超えるなら無効であること' do
        event.content = 'a' * 1001
        event.valid?
        expect(event.errors).to be_added(:content, :too_long, count: 1000)
      end
    end

    describe '人数の検証' do
      example 'maximum_participantsが50人以下なら有効であること' do
        event.maximum_participants = 50
        expect(event).to be_valid
      end

      example 'maximum_participantsが50人を超えるなら無効であること' do
        event.maximum_participants = 51
        event.valid?
        expect(event.errors).to be_added(:maximum_participants,
                                         :greater_than_or_equal_to_less_than_or_equal_to, { minimum: 2, maximum: 50 })
      end

      example 'maximum_participantsが1人なら無効であること' do
        event.maximum_participants = 1
        event.valid?
        expect(event.errors).to be_added(:maximum_participants,
                                         :greater_than_or_equal_to_less_than_or_equal_to, { minimum: 2, maximum: 50 })
      end
    end

    describe '整合性の検証' do
      example 'event_dateがシステム日付以降なら有効であること' do
        event.event_date = Date.today
        expect(event).to be_valid

        event.event_date = Date.today + 1
        expect(event).to be_valid
      end

      example 'event_dateがシステム日付より前なら無効であること' do
        event.event_date = Date.today - 1
        event.valid?
        expect(event.errors).to be_added(:event_date, :after_than_today)
      end

      example 'end_timeがstart_timeより後なら有効であること' do
        event.start_time = Time.zone.now
        event.end_time = event.start_time + 60
        expect(event).to be_valid
      end

      example 'end_timeがstart_timeより前なら無効であること' do
        event.start_time = Time.zone.now
        event.end_time = event.start_time - 60
        event.valid?
        expect(event.errors).to be_added(:end_time, :after_than_start_time)
      end

      example 'end_timeがstart_timeと同じなら無効であること' do
        event.start_time = Time.zone.now
        event.end_time = event.start_time
        event.valid?
        expect(event.errors).to be_added(:end_time, :after_than_start_time)
      end
    end
  end

  describe 'メソッド' do
    example 'Like機能が正常に動作すること' do
      expect(other_event.already_liked?(user)).to be_falsey
      other_event.like(user)
      expect(other_event.already_liked?(user)).to be_truthy
      other_event.unlike(user)
      expect(other_event.already_liked?(user)).to be_falsey
    end

    example 'イベント参加機能が正常に動作すること' do
      expect(other_event.already_participated?(user)).to be_falsey
      other_event.participate(user)
      expect(other_event.already_participated?(user)).to be_truthy
      other_event.stop_participate(user)
      expect(other_event.already_participated?(user)).to be_falsey
    end

    example 'イベントにLikeした際の通知が１件増加すること' do
      expect do
        event.create_notification_like!(user)
      end.to change(Notification, :count).by(1)
    end

    example 'イベントに参加した際の通知が１件増加すること' do
      expect do
        event.create_notification_participate!(user)
      end.to change(Notification, :count).by(1)
    end

    example 'イベントにコメントした際の通知が１件増加すること' do
      expect do
        event.create_notification_comment!(user, comment.id)
      end.to change(Notification, :count).by(1)
    end
  end

  describe '関連性' do
    example 'イベントを削除すると関連する参加者も削除されること' do
      event = create(:event, :with_participants, participants_count: 1, user: user)
      expect do
        event.destroy
      end.to change(Participant, :count).by(-1)
    end

    example 'イベントを削除すると関連するコメントも削除されること' do
      event = create(:event, :with_comments, comments_count: 1, user: user)
      expect do
        event.destroy
      end.to change(Comment, :count).by(-1)
    end

    example 'イベントを削除すると関連するLikeも削除されること' do
      event = create(:event, :with_likes, likes_count: 1, user: user)
      expect do
        event.destroy
      end.to change(Like, :count).by(-1)
    end

    example 'イベントを削除すると関連する通知も削除されること' do
      expect do
        event.destroy
      end.to change(Notification, :count).by(-1)
    end
  end
end
