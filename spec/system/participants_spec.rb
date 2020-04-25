require 'rails_helper'

RSpec.describe 'Participants', type: :system do
  let!(:user) { create(:user) }
  let!(:event) { create(:event, user: user) }

  example 'イベントの参加、参加取りやめができること' do
    test_event = event
    test_user = create(:user)

    sign_in(test_user)

    within("#eventList-body-title-#{test_event.id}") do
      click_link test_event.title
    end

    # create
    expect do
      find('#participates-event-btn').click
      expect(find('#participant-tab')).to have_content "参加者(1／#{test_event.maximum_participants})"
    end.to change(test_event.participants, :count).by(1)

    # destroy
    expect do
      find('#stop-participates-event-btn').click
      expect(find('#participant-tab')).to have_content "参加者(0／#{test_event.maximum_participants})"
    end.to change(test_event.participants, :count).by(-1)
  end
end
