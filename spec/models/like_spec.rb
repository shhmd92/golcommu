# == Schema Information
#
# Table name: likes
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  event_id   :bigint
#  user_id    :bigint
#
# Indexes
#
#  index_likes_on_event_id  (event_id)
#  index_likes_on_user_id   (user_id)
#
require 'rails_helper'

RSpec.describe Like, type: :model do
  let!(:user) { create(:user) }
  let!(:other_event) { create(:event, user: user) }

  describe '検証' do
    describe 'after_createの確認' do
      example 'イベントにLikeした際の通知が１件増加すること' do
        expect do
          other_event.like(user)
        end.to change(Notification, :count).by(1)
      end
    end
  end
end
