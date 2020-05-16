require 'rails_helper'

RSpec.describe User, type: :model do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }

  describe '検証' do
    describe '存在性の検証' do
      example '入力必須項目が設定されていれば有効であること' do
        user = User.new(
          username: 'sampleUser',
          email: 'sample@example.com',
          password: 'password',
          url_token: SecureRandom.urlsafe_base64
        )
        expect(user).to be_valid
      end

      example 'usernameが設定されていなければ無効であること' do
        user.username = nil
        user.valid?
        expect(user.errors).to be_added(:username, :blank)
      end

      example 'emailが設定されていなければ無効であること' do
        user.email = nil
        user.valid?
        expect(user.errors).to be_added(:email, :blank)
      end

      example 'passwordが設定されていなければ無効であること' do
        user.password = user.password_confirmation = ' ' * 6
        user.valid?
        expect(user.errors).to be_added(:password, :blank)
      end

      example 'url_tokenが設定されていなければ無効であること' do
        user.url_token = nil
        user.valid?
        expect(user.errors).to be_added(:url_token, :blank)
      end
    end

    describe '一意性の検証' do
      example 'emailが重複していれば無効であること' do
        other_user.email = user.email
        other_user.valid?
        expect(other_user.errors).to be_added(:email, :taken, value: user.email)
      end

      example 'emailの大文字と小文字を区別しないこと' do
        other_user.email = user.email.upcase
        other_user.valid?
        expect(other_user.errors).to be_added(:email, :taken, value: user.email)
      end

      example 'url_tokenが重複していれば無効であること' do
        other_user.url_token = user.url_token
        other_user.valid?
        expect(other_user.errors).to be_added(:url_token, :taken, value: user.url_token)
      end
    end

    describe '文字数の検証' do
      example 'usernameが50文字以下なら有効であること' do
        user.username = 'a' * 50
        expect(user).to be_valid
      end

      example 'usernameが50文字を超えるなら無効であること' do
        user.username = 'a' * 51
        user.valid?
        expect(user.errors).to be_added(:username, :too_long, count: 50)
      end

      example 'emailが255文字以下なら有効であること' do
        user.email = "#{'a' * 243}@example.com"
        expect(user).to be_valid
      end

      example 'emailが255文字を超えるなら無効であること' do
        user.email = "#{'a' * 244}@example.com"
        user.valid?
        expect(user.errors).to be_added(:email, :too_long, count: 255)
      end

      example 'passwordが6文字以上なら有効であること' do
        user.password = user.password_confirmation = 'a' * 6
        expect(user).to be_valid
      end

      example 'passwordが6文字未満なら無効であること' do
        user.password = user.password_confirmation = 'a' * 5
        user.valid?
        expect(user.errors).to be_added(:password, :too_short, count: 6)
      end

      example 'passwordが128文字以下なら有効であること' do
        user.password = user.password_confirmation = 'a' * 128
        expect(user).to be_valid
      end

      example 'passwordが128文字を超えるなら無効であること' do
        user.password = user.password_confirmation = 'a' * 129
        user.valid?
        expect(user.errors).to be_added(:password, :too_long, count: 128)
      end

      example 'introductionが240文字以下なら有効であること' do
        user.introduction = 'a' * 240
        expect(user).to be_valid
      end

      example 'introductionが240文字を超えるなら無効であること' do
        user.introduction = 'a' * 241
        user.valid?
        expect(user.errors).to be_added(:introduction, :too_long, count: 240)
      end
    end

    describe 'フォーマットの検証' do
      example 'emailが正当なフォーマットなら有効であること' do
        emails = %w[sample@example.com sample123@example.com SAMPLE@example.COM
                    sa_mple@example.com sa-mple@abc.example.com sa.ample@example.com
                    sa+mple@example.com sa_mp_le+123.SAMPLE@123.ex-ample.com]
        emails.each do |email|
          user.email = email
          expect(user).to be_valid
        end
      end

      example 'emailが不正なフォーマットなら無効であること' do
        emails = %w[sあmple@example.com sample１２３@example.com sample@exあmple.com
                    sample@１２３.example.com @example.com sample@example
                    sample@example. sample@example_com sample@example+com]
        emails.each do |email|
          user.email = email
          user.valid?
          expect(user.errors).to be_added(:email, :invalid, value: email)
        end
      end
    end
  end

  describe 'メソッド' do
    example 'フォローとアンフォローが正常に動作すること' do
      expect(user.following?(other_user)).to be_falsey
      user.follow(other_user)
      expect(user.following?(other_user)).to be_truthy
      user.unfollow(other_user)
      expect(user.following?(other_user)).to be_falsey
    end

    example 'フォローした際の通知が１件増加すること' do
      expect do
        other_user.create_notification_follow!(user)
      end.to change(Notification, :count).by(1)
    end

    example '年代が空白とならないこと' do
      expect(user.get_ages).not_to eq nil
      user.birth_date = nil
      expect(user.get_ages).not_to eq nil
    end
  end

  describe '関連性' do
    example 'ユーザーを削除すると関連するイベントも削除されること' do
      event = create(:event, user: user)
      expect do
        user.destroy
      end.to change(Event, :count).by(-1)
    end

    example 'ユーザーを削除すると関連するイベントの参加情報も削除されること' do
      event = create(:event, :with_participants, participants_count: 1, user: user)
      expect do
        user.destroy
      end.to change(Participant, :count).by(-1)
    end

    example 'ユーザーを削除すると関連するイベントのコメントも削除されること' do
      event = create(:event, :with_comments, comments_count: 1, user: user)
      expect do
        user.destroy
      end.to change(Comment, :count).by(-1)
    end

    example 'ユーザーを削除すると関連するイベントのLikeも削除されること' do
      event = create(:event, :with_likes, likes_count: 1, user: user)
      expect do
        user.destroy
      end.to change(Like, :count).by(-1)
    end

    example 'ユーザーを削除すると関連するフォロー関係も削除されること' do
      user.follow(other_user)
      expect do
        user.destroy
      end.to change(other_user.followers, :count).by(-1)
    end

    example 'ユーザーを削除すると関連するフォロワー関係も削除されること' do
      other_user.follow(user)
      expect do
        user.destroy
      end.to change(other_user.following, :count).by(-1)
    end

    example 'フォロー後にユーザーを削除すると関連する通知も削除されること' do
      other_user.create_notification_follow!(user)
      expect do
        user.destroy
      end.to change(Notification, :count).by(-1)
    end
  end
end
