require 'rails_helper'

RSpec.describe 'Comments', type: :system do
  let!(:user) { create(:user) }
  let!(:event) { create(:event, user: user) }

  example 'コメントの投稿、削除ができること' do
    test_event = event
    test_user = test_event.user
    test_comment = create(:comment, content: 'first comment', event: test_event, user: test_user)

    sign_in(test_user)

    within("#eventList-body-title-#{test_event.id}") do
      click_link test_event.title
    end

    fill_in 'input-content-area', with: 'second comment'

    # create
    expect do
      find('#send-comment').click
      expect(page).to have_content 'second comment'
      expect(find('#comment-tab')).to have_content 'コメント(2件)'
    end.to change(test_event.comments, :count).by(1)

    # destroy
    expect do
      find("#delete-comment-#{test_comment.id}").click
      expect(page).not_to have_content 'first comment'
      expect(find('#comment-tab')).to have_content 'コメント(1件)'
    end.to change(test_event.comments, :count).by(-1)
  end
end
