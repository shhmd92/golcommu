# == Schema Information
#
# Table name: participants
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  event_id   :bigint
#  user_id    :bigint
#
# Indexes
#
#  index_participants_on_event_id  (event_id)
#  index_participants_on_user_id   (user_id)
#
require 'rails_helper'

RSpec.describe Participant, type: :model do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:event) { create(:event, user: user) }
  let!(:other_event) { create(:event, user: other_user) }

  describe '検証' do
    describe 'after_createの確認' do
      example '自分が主宰したイベントに参加した際は通知が増加しないこと' do
        expect do
          event.participate(user)
        end.to change(Notification, :count).by(0)
      end

      example '他の主催者のイベントに参加した際の通知が１件増加すること' do
        expect do
          other_event.participate(user)
        end.to change(Notification, :count).by(1)
      end
    end
  end
end
