require 'rails_helper'

RSpec.describe Comment, type: :model do
  let!(:user) { create(:user) }
  let!(:event) { create(:event, user: user) }
  let!(:comment) { create(:comment, event: event, user: user) }

  describe '検証' do
    describe '存在性の検証' do
      example '入力必須項目が設定されていれば有効であること' do
        comment = Comment.new(
          content: 'content',
          event: event,
          user: user
        )
        expect(comment).to be_valid
      end

      example 'contentが設定されていなければ無効であること' do
        comment.content = nil
        comment.valid?
        expect(comment.errors).to be_added(:content, :blank)
      end
    end

    describe '文字数の検証' do
      example 'contentが240文字以下なら有効であること' do
        comment.content = 'a' * 240
        expect(comment).to be_valid
      end

      example 'contentが240文字を超えるなら無効であること' do
        comment.content = 'a' * 241
        comment.valid?
        expect(comment.errors).to be_added(:content, :too_long, count: 240)
      end
    end
  end
end
