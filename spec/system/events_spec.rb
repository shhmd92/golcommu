require 'rails_helper'

RSpec.describe 'Events', type: :system do
  let!(:user) { create(:user) }
  let!(:event) { create(:event, user: user) }

  context 'イベント作成成功' do
    example 'イベントの作成、編集、削除ができること' do
      sign_in(user)

      # new event
      click_link 'イベント作成'

      fill_in 'event[title]', with: 'title'
      fill_in 'event[event_date]', with: Date.today
      select '07', from: 'event[start_time(4i)]'
      select '30', from: 'event[start_time(5i)]'
      select '17', from: 'event[end_time(4i)]'
      select '30', from: 'event[end_time(5i)]'
      fill_in 'event[maximum_participants]', with: 10
      fill_in 'event[content]', with: 'content'
      attach_file 'event[image]', "#{Rails.root}/spec/fixtures/test.png", make_visible: true

      click_button '更新'
      expect(page).to have_content 'イベントを作成しました'

      # update event
      within('#event-edit-btn') do
        click_link '編集'
      end

      fill_in 'event[title]', with: 'title'
      fill_in 'event[event_date]', with: Date.today
      select '07', from: 'event[start_time(4i)]'
      select '30', from: 'event[start_time(5i)]'
      select '17', from: 'event[end_time(4i)]'
      select '30', from: 'event[end_time(5i)]'
      fill_in 'event[maximum_participants]', with: 10
      fill_in 'event[content]', with: 'content'
      attach_file 'event[image]', "#{Rails.root}/spec/fixtures/test.png", make_visible: true

      click_button '更新'
      expect(page).to have_content 'イベントを更新しました'
    end

    example 'イベント詳細画面からイベントの削除が成功すること' do
      test_event = event
      test_user = test_event.user

      sign_in(test_user)

      within("#eventList-body-title-#{test_event.id}") do
        click_link test_event.title
      end

      within("#modal-btn-#{test_event.id}") do
        click_link '削除'
      end

      expect(page).to have_content 'イベントを削除しました'
    end

    example 'トップ画面からイベントの削除が成功すること' do
      test_event = event
      test_user = test_event.user

      sign_in(test_user)

      within("#modal-btn-#{test_event.id}") do
        click_link '削除'
      end

      expect(page).to have_content 'イベントを削除しました'
    end
  end

  context 'イベント作成失敗' do
    example 'イベントの作成が失敗すること' do
      sign_in(user)

      # new event
      click_link 'イベント作成'

      # imageの設定がないとエラーが発生するため一旦設定する
      attach_file 'event[image]', "#{Rails.root}/spec/fixtures/test.png", make_visible: true

      click_button '更新'
      aggregate_failures do
        expect(page).to have_content 'タイトルを入力してください'
        expect(page).to have_content '詳細を入力してください'
        expect(page).to have_content '最大参加可能人数を入力してください'
        expect(page).to have_content '最大参加可能人数は数値で入力してください'
        expect(page).to have_content '最大参加可能人数は1以上50以下の値にしてください'
      end
    end

    example 'トップ画面からイベントの編集が失敗すること' do
      test_event = event
      test_user = test_event.user

      sign_in(test_user)

      within("#eventList-btn-#{test_event.id}") do
        click_link '編集'
      end

      fill_in 'event[title]', with: ''
      # imageの設定がないとエラーが発生するため一旦設定する
      attach_file 'event[image]', "#{Rails.root}/spec/fixtures/test.png", make_visible: true

      click_button '更新'
      expect(page).to have_content 'タイトルを入力してください'
    end
  end
end
